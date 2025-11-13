/*******************************************************************************
 * @file TestAppleKeychainHandler.cpp
 * @brief Unit Test File for the AppleKeychainHandler source file
 *******************************************************************************
 * # License
 * <b>Copyright 2025 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#include <lib/core/StringBuilderAdapters.h>
#include <pw_unit_test/framework.h>

#include <AppleKeychainHandler.h>

#include <app/SubscriptionsInfoProvider.h>
#include <credentials/FabricTable.h>
#include <credentials/PersistentStorageOpCertStore.h>
#include <credentials/TestOnlyLocalCertificateAuthority.h>
#include <credentials/tests/CHIPCert_test_vectors.h>
#include <crypto/CHIPCryptoPAL.h>
#include <crypto/PersistentStorageOperationalKeystore.h>
#include <lib/asn1/ASN1.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/TestPersistentStorageDelegate.h>
#include <platform/ConfigurationManager.h>

#include <map>
#include <set>

using namespace chip;
using namespace chip::app::Silabs;

namespace {

// Official Apple Keychain vendor ID from the CSA database
static constexpr uint16_t kAppleKeychainVendorId = 4996;

class MockSubscriptionsInfoProvider : public chip::app::SubscriptionsInfoProvider
{
public:
    bool FabricHasAtLeastOneActiveSubscription(FabricIndex fabricIndex)
    {
        return activeSubscriptions.find(fabricIndex) != activeSubscriptions.end();
    }

    bool SubjectHasActiveSubscription(FabricIndex aFabricIndex, NodeId subjectID)
    {
        return activeSubscriptions.find(aFabricIndex) != activeSubscriptions.end() &&
            activeSubscriptions.at(aFabricIndex).find(subjectID) != activeSubscriptions.at(aFabricIndex).end();
    }

    bool SubjectHasPersistedSubscription(FabricIndex aFabricIndex, NodeId subjectID)
    {
        return persistedSubscriptions.find(aFabricIndex) != persistedSubscriptions.end() &&
            persistedSubscriptions.at(aFabricIndex).find(subjectID) != persistedSubscriptions.at(aFabricIndex).end();
    }

    void AddActiveSubscription(FabricIndex fabricIndex, NodeId subjectID) { activeSubscriptions[fabricIndex].insert(subjectID); }

    void AddPersistedSubscription(FabricIndex fabricIndex, NodeId subjectID)
    {
        persistedSubscriptions[fabricIndex].insert(subjectID);
    }

private:
    std::map<FabricIndex, std::set<NodeId>> activeSubscriptions;
    std::map<FabricIndex, std::set<NodeId>> persistedSubscriptions;
};

class ScopedFabricTable
{
public:
    ScopedFabricTable() {}
    ~ScopedFabricTable()
    {
        mFabricTable.Shutdown();
        mOpCertStore.Finish();
        mOpKeyStore.Finish();
    }

    CHIP_ERROR Init(chip::TestPersistentStorageDelegate * storage)
    {
        chip::FabricTable::InitParams initParams;
        initParams.storage             = storage;
        initParams.operationalKeystore = &mOpKeyStore;
        initParams.opCertStore         = &mOpCertStore;

        ReturnErrorOnFailure(mOpKeyStore.Init(storage));
        ReturnErrorOnFailure(mOpCertStore.Init(storage));
        return mFabricTable.Init(initParams);
    }

    CHIP_ERROR ReinitFabricTable(chip::TestPersistentStorageDelegate * storage)
    {
        chip::FabricTable::InitParams initParams;
        initParams.storage             = storage;
        initParams.operationalKeystore = &mOpKeyStore;
        initParams.opCertStore         = &mOpCertStore;

        return mFabricTable.Init(initParams);
    }

    FabricTable & GetFabricTable() { return mFabricTable; }

private:
    chip::FabricTable mFabricTable;
    chip::PersistentStorageOperationalKeystore mOpKeyStore;
    chip::Credentials::PersistentStorageOpCertStore mOpCertStore;
};

CHIP_ERROR LoadAppleFabric(FabricTable & fabricTable)
{
    Crypto::P256SerializedKeypair opKeysSerialized;
    static Crypto::P256Keypair opKey_Node01_01;

    FabricIndex fabricIndex;
    memcpy(opKeysSerialized.Bytes(), TestCerts::sTestCert_Node01_01_PublicKey.data(),
           TestCerts::sTestCert_Node01_01_PublicKey.size());
    memcpy(opKeysSerialized.Bytes() + TestCerts::sTestCert_Node01_01_PublicKey.size(),
           TestCerts::sTestCert_Node01_01_PrivateKey.data(), TestCerts::sTestCert_Node01_01_PrivateKey.size());

    ByteSpan rcacSpan(TestCerts::sTestCert_Root01_Chip);
    ByteSpan icacSpan(TestCerts::sTestCert_ICA01_Chip);
    ByteSpan nocSpan(TestCerts::sTestCert_Node01_01_Chip);

    ReturnErrorOnFailure(opKeysSerialized.SetLength(TestCerts::sTestCert_Node01_01_PublicKey.size() +
                                                    TestCerts::sTestCert_Node01_01_PrivateKey.size()));
    ReturnErrorOnFailure(opKey_Node01_01.Deserialize(opKeysSerialized));
    ReturnErrorOnFailure(fabricTable.AddNewPendingTrustedRootCert(rcacSpan));

    ReturnErrorOnFailure(fabricTable.AddNewPendingFabricWithProvidedOpKey(nocSpan, icacSpan, VendorId::Apple, &opKey_Node01_01,
                                                                          /*isExistingOpKeyExternallyOwned =*/true, &fabricIndex));
    ReturnErrorOnFailure(fabricTable.CommitPendingFabricData());

    return CHIP_NO_ERROR;
}

