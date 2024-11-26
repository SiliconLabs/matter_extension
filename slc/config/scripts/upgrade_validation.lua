local changeset = {}

if not slc.is_provided("device_series_2") and not slc.is_provided("device_series_3") and not slc.is_provided("matter_platform_siwx917") then
    table.insert(changeset, {
        ["status"] = "impossible",
        ["description"] = "From 2.3.0 and above, Series 0 and Series 1 devices are no longer supported"}
    )
    return changeset
end


if slc.is_selected('matter_icd_management') then
    table.insert(changeset, {
      ['option'] = 'CHIP_CONFIG_SUBSCRIPTION_TIMEOUT_RESUMPTION',
      ['value'] = '0'
    })
end
if slc.is_selected('matter_subscription_synchronization') then
    table.insert(changeset, {
      ['option'] = 'CHIP_CONFIG_SYNCHRONOUS_REPORTS_ENABLED',
      ['value'] = '1'
    })
    table.insert(changeset, {
      ['component'] = 'matter_subscription_synchronization',
      ['action'] = 'remove',
    })
end

if slc.is_selected('matter_subscription_persistence') then
    table.insert(changeset, {
      ['option'] = 'CHIP_CONFIG_PERSIST_SUBSCRIPTIONS',
      ['value'] = '1'
    })
    table.insert(changeset, {
      ['component'] = 'matter_subscription_persistence',
      ['action'] = 'remove',
    })
end

if slc.is_selected('matter_icd_management') then
    table.insert(changeset, {
      ['option'] = 'SL_CSL_TIMEOUT',
      ['value'] = '30'
    })
end

if slc.is_selected('matter_icd_core') and not slc.is_selected('matter_icd_management') then
    table.insert(changeset, {
      ['component'] = 'matter_icd_core',
      ['action'] = 'remove'
    })
end
if slc.is_selected('matter_thread') then
    table.insert(changeset, {
      ['component'] = 'ot_rtos_wrapers_stub',
      ['action'] = 'remove'
    })
end
if slc.is_selected('matter_thread') then
    table.insert(changeset, {
      ['component'] = 'ot_rtos_wrappers_real',
      ['action'] = 'remove'
    })
end
if slc.is_selected('silabs_factory_data_provider') then
    table.insert(changeset, {
      ['component'] = 'silabs_factory_data_provider',
      ['action'] = 'remove'
    })
end

return changeset
