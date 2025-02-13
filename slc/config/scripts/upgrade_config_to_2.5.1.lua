local changeset = {}

-- For CMP apps set SL_CLI_EXAMPLE_TASK_STACK_SIZE to 600
if slc.is_selected('matter_zigbee_concurrent') or slc.is_selected('matter_sequential') then
    -- The 'matter_zigbee_concurrent' component is present
    table.insert(changeset, {
      ['option'] = 'SL_CLI_EXAMPLE_TASK_STACK_SIZE',
      ['value'] = '600',
      ['description'] = "Setting SL_CLI_EXAMPLE_TASK_STACK_SIZE to 600 "
    })
end

-- Make sure SL_MBEDTLS_PSA_ASSUME_EXCLUSIVE_BUFFERS is set to 1 in all Thread projects
if slc.is_selected('matter_thread') then 
  table.insert(changeset, {
    ['option'] = 'SL_MBEDTLS_PSA_ASSUME_EXCLUSIVE_BUFFERS',
    ['value'] = '1',
    ['description'] = "Setting SL_MBEDTLS_PSA_ASSUME_EXCLUSIVE_BUFFERS to 1"
  }) 
end
  
return changeset