CHIP_ERROR LoadAppleKeychainFabric(FabricTable & fabricTable)
{
    Crypto::P256SerializedKeypair opKeysSerialized;
    FabricIndex fabricIndex;
    static Crypto::P256Keypair opKey_Node02_01;

    memcpy(opKeysSerialized.Bytes(), TestCerts::sTestCert_Node02_01_PublicKey.data(),
           TestCerts::sTestCert_Node02_01_PublicKey.size());
    memcpy(opKeysSerialized.Bytes() + TestCerts::sTestCert_Node02_01_PublicKey.size(),
           TestCerts::sTestCert_Node02_01_PrivateKey.data(), TestCerts::sTestCert_Node02_01_PrivateKey.size());

    ByteSpan rcacSpan(TestCerts::sTestCert_Root02_Chip);
    ByteSpan icacSpan(TestCerts::sTestCert_ICA02_Chip);
    ByteSpan nocSpan(TestCerts::sTestCert_Node02_01_Chip);

    ReturnErrorOnFailure(opKeysSerialized.SetLength(TestCerts::sTestCert_Node02_01_PublicKey.size() +
                                                    TestCerts::sTestCert_Node02_01_PrivateKey.size()));
    ReturnErrorOnFailure(opKey_Node02_01.Deserialize(opKeysSerialized));

    ReturnErrorOnFailure(fabricTable.AddNewPendingTrustedRootCert(rcacSpan));

    ReturnErrorOnFailure(fabricTable.AddNewPendingFabricWithProvidedOpKey(nocSpan, icacSpan, VendorId(kAppleKeychainVendorId),
                                                                          &opKey_Node02_01,
                                                                          /*isExistingOpKeyExternallyOwned =*/true, &fabricIndex));

    ReturnErrorOnFailure(fabricTable.CommitPendingFabricData());

    return CHIP_NO_ERROR;
}

