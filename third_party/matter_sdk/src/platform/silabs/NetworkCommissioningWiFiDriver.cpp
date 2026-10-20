/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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

#include <lib/support/CodeUtils.h>
#include <lib/support/SafeInt.h>
#include <platform/CHIPDeviceLayer.h>
#include <platform/silabs/NetworkCommissioningWiFiDriver.h>
#include <platform/silabs/SilabsConfig.h>

#include <limits>

using namespace ::chip;
using namespace ::chip::DeviceLayer::Internal;
using namespace ::chip::DeviceLayer::Silabs;

namespace chip {
namespace DeviceLayer {
namespace NetworkCommissioning {

namespace {
NetworkCommissioning::WiFiScanResponse * sScanResult;
SlScanResponseIterator<NetworkCommissioning::WiFiScanResponse> mScanResponseIter(sScanResult);
} // namespace

SlWiFiDriver * SlWiFiDriver::mDriver = nullptr;

CHIP_ERROR SlWiFiDriver::Init(NetworkStatusChangeCallback * networkStatusChangeCallback)
{
    CHIP_ERROR err;
    mpScanCallback         = nullptr;
    mpConnectCallback      = nullptr;
    mpStatusChangeCallback = networkStatusChangeCallback;
    mDriver                = this;

    err = RevertConfiguration();
    // If the configuration is not found, it means the wifi is not provisioned, no need to go further.
    VerifyOrReturnError(err != CHIP_DEVICE_ERROR_CONFIG_NOT_FOUND, CHIP_NO_ERROR);
    err = ConnectWiFiNetwork(reinterpret_cast<const char *>(mStagingNetwork.ssid), mStagingNetwork.ssidLen,
                             reinterpret_cast<const char *>(mStagingNetwork.key), mStagingNetwork.keyLen);
    return err;
}

CHIP_ERROR SlWiFiDriver::CommitConfiguration()
{
    constexpr uint8_t kDefaultSecurityBitmap =
        static_cast<uint8_t>(chip::app::Clusters::NetworkCommissioning::WiFiSecurityBitmap::kWpa2Personal);

    ReturnErrorOnFailure(SilabsConfig::WriteConfigValueBin(
        SilabsConfig::kConfigKey_WiFiSSID, reinterpret_cast<const uint8_t *>(mStagingNetwork.ssid), mStagingNetwork.ssidLen));
    ReturnErrorOnFailure(SilabsConfig::WriteConfigValueBin(
        SilabsConfig::kConfigKey_WiFiPSK, reinterpret_cast<const uint8_t *>(mStagingNetwork.key), mStagingNetwork.keyLen));
    // TODO: Remove commit of security bitmap, as security is automatically determined by the SSID and PSK during connection.
    ReturnErrorOnFailure(SilabsConfig::WriteConfigValueBin(SilabsConfig::kConfigKey_WiFiSEC, &kDefaultSecurityBitmap,
                                                           sizeof(kDefaultSecurityBitmap)));

    mSavedNetwork = mStagingNetwork;
    return CHIP_NO_ERROR;
}

CHIP_ERROR SlWiFiDriver::RevertConfiguration()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
    // If reading fails, wifi is not provisioned, no need to go further.
    err = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_WiFiSSID, mSavedNetwork.ssid, sizeof(mSavedNetwork.ssid),
                                           mSavedNetwork.ssidLen);
#if defined(SL_ONNETWORK_PAIRING) && SL_ONNETWORK_PAIRING
    if (err == CHIP_DEVICE_ERROR_CONFIG_NOT_FOUND)
    {
        memcpy(&mSavedNetwork.ssid, SL_WIFI_SSID, sizeof(SL_WIFI_SSID));
        mSavedNetwork.ssidLen = sizeof(SL_WIFI_SSID);

        err = CHIP_NO_ERROR;
    }
#endif // SL_ONNETWORK_PAIRING
    VerifyOrReturnError(err == CHIP_NO_ERROR, err);

