local lit = slc.config("CHIP_CONFIG_ENABLE_ICD_LIT").value
local cip = slc.config("CHIP_CONFIG_ENABLE_ICD_CIP").value
local uat = slc.config("CHIP_CONFIG_ENABLE_ICD_UAT").value
local active_mode_threshold = slc.config("SL_ACTIVE_MODE_THRESHOLD").value
local const_min_active_mode_threshold = 5000


if lit == "1" and cip ~= "1" then
    validation.error("Check in protocol must be enabled for LIT ICD devies.",
                      validation.target_for_project(),
                      "Enable CHIP_CONFIG_ENABLE_ICD_CIP within configuration settings and install the matter_check_in_sender component.",
                      nil
    )
end
if lit == "1" and uat ~= "1" then
    validation.error("UAT must be enabled for LIT ICD devies.",
                      validation.target_for_project(),
                      "Enable CHIP_CONFIG_ENABLE_ICD_UAT within configuration settings.",
                      nil
    )
end
if lit == "1" and autonumber_common.autonumber(active_mode_threshold) < const_min_active_mode_threshold then
    validation.error("SL_ACTIVE_MODE_THRESHOLD must greater than 5 seconds.",
                      validation.target_for_project(),
                      "Increase SL_ACTIVE_MODE_THRESHOLD within configuration settings.",
                      nil
    )
end
if cip == 1 and not slc.is_selected("matter_icd_checkin_sender") then
    validation.error("CHIP_CONFIG_ENABLE_ICD_CIP enabled but not the component.",
                      validation.target_for_project(),
                      "Include the matter_check_in_sender component, or select false.",
                      nil
    )
end
if slc.is_selected("matter_icd_checkin_sender") and cip == 0 then
    validation.error("matter_check_in_sender installed but CHIP_CONFIG_ENABLE_ICD_CIP is false.",
                      validation.target_for_project(),
                      "Define CHIP_CONFIG_ENABLE_ICD_CIP to be true, or select false.",
                      nil
    )
end
if slc.is_selected("matter_icd_core") and not slc.is_selected("matter_icd_management") then
    validation.error("matter_icd_core installed but matter_icd_management is not.",
                      validation.target_for_project(),
                      "Enable the ICD management cluster within ZAP.",
                      nil
    )
end