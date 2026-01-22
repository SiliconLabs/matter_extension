#pragma once

#include <app-common/zap-generated/ids/Clusters.h>
#include <app-common/zap-generated/ids/Commands.h>
#include <app/util/basic-types.h>
#include <lib/core/CHIPError.h>

struct OnOffBindingContext
{
    chip::EndpointId localEndpointId;
    chip::CommandId commandId;
};

// Initialize binding manager (schedules init work)
CHIP_ERROR InitOvenBindingHandler();

// Notify that CookTop OnOff cluster changed using pre-filled context
CHIP_ERROR CookTopOnOffBindingTrigger(OnOffBindingContext * context);