class TestAppleKeychainHandler : public ::testing::Test
{
public:
    static void SetUpTestSuite()
    {
        DeviceLayer::SetConfigurationMgr(&DeviceLayer::ConfigurationManagerImpl::GetDefaultInstance());
        ASSERT_EQ(chip::Platform::MemoryInit(), CHIP_NO_ERROR);
#if CHIP_CRYPTO_PSA
        ASSERT_EQ(psa_crypto_init(), PSA_SUCCESS);
#endif
    }
    static void TearDownTestSuite() { chip::Platform::MemoryShutdown(); }
};

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_ValidExceptionBothFabrics)
{
    MockSubscriptionsInfoProvider subscriptionsInfoProvider;

    chip::TestPersistentStorageDelegate testStorage;
    ScopedFabricTable fabricTableHolder;
    EXPECT_EQ(fabricTableHolder.Init(&testStorage), CHIP_NO_ERROR);
    FabricTable & fabricTable = fabricTableHolder.GetFabricTable();

    EXPECT_EQ(CHIP_NO_ERROR, LoadAppleFabric(fabricTable));
    EXPECT_EQ(CHIP_NO_ERROR, LoadAppleKeychainFabric(fabricTable));

    // Add subscription for the Apple Fabric
    subscriptionsInfoProvider.AddActiveSubscription(1, 1);

    EXPECT_TRUE(AppleKeychainHandler::ProcessVendorCaseImpl(&subscriptionsInfoProvider, &fabricTable));
}

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_NoValidExceptionBothFabrics)
{
    MockSubscriptionsInfoProvider subscriptionsInfoProvider;

    chip::TestPersistentStorageDelegate testStorage;
    ScopedFabricTable fabricTableHolder;
    EXPECT_EQ(fabricTableHolder.Init(&testStorage), CHIP_NO_ERROR);
    FabricTable & fabricTable = fabricTableHolder.GetFabricTable();

    EXPECT_EQ(CHIP_NO_ERROR, LoadAppleFabric(fabricTable));
    EXPECT_EQ(CHIP_NO_ERROR, LoadAppleKeychainFabric(fabricTable));

    EXPECT_FALSE(AppleKeychainHandler::ProcessVendorCaseImpl(&subscriptionsInfoProvider, &fabricTable));
}

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_InvalidExceptionNoAppleFabric)
{
    MockSubscriptionsInfoProvider subscriptionsInfoProvider;

    chip::TestPersistentStorageDelegate testStorage;
    ScopedFabricTable fabricTableHolder;
    EXPECT_EQ(fabricTableHolder.Init(&testStorage), CHIP_NO_ERROR);
    FabricTable & fabricTable = fabricTableHolder.GetFabricTable();

    EXPECT_EQ(CHIP_NO_ERROR, LoadAppleKeychainFabric(fabricTable));
    EXPECT_TRUE(AppleKeychainHandler::ProcessVendorCaseImpl(&subscriptionsInfoProvider, &fabricTable));
}

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_InvalidExceptionNoFabrics)
{
    MockSubscriptionsInfoProvider subscriptionsInfoProvider;

    chip::TestPersistentStorageDelegate testStorage;
    ScopedFabricTable fabricTableHolder;
    EXPECT_EQ(fabricTableHolder.Init(&testStorage), CHIP_NO_ERROR);
    FabricTable & fabricTable = fabricTableHolder.GetFabricTable();

    /*
     * In this case, we have no fabrics in the fabric table. The Apple Keychain
     * handler should return False since we cannot determine if the device can go to LI based sleep.
     *
     * In practice, this use-case should never happen since we shouldn't be calling an excepting handler if there are no fabrics.
     * But if it does, we can assume that the device is in a state where it cannot go to LI based sleep.
     */
    EXPECT_FALSE(AppleKeychainHandler::ProcessVendorCaseImpl(&subscriptionsInfoProvider, &fabricTable));
}

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_MissingFabricTable)
{
    MockSubscriptionsInfoProvider subscriptionsInfoProvider;
    EXPECT_FALSE(AppleKeychainHandler::ProcessVendorCaseImpl(&subscriptionsInfoProvider, nullptr));
}

TEST_F(TestAppleKeychainHandler, ProcessVendorCaseImpl_MissingSubscriptionsInfoProvider)
{
    chip::TestPersistentStorageDelegate testStorage;
    ScopedFabricTable fabricTableHolder;
    EXPECT_EQ(fabricTableHolder.Init(&testStorage), CHIP_NO_ERROR);
    FabricTable & fabricTable = fabricTableHolder.GetFabricTable();

    EXPECT_FALSE(AppleKeychainHandler::ProcessVendorCaseImpl(nullptr, &fabricTable));
}

TEST_F(TestAppleKeychainHandler, IsMatchingVendorID)
{
    EXPECT_TRUE(AppleKeychainHandler::IsMatchingVendorID(chip::VendorId(kAppleKeychainVendorId)));
    EXPECT_FALSE(AppleKeychainHandler::IsMatchingVendorID(chip::VendorId(1234)));
}

} // namespace
