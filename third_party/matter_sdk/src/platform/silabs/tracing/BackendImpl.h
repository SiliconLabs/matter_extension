/*
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
#pragma once

#include <tracing/backend.h>
#include <tracing/metric_event.h>
#include <tracing/registry.h>

namespace chip {
namespace Tracing {
namespace Silabs {

/** @brief
 * Backend implementation for Silabs platform acting as an interface with SilabsTracer and the matter layer.
 */
class BackendImpl : public ::chip::Tracing::Backend
{
public:
    BackendImpl() = default;
    // TraceBegin, TraceEnd and TraceInstant are redundant with LogMetricEvent in the usecases that we are trying to track,
    // so we are not implementing these at the moment to avoid duplication of the same information in the trace. We might implement
    // them in the future if we want to add new traces that are not related to our metrics measurements
    void TraceBegin(const char * label, const char * group) override;
    void TraceEnd(const char * label, const char * group) override;
    void TraceInstant(const char * label, const char * group) override;

    // Our tracing counter is embedded in our metrics, so we are not implementing it.
    void TraceCounter(const char * label) override {}

    // Not implmented yet, might be implemented in the future.
    void LogMessageSend(MessageSendInfo &) override {}
    void LogMessageReceived(MessageReceivedInfo &) override {}
    void LogNodeLookup(NodeLookupInfo &) override {}
    void LogNodeDiscovered(NodeDiscoveredInfo &) override {}
    void LogNodeDiscoveryFailed(NodeDiscoveryFailedInfo &) override {}

    /** @brief Log a metric event using SilabsTracer interface
     *  SilabsTracer.Init() needs to be called before this is called.
     */
    void LogMetricEvent(const MetricEvent &) override;
};

} // namespace Silabs
} // namespace Tracing
} // namespace chip
