#pragma once

#include <app-common/zap-generated/ids/Clusters.h>
#include <app/util/basic-types.h>
#include <lib/core/CHIPError.h>

// Carries the data needed to propagate a CookTop state change to a single
// bound cluster (e.g. OnOff on the RangeHood Light endpoint or FanControl
// on the Extractor Hood endpoint). A separate context is allocated per
// cluster in CookTopBindingPropagateState(); on success ownership transfers
// to the binding manager and it is freed via the context-release handler.
struct CookTopBindingContext
{
    chip::EndpointId localEndpointId;
    chip::ClusterId clusterId;
    bool cookTopOn;
};

CHIP_ERROR InitOvenBindingHandler();

// Propagate CookTop OnOff state to bound OnOff and FanControl clusters.
void CookTopBindingPropagateState(chip::EndpointId cookTopEndpoint, bool cookTopOn);
