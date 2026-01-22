#include "BackendImpl.h"
#include "SilabsTracing.h"
#include <lib/core/CHIPError.h>
#include <tracing/metric_event.h>

namespace chip {
namespace Tracing {
namespace Silabs {

TimeTraceOperation MapMetricKeyToOperation(MetricKey metricKey)
{
    if (metricKey == kMetricDeviceCommissionerPASESession)
        return TimeTraceOperation::kPake1;
    if (metricKey == kMetricDeviceCommissionerCommission)
        return TimeTraceOperation::kOperationalCredentials;
    if (metricKey == kMetricDeviceCommissionerCommissionStage)
        return TimeTraceOperation::kTransportSetup;
    if (metricKey == kMetricSetupCodePairerPairDevice)
        return TimeTraceOperation::kFindOperational;
    if (metricKey == kMetricDeviceCommissioningOperationalSetup)
        return TimeTraceOperation::kCaseSession;
    if (metricKey == kMetricDeviceOperationalDiscovery)
        return TimeTraceOperation::kFindOperational;
    if (metricKey == kMetricDeviceOperationalDiscoveryAttemptCount)
        return TimeTraceOperation::kFindOperational;
    if (metricKey == kMetricDeviceCASESession)
        return TimeTraceOperation::kCaseSession;
    if (metricKey == kMetricDeviceCASESessionSigma1)
        return TimeTraceOperation::kSigma1;
    if (metricKey == kMetricDeviceCASESessionSigma1Resume)
        return TimeTraceOperation::kSigma1;
    if (metricKey == kMetricDeviceCASESessionSigma2)
        return TimeTraceOperation::kSigma2;
    if (metricKey == kMetricDeviceCASESessionSigma3)
        return TimeTraceOperation::kSigma3;
    if (metricKey == kMetricDeviceCASESessionSigma2Resume)
        return TimeTraceOperation::kSigma2;
    if (metricKey == kMetricDeviceCASESessionSigmaFinished)
        return TimeTraceOperation::kCaseSession;
    if (metricKey == kMetricDeviceRMPRetryCount)
        return TimeTraceOperation::kTransportLayer;
    return TimeTraceOperation::kNumTraces;
}

void BackendImpl::TraceBegin(const char * label, const char * group)
{
    TimeTraceOperation operation = MapMetricKeyToOperation(label);

    if (operation < TimeTraceOperation::kNumTraces) // Operation was found
        SilabsTracer::Instance().TimeTraceBegin(MapMetricKeyToOperation(label));
    else
        SilabsTracer::Instance().NamedTraceBegin(CharSpan::fromCharString(label), CharSpan::fromCharString(group));
}

void BackendImpl::TraceEnd(const char * label, const char * group)
{
    TimeTraceOperation operation = MapMetricKeyToOperation(label);

    if (operation < TimeTraceOperation::kNumTraces) // Operation was found
        SilabsTracer::Instance().TimeTraceEnd(MapMetricKeyToOperation(label), CHIP_NO_ERROR);
    else
        SilabsTracer::Instance().NamedTraceEnd(CharSpan::fromCharString(label), CharSpan::fromCharString(group));
}

void BackendImpl::TraceInstant(const char * label, const char * group)
{
    SilabsTracer::Instance().TimeTraceInstant(CharSpan::fromCharString(label), CharSpan::fromCharString(group), CHIP_NO_ERROR);
}

void BackendImpl::LogMetricEvent(const MetricEvent & event)
{
    Silabs::TimeTraceOperation operation = MapMetricKeyToOperation(event.key());
    CHIP_ERROR err                       = CHIP_NO_ERROR;
    switch (event.ValueType())
    {
    case MetricEvent::Value::Type::kChipErrorCode:
        err = ChipError(event.ValueErrorCode());
        break;
    default:
        break;
    }

    switch (event.type())
    {
    case MetricEvent::Type::kBeginEvent:
        SilabsTracer::Instance().TimeTraceBegin(operation);
        break;
    case MetricEvent::Type::kEndEvent:
        SilabsTracer::Instance().TimeTraceEnd(operation, err);
        break;
    case MetricEvent::Type::kInstantEvent:
        SilabsTracer::Instance().TimeTraceInstant(operation, err);
        break;
    default:
        break;
    }
}

} // namespace Silabs
} // namespace Tracing
} // namespace chip
