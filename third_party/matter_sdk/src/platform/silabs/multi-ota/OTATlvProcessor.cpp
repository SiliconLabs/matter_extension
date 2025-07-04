/*
 *
 *    Copyright (c) 2023 Project CHIP Authors
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

#include <lib/core/TLV.h>
#include <lib/support/BufferReader.h>
#include <lib/support/TypeTraits.h>

#include <headers/ProvisionManager.h>
#include <headers/ProvisionStorage.h>
#include <platform/silabs/multi-ota/OTAMultiImageProcessorImpl.h>
#include <platform/silabs/multi-ota/OTATlvProcessor.h>
#if OTA_ENCRYPTION_ENABLE
#include <platform/silabs/multi-ota/OtaTlvEncryptionKey.h>
#endif

using namespace ::chip::DeviceLayer::Internal;
using namespace ::chip::DeviceLayer::Silabs;

namespace chip {

CHIP_ERROR OTATlvProcessor::Init()
{
    VerifyOrReturnError(mCallbackProcessDescriptor != nullptr, CHIP_OTA_PROCESSOR_CB_NOT_REGISTERED);
    mAccumulator.Init(GetAccumulatorLength());
#ifdef OTA_ENCRYPTION_ENABLE
    mUnalignmentNum = 0;
#endif
    return CHIP_NO_ERROR;
}

CHIP_ERROR OTATlvProcessor::Clear()
{
    OTATlvProcessor::ClearInternal();
    mAccumulator.Clear();
    mDescriptorProcessed = false;
#ifdef OTA_ENCRYPTION_ENABLE
    mUnalignmentNum = 0;
#endif
    return CHIP_NO_ERROR;
}

CHIP_ERROR OTATlvProcessor::Process(ByteSpan & block)
{
    CHIP_ERROR status     = CHIP_NO_ERROR;
    uint32_t bytes        = chip::min(mLength - mProcessedLength, static_cast<uint32_t>(block.size()));
    ByteSpan relevantData = block.SubSpan(0, bytes);

    status = ProcessInternal(relevantData);
    if (!IsError(status))
    {
        mProcessedLength += bytes;
        block = block.SubSpan(bytes);
        if (mProcessedLength == mLength)
        {
            status = ExitAction();
            if (!IsError(status))
            {
                // If current block was processed fully and the block still contains data, it
                // means that the block contains another TLV's data and the current processor
                // should be changed by OTAMultiImageProcessorImpl.
                return CHIP_OTA_CHANGE_PROCESSOR;
            }
        }
    }

    return status;
}

void OTATlvProcessor::ClearInternal()
{
    mLength          = 0;
    mProcessedLength = 0;
    mWasSelected     = false;
#if OTA_ENCRYPTION_ENABLE
    mIVOffset = 0;
#endif
}

bool OTATlvProcessor::IsError(CHIP_ERROR & status)
{
    return status != CHIP_NO_ERROR && status != CHIP_ERROR_BUFFER_TOO_SMALL && status != CHIP_OTA_FETCH_ALREADY_SCHEDULED;
}

bool OTATlvProcessor::IsValidTag(OTAProcessorTag tag)
{
    auto value = chip::to_underlying(tag);

    return value >= chip::to_underlying(OTAProcessorTag::kApplicationProcessor) &&
        value <= chip::to_underlying(OTAProcessorTag::kMaxValue);
}

void OTADataAccumulator::Init(uint32_t threshold)
{
    mThreshold    = threshold;
    mBufferOffset = 0;
    mBuffer.Alloc(mThreshold);
}

void OTADataAccumulator::Clear()
{
    mThreshold    = 0;
    mBufferOffset = 0;
    mBuffer.Free();
}

CHIP_ERROR OTADataAccumulator::Accumulate(ByteSpan & block)
{
    uint32_t numBytes = chip::min(mThreshold - mBufferOffset, static_cast<uint32_t>(block.size()));
    memcpy(&mBuffer[mBufferOffset], block.data(), numBytes);
    mBufferOffset += numBytes;
    block = block.SubSpan(numBytes);

    if (mBufferOffset < mThreshold)
    {
        return CHIP_ERROR_BUFFER_TOO_SMALL;
    }

    return CHIP_NO_ERROR;
}

#if OTA_ENCRYPTION_ENABLE
CHIP_ERROR OTATlvProcessor::vOtaProcessInternalEncryption(MutableByteSpan & block)
{
#if defined(SL_MBEDTLS_USE_TINYCRYPT)
    Provision::Manager::GetInstance().GetStorage().DecryptUsingOtaTlvEncryptionKey(block, mIVOffset);
#else  // MBEDTLS_USE_PSA_CRYPTO
    uint32_t keyId;
    Provision::Manager::GetInstance().GetStorage().GetOtaTlvEncryptionKeyId(keyId);
    chip::DeviceLayer::Silabs::OtaTlvEncryptionKey key(keyId);

    key.Decrypt(block, mIVOffset);
#endif // SL_MBEDTLS_USE_TINYCRYPT

    return CHIP_NO_ERROR;
}
#endif // OTA_ENCRYPTION_ENABLE
} // namespace chip