    err = SilabsConfig::ReadConfigValueBin(SilabsConfig::kConfigKey_WiFiPSK, mSavedNetwork.key, sizeof(mSavedNetwork.key),
                                           mSavedNetwork.keyLen);
#if defined(SL_ONNETWORK_PAIRING) && SL_ONNETWORK_PAIRING
    if (err == CHIP_DEVICE_ERROR_CONFIG_NOT_FOUND)
    {
        memcpy(&mSavedNetwork.key, SL_WIFI_PSK, sizeof(SL_WIFI_PSK));
        mSavedNetwork.keyLen = sizeof(SL_WIFI_PSK);

        err = CHIP_NO_ERROR;
    }
#endif // SL_ONNETWORK_PAIRING
    VerifyOrReturnError(err == CHIP_NO_ERROR, err);
    mStagingNetwork = mSavedNetwork;
    return err;
}

bool SlWiFiDriver::NetworkMatch(const Silabs::WifiInterface::WiFiCredentials & network, ByteSpan networkId)
{
    return networkId.size() == network.ssidLen && memcmp(networkId.data(), network.ssid, network.ssidLen) == 0;
}

Status SlWiFiDriver::AddOrUpdateNetwork(ByteSpan ssid, ByteSpan credentials, MutableCharSpan & outDebugText,
                                        uint8_t & outNetworkIndex)
{
    outDebugText.reduce_size(0);
    // since we only support one network, we always return 0
    outNetworkIndex = 0;

    // using ssid as the networkId
    VerifyOrReturnError(ssid.size() <= sizeof(mStagingNetwork.ssid), Status::kOutOfRange);
    VerifyOrReturnError(credentials.size() <= sizeof(mStagingNetwork.key), Status::kOutOfRange);

    VerifyOrReturnError(ssid.data() != nullptr, Status::kNetworkIDNotFound);
    MutableByteSpan ssidSpan(mStagingNetwork.ssid, sizeof(mStagingNetwork.ssid));
    VerifyOrReturnError(CopySpanToMutableSpan(ssid, ssidSpan) == CHIP_NO_ERROR, Status::kBoundsExceeded);
    mStagingNetwork.ssidLen = ssid.size();

    VerifyOrReturnError(credentials.data() != nullptr, Status::kNetworkIDNotFound);
    MutableByteSpan keySpan(mStagingNetwork.key, sizeof(mStagingNetwork.key));
    VerifyOrReturnError(CopySpanToMutableSpan(credentials, keySpan) == CHIP_NO_ERROR, Status::kBoundsExceeded);
    mStagingNetwork.keyLen = credentials.size();

    return Status::kSuccess;
}

Status SlWiFiDriver::RemoveNetwork(ByteSpan networkId, MutableCharSpan & outDebugText, uint8_t & outNetworkIndex)
{
    outDebugText.reduce_size(0);
    outNetworkIndex = 0;
    VerifyOrReturnError(NetworkMatch(mStagingNetwork, networkId), Status::kNetworkIDNotFound);

    // Use empty ssid for representing invalid network
    mStagingNetwork.ssidLen = 0;
    return Status::kSuccess;
}

Status SlWiFiDriver::ReorderNetwork(ByteSpan networkId, uint8_t index, MutableCharSpan & outDebugText)
{
    outDebugText.reduce_size(0);
    // Only one network is supported for now
    VerifyOrReturnError(index == 0, Status::kOutOfRange);
    VerifyOrReturnError(NetworkMatch(mStagingNetwork, networkId), Status::kNetworkIDNotFound);
    return Status::kSuccess;
}

CHIP_ERROR SlWiFiDriver::ConnectWiFiNetwork(const char * ssid, uint8_t ssidLen, const char * key, uint8_t keyLen)
{
    // if the WiFi station is provisioned, disconnect it
    if (ConnectivityMgr().IsWiFiStationProvisioned())
    {
        ChipLogProgress(DeviceLayer, "Disconnecting for current wifi");
        ReturnErrorOnFailure(ConnectivityMgr().DisconnectNetwork());
    }
    ReturnErrorOnFailure(ConnectivityMgr().SetWiFiStationMode(ConnectivityManager::kWiFiStationMode_Disabled));

    // Set the wifi configuration
    WifiInterface::WiFiCredentials wifiConfig;

    VerifyOrReturnError(ssidLen <= kMaxWiFiSSIDLength, CHIP_ERROR_BUFFER_TOO_SMALL);
    memcpy(wifiConfig.ssid, ssid, ssidLen);
    wifiConfig.ssidLen = ssidLen;

    VerifyOrReturnError(keyLen < kMaxWiFiKeyLength, CHIP_ERROR_BUFFER_TOO_SMALL);
    memcpy(wifiConfig.key, key, keyLen);
    wifiConfig.keyLen = keyLen;

    ChipLogProgress(NetworkProvisioning, "Setting up connection for WiFi SSID: %s", NullTerminated(ssid, ssidLen).c_str());

    ReturnErrorOnFailure(WifiInterface::GetInstance().SetWifiCredentials(wifiConfig));
    ReturnErrorOnFailure(ConnectivityMgr().SetWiFiStationMode(ConnectivityManager::kWiFiStationMode_Disabled));
    ReturnErrorOnFailure(ConnectivityMgr().SetWiFiStationMode(ConnectivityManager::kWiFiStationMode_Enabled));
    return CHIP_NO_ERROR;
}

void SlWiFiDriver::UpdateNetworkingStatus()
{
    VerifyOrReturn(mpStatusChangeCallback != nullptr);
    VerifyOrReturn(mStagingNetwork.ssidLen != 0);

    bool isStationConnected = WifiInterface::GetInstance().IsStationConnected();

    Status commissioningError = isStationConnected ? Status::kSuccess : WifiInterface::GetInstance().GetLastDisconnectionReason();
    ByteSpan networkId        = ByteSpan((const unsigned char *) mStagingNetwork.ssid, mStagingNetwork.ssidLen);
    int32_t connectStatus     = (isStationConnected ? SL_STATUS_OK : SL_STATUS_FAIL);

    ChipLogDetail(NetworkProvisioning, "UpdateNetworkingStatus: commissioningError: 0x%02X",
                  static_cast<uint8_t>(commissioningError));

    mpStatusChangeCallback->OnNetworkingStatusChange(commissioningError, MakeOptional(networkId), MakeOptional(connectStatus));
}

void SlWiFiDriver::OnConnectWiFiNetwork()
{
    VerifyOrReturn(mpConnectCallback != nullptr);

    bool isStationConnected = WifiInterface::GetInstance().IsStationConnected();

    Status commissioningError = isStationConnected ? Status::kSuccess : WifiInterface::GetInstance().GetLastDisconnectionReason();
    int32_t connectStatus     = (isStationConnected ? SL_STATUS_OK : SL_STATUS_FAIL);

    ChipLogDetail(NetworkProvisioning, "OnConnectWiFiNetwork: commissioningError: 0x%02X",
                  static_cast<uint8_t>(commissioningError));

    mpConnectCallback->OnResult(commissioningError, // commissioning error
                                CharSpan(),         // debug text
                                connectStatus       // connect status
    );
    mpConnectCallback = nullptr;
}

void SlWiFiDriver::ConnectNetwork(ByteSpan networkId, ConnectCallback * callback)
{
    CHIP_ERROR err            = CHIP_NO_ERROR;
    Status commissioningError = Status::kSuccess;

    VerifyOrExit(NetworkMatch(mStagingNetwork, networkId), commissioningError = Status::kNetworkIDNotFound);
    VerifyOrExit(mpConnectCallback == nullptr, commissioningError = Status::kUnknownError);

    err = ConnectWiFiNetwork(reinterpret_cast<const char *>(mStagingNetwork.ssid), mStagingNetwork.ssidLen,
                             reinterpret_cast<const char *>(mStagingNetwork.key), mStagingNetwork.keyLen);

    VerifyOrExit(err == CHIP_NO_ERROR, commissioningError = Status::kUnknownError);
    mpConnectCallback = callback;
exit:
    VerifyOrReturn(commissioningError != Status::kSuccess);
    ChipLogError(NetworkProvisioning, "Failed to connect to WiFi network: %" CHIP_ERROR_FORMAT, err.Format());
    callback->OnResult(commissioningError, // commissioning error
                       CharSpan(),         // debug text
                       SL_STATUS_FAIL      // connect status
    );
}

uint32_t SlWiFiDriver::GetSupportedWiFiBandsMask() const
{
    return WifiInterface::GetInstance().GetSupportedWiFiBandsMask();
}

bool SlWiFiDriver::StartScanWiFiNetworks(ByteSpan ssid)
{
    ChipLogDetail(DeviceLayer, "Start Scan WiFi Networks");
    CHIP_ERROR err = WifiInterface::GetInstance().StartNetworkScan(ssid, OnScanWiFiNetworkDone);

    VerifyOrReturnValue(err == CHIP_NO_ERROR, false,
                        ChipLogError(DeviceLayer, "StartNetworkScan failed: %" CHIP_ERROR_FORMAT, err.Format()));
    return true;
}

void SlWiFiDriver::OnScanWiFiNetworkDone(NetworkCommissioning::WiFiScanResponse * aScanResult)
{
    SlWiFiDriver * nwDriver = NetworkCommissioning::SlWiFiDriver::GetInstance();
    // Cannot use the driver if the instance is not initialized.
    VerifyOrDie(nwDriver != nullptr); // should never be null

    // If the scan result is null, it means the scan completed.
    if (aScanResult == nullptr)
    {
        ChipLogProgress(DeviceLayer, "OnScanWiFiNetworkDone: Receive all scanned networks information.");
        VerifyOrReturn(nwDriver->mpScanCallback != nullptr);

        if (mScanResponseIter.Count() == 0)
        {
            // if there is no network found, return kNetworkNotFound
            LogErrorOnFailure(DeviceLayer::SystemLayer().ScheduleLambda([nwDriver]() {
                nwDriver->mpScanCallback->OnFinished(NetworkCommissioning::Status::kNetworkNotFound, CharSpan(), nullptr);
                nwDriver->mpScanCallback = nullptr;
            }));
            return;
        }

        LogErrorOnFailure(DeviceLayer::SystemLayer().ScheduleLambda([nwDriver]() {
            nwDriver->mpScanCallback->OnFinished(NetworkCommissioning::Status::kSuccess, CharSpan(), &mScanResponseIter);
            nwDriver->mpScanCallback = nullptr;
        }));
    }
    else
    {
        mScanResponseIter.Add(aScanResult);
    }
}

void SlWiFiDriver::ScanNetworks(ByteSpan ssid, WiFiDriver::ScanCallback * callback)
{
    VerifyOrReturn(callback != nullptr);
    mpScanCallback = callback;

    // If the scan fails, return an error to the callback.
    VerifyOrReturn(!StartScanWiFiNetworks(ssid));
    ChipLogError(DeviceLayer, "ScanWiFiNetworks failed to start");
    mpScanCallback = nullptr;
    callback->OnFinished(Status::kUnknownError, CharSpan(), nullptr);
}

CHIP_ERROR GetConnectedNetwork(Network & network)
{
    WifiInterface::WiFiCredentials wifiConfig;
    network.networkIDLen = 0;
    network.connected    = false;

    // we are able to fetch the wifi provision data and STA should be connected
    VerifyOrReturnError(WifiInterface::GetInstance().IsStationConnected(), CHIP_ERROR_NOT_CONNECTED);
    ReturnErrorOnFailure(WifiInterface::GetInstance().GetWifiCredentials(wifiConfig));
    VerifyOrReturnError(wifiConfig.ssidLen <= NetworkCommissioning::kMaxNetworkIDLen, CHIP_ERROR_BUFFER_TOO_SMALL);

    network.connected = true;

    ByteSpan ssidSpan(wifiConfig.ssid, wifiConfig.ssidLen);
    MutableByteSpan networkIdSpan(network.networkID, NetworkCommissioning::kMaxNetworkIDLen);

    ReturnErrorOnFailure(CopySpanToMutableSpan(ssidSpan, networkIdSpan));
    network.networkIDLen = wifiConfig.ssidLen;

    return CHIP_NO_ERROR;
}

size_t SlWiFiDriver::WiFiNetworkIterator::Count()
{
    return mDriver->mStagingNetwork.ssidLen == 0 ? 0 : 1;
}

bool SlWiFiDriver::WiFiNetworkIterator::Next(Network & item)
{
    if (mExhausted || mDriver->mStagingNetwork.ssidLen == 0)
    {
        return false;
    }
    memcpy(item.networkID, mDriver->mStagingNetwork.ssid, mDriver->mStagingNetwork.ssidLen);
    item.networkIDLen = mDriver->mStagingNetwork.ssidLen;
    item.connected    = false;
    mExhausted        = true;

    Network connectedNetwork;
    CHIP_ERROR err = GetConnectedNetwork(connectedNetwork);
    if (err == CHIP_NO_ERROR)
    {
        if (connectedNetwork.networkIDLen == item.networkIDLen &&
            memcmp(connectedNetwork.networkID, item.networkID, item.networkIDLen) == 0)
        {
            item.connected = true;
        }
    }
    return true;
}

} // namespace NetworkCommissioning
} // namespace DeviceLayer
} // namespace chip
