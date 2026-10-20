/*
 *
 *    Copyright (c) 2024 Project CHIP Authors
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
#include <lib/core/StringBuilderAdapters.h>
#include <pw_unit_test/framework.h>

#include <platform/silabs/wifi/icd/WifiSleepManager.h>

using namespace chip::DeviceLayer::Silabs;

namespace {

class TestMock : public PowerSaveInterface, public WifiStateProvider
{
public:
    void Reset()
    {
        mConfigurePowerSaveCalled       = false;
        mConfigureBroadcastFilterCalled = false;
        mIsWifiProvisioned              = false;
        mIsStationConnected             = false;
        mIsStationConnecting            = false;
        mBroadcastFilterEnabled         = false;
#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
        mConfigureLITConnectCalled    = false;
        mConfigureLITDisconnectCalled = false;
        mCancelLitPrecheckInTimerCalled = false;
        mStartLitPrecheckInTimerCalled  = false;
        mInitLitPrecheckInTimerCalled = false;
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    }

    // Getters to check if methods were called
    bool WasConfigurePowerSaveCalled()
    {
        bool wasCalled            = mConfigurePowerSaveCalled;
        mConfigurePowerSaveCalled = false;
        return wasCalled;
    }

    bool WasConfigureBroadcastFilterCalled()
    {
        bool wasCalled                  = mConfigureBroadcastFilterCalled;
        mConfigureBroadcastFilterCalled = false;
        return wasCalled;
    }

    bool WasBroadcastFilterEnabled()
    {
        bool wasEnabled         = mBroadcastFilterEnabled;
        mBroadcastFilterEnabled = false;
        return wasEnabled;
    }

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    bool WasConfigureLITConnectCalled()
    {
        bool wasCalled             = mConfigureLITConnectCalled;
        mConfigureLITConnectCalled = false;
        return wasCalled;
    }

    bool WasConfigureLITDisconnectCalled()
    {
        bool wasCalled                = mConfigureLITDisconnectCalled;
        mConfigureLITDisconnectCalled = false;
        return wasCalled;
    }

    bool WasCancelLitPrecheckTimerCalled()
    {
        bool wasCalled                  = mCancelLitPrecheckInTimerCalled;
        mCancelLitPrecheckInTimerCalled = false;
        return wasCalled;
    }

    bool WasStartLitPrecheckTimerCalled()
    {
        bool wasCalled                 = mStartLitPrecheckInTimerCalled;
        mStartLitPrecheckInTimerCalled = false;
        return wasCalled;
    }

    bool WasInitLitPrecheckInTimerCalled()
    {
        bool wasCalled                = mInitLitPrecheckInTimerCalled;
        mInitLitPrecheckInTimerCalled = false;
        return wasCalled;
    }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

    PowerSaveConfiguration GetLastPowerSaveConfiguration() const { return mLastPowerSaveConfiguration; }

    void SetIsWifiProvisioned(bool isProvisioned) { mIsWifiProvisioned = isProvisioned; }
    void SetIsStationConnected(bool isConnected) { mIsStationConnected = isConnected; }
    void SetIsStationConnecting(bool isConnecting) { mIsStationConnecting = isConnecting; }

    CHIP_ERROR ConfigurePowerSave(PowerSaveConfiguration configuration, uint32_t listenInterval) override
    {
        mConfigurePowerSaveCalled   = true;
        mLastPowerSaveConfiguration = configuration;
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR ConfigureBroadcastFilter(bool enableBroadcastFilter) override
    {
        mConfigureBroadcastFilterCalled = true;
        mBroadcastFilterEnabled         = enableBroadcastFilter;
        return CHIP_NO_ERROR;
    }

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    CHIP_ERROR ConfigureLITConnect() override
    {
        mConfigureLITConnectCalled = true;
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR ConfigureLITDisconnect() override
    {
        mConfigureLITDisconnectCalled = true;
        return CHIP_NO_ERROR;
    }

    void CancelLitPrecheckInReconnectTimer() override { mCancelLitPrecheckInTimerCalled = true; }

    void StartLitPrecheckInReconnectTimer() override { mStartLitPrecheckInTimerCalled = true; }

    CHIP_ERROR InitLitPrecheckInReconnectTimer() override
    {
        mInitLitPrecheckInTimerCalled = true;
        return CHIP_NO_ERROR;
    }
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

    bool IsWifiProvisioned() override { return mIsWifiProvisioned; }

    bool IsStationConnected() override { return mIsStationConnected; }
    bool IsStationConnecting() override { return mIsStationConnecting; }
    bool IsStationModeEnabled() override { return false; }
    bool IsStationReady() override { return false; }
    bool HasAnIPv6Address() override { return false; }
    bool HasAnIPv4Address() override { return false; }

private:
    bool mConfigurePowerSaveCalled       = false;
    bool mConfigureBroadcastFilterCalled = false;
    bool mBroadcastFilterEnabled         = false;
    PowerSaveConfiguration mLastPowerSaveConfiguration;
    bool mIsWifiProvisioned     = false;
    bool mIsStationConnected    = false;
    bool mIsStationConnecting   = false;
#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    bool mConfigureLITConnectCalled    = false;
    bool mConfigureLITDisconnectCalled = false;
    bool mCancelLitPrecheckInTimerCalled = false;
    bool mStartLitPrecheckInTimerCalled  = false;
    bool mInitLitPrecheckInTimerCalled = false;
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
};

class AlwaysLiSleepCallback : public WifiSleepManager::ApplicationCallback
{
public:
    bool CanGoToLIBasedSleep() override { return true; }
};

} // namespace

class TestWifiSleepManager : public ::testing::Test
{
protected:
    void SetUp()
    {
        EXPECT_EQ(WifiSleepManager::GetInstance().Init(&mMock, &mMock), CHIP_NO_ERROR);
        EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());
        EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);
#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
        EXPECT_TRUE(mMock.WasInitLitPrecheckInTimerCalled());
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    }
    void TearDown()
    {
        WifiSleepManager::GetInstance().SetApplicationCallback(nullptr);
        mMock.Reset();
    }

    static TestMock mMock;

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
    AlwaysLiSleepCallback mLiSleepCallback;
#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
};

TestMock TestWifiSleepManager::mMock;

TEST_F(TestWifiSleepManager, TestInitFailureNullPowerSaveInterface)
{
    TestMock mock;
    EXPECT_EQ(WifiSleepManager::GetInstance().Init(nullptr, &mock), CHIP_ERROR_INVALID_ARGUMENT);
    EXPECT_FALSE(mock.WasConfigurePowerSaveCalled());
    ASSERT_EQ(WifiSleepManager::GetInstance().Init(&mMock, &mMock), CHIP_NO_ERROR);
}

TEST_F(TestWifiSleepManager, TestInitFailureNullWifiStateProvider)
{
    TestMock mock;
    EXPECT_EQ(WifiSleepManager::GetInstance().Init(&mock, nullptr), CHIP_ERROR_INVALID_ARGUMENT);
    EXPECT_FALSE(mock.WasConfigurePowerSaveCalled());
    ASSERT_EQ(WifiSleepManager::GetInstance().Init(&mMock, &mMock), CHIP_NO_ERROR);
}

TEST_F(TestWifiSleepManager, TestRequestHighPerformanceMaxCounter)
{
    // Set the counter to its maximum value
    for (uint8_t i = 0; i < std::numeric_limits<uint8_t>::max(); i++)
    {
        EXPECT_EQ(WifiSleepManager::GetInstance().RequestHighPerformanceWithTransition(), CHIP_NO_ERROR);
        EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kHighPerformance);
        EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());
    }

    // The next request should fail
    EXPECT_EQ(WifiSleepManager::GetInstance().RequestHighPerformanceWithTransition(), CHIP_ERROR_INTERNAL);
    EXPECT_FALSE(mMock.WasConfigurePowerSaveCalled());

    // Reset the counter & validate reset
    for (uint8_t i = 0; i < std::numeric_limits<uint8_t>::max(); i++)
    {
        EXPECT_EQ(WifiSleepManager::GetInstance().RemoveHighPerformanceRequest(), CHIP_NO_ERROR);
    }
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);
}

TEST_F(TestWifiSleepManager, TestRequestRemoveHighPerformance)
{
    EXPECT_EQ(WifiSleepManager::GetInstance().RequestHighPerformanceWithTransition(), CHIP_NO_ERROR);
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kHighPerformance);
    EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());

    EXPECT_EQ(WifiSleepManager::GetInstance().RemoveHighPerformanceRequest(), CHIP_NO_ERROR);
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);
    EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());
}

TEST_F(TestWifiSleepManager, TestRemovePerformanceRequestSubMinimum)
{
    EXPECT_EQ(WifiSleepManager::GetInstance().RemoveHighPerformanceRequest(), CHIP_NO_ERROR);
    EXPECT_FALSE(mMock.WasConfigurePowerSaveCalled());
}

TEST_F(TestWifiSleepManager, TestVerifyOrTransitionStandardOperation)
{
    mMock.SetIsWifiProvisioned(true);

    // Test the standard operation
    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent),
              CHIP_NO_ERROR);

    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kConnectedSleep);
    EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());
    EXPECT_TRUE(mMock.WasConfigureBroadcastFilterCalled());
    EXPECT_FALSE(mMock.WasBroadcastFilterEnabled());
}

TEST_F(TestWifiSleepManager, TestRequestHighPerformanceWithoutProvisioning)
{
    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent),
              CHIP_NO_ERROR);

    PowerSaveInterface::PowerSaveConfiguration config = mMock.GetLastPowerSaveConfiguration();
    EXPECT_EQ(PowerSaveInterface::PowerSaveConfiguration::kDeepSleep, config);

    // The configuration should not change
    EXPECT_EQ(WifiSleepManager::GetInstance().RequestHighPerformanceWithoutTransition(), CHIP_NO_ERROR);
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), config);
}

#if defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)

TEST_F(TestWifiSleepManager, TestLitIdleModeSelectsLITDisconnectWhenCallbackAllowsLiSleep)
{
    mMock.SetIsWifiProvisioned(true);
    mMock.SetIsStationConnected(true);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kIdleMode),
              CHIP_NO_ERROR);

    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_TRUE(mMock.WasConfigureBroadcastFilterCalled());
    EXPECT_FALSE(mMock.WasBroadcastFilterEnabled());
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);
    EXPECT_TRUE(mMock.WasConfigurePowerSaveCalled());
    EXPECT_TRUE(mMock.WasStartLitPrecheckTimerCalled());
}

TEST_F(TestWifiSleepManager, TestLitIdleModeDefersDisconnectWhileConnecting)
{
    mMock.SetIsWifiProvisioned(true);
    mMock.SetIsStationConnecting(true);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kIdleMode),
              CHIP_NO_ERROR);

    EXPECT_FALSE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_FALSE(mMock.WasStartLitPrecheckTimerCalled());
}

TEST_F(TestWifiSleepManager, TestLitIdleModeDoesNotRestartPrecheckTimerWhenAlreadyDisconnected)
{
    mMock.SetIsWifiProvisioned(true);
    mMock.SetIsStationConnected(false);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kIdleMode),
              CHIP_NO_ERROR);

    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_FALSE(mMock.WasStartLitPrecheckTimerCalled());
}

// Failed join clears station-connected; a later kGenericEvent must not restart the
// precheck-in timer (platform ConfigureLITDisconnect succeeds without sl_net_down).
TEST_F(TestWifiSleepManager, TestLitGenericEventDoesNotRestartPrecheckTimerAfterFailedJoin)
{
    mMock.SetIsWifiProvisioned(true);
    mMock.SetIsStationConnected(true);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kIdleMode),
              CHIP_NO_ERROR);
    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_TRUE(mMock.WasStartLitPrecheckTimerCalled());

    // Simulate join failure: STA already down, idle mode preserved across kGenericEvent.
    mMock.SetIsStationConnected(false);
    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kGenericEvent),
              CHIP_NO_ERROR);

    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_FALSE(mMock.WasStartLitPrecheckTimerCalled());
}

TEST_F(TestWifiSleepManager, TestLitActiveModeRunsLITConnect)
{
    mMock.SetIsWifiProvisioned(true);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kActiveMode),
              CHIP_NO_ERROR);

    EXPECT_TRUE(mMock.WasCancelLitPrecheckTimerCalled());
    EXPECT_TRUE(mMock.WasConfigureLITConnectCalled());
    // Wake/join power-save is applied inside ConfigureLITConnect, not by WifiSleepManager.
    EXPECT_FALSE(mMock.WasConfigurePowerSaveCalled());
    EXPECT_FALSE(mMock.WasConfigureBroadcastFilterCalled());
}

TEST_F(TestWifiSleepManager, TestLitIdleModePreservedAcrossHighPerformanceCycle)
{
    mMock.SetIsWifiProvisioned(true);
    mMock.SetIsStationConnected(true);
    WifiSleepManager::GetInstance().SetApplicationCallback(&mLiSleepCallback);

    EXPECT_EQ(WifiSleepManager::GetInstance().VerifyAndTransitionToLowPowerMode(WifiSleepManager::PowerEvent::kIdleMode),
              CHIP_NO_ERROR);
    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);

    // HP request/remove uses kGenericEvent; that must not flip mActiveMode to true.
    EXPECT_EQ(WifiSleepManager::GetInstance().RequestHighPerformanceWithTransition(), CHIP_NO_ERROR);
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kHighPerformance);

    EXPECT_EQ(WifiSleepManager::GetInstance().RemoveHighPerformanceRequest(), CHIP_NO_ERROR);
    EXPECT_TRUE(mMock.WasConfigureLITDisconnectCalled());
    EXPECT_EQ(mMock.GetLastPowerSaveConfiguration(), PowerSaveInterface::PowerSaveConfiguration::kDeepSleep);
}

#endif // defined(CHIP_CONFIG_ENABLE_ICD_LIT) && (CHIP_CONFIG_ENABLE_ICD_LIT == 1)
