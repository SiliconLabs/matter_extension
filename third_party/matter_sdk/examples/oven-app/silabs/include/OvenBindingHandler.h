#pragma once

#include <app-common/zap-generated/ids/Clusters.h>
#include <app/util/basic-types.h>
#include <lib/core/CHIPError.h>

// Carries the data needed to propagate a CookTop state change to a single
// bound cluster (e.g. OnOff on the RangeHood Light endpoint or FanControl
// on the Extractor Hood endpoint). A separate context is allocated per
// cluster trigger; see CookTopBindingTrigger() for ownership semantics.
struct CookTopBindingContext
{
    chip::EndpointId localEndpointId;
    chip::ClusterId clusterId;
    bool cookTopOn;
};

CHIP_ERROR InitOvenBindingHandler();

// Schedule binding propagation for the cluster carried in |context|.
// On success, ownership of |context| transfers to the binding manager and
// it is freed via the registered context-release handler. On failure, the
// caller retains ownership and must free it.
CHIP_ERROR CookTopBindingTrigger(CookTopBindingContext * context);
