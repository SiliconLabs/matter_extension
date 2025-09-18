local changeset = {}

-- Increase SL_BT_RTOS_EVENT_HANDLER_STACK_SIZE to 1856 for Series 3 devices
if slc.is_selected('device_series_3') and slc.config("SL_BT_RTOS_EVENT_HANDLER_STACK_SIZE").value < 1856 then
  table.insert(changeset, {
    ['option'] = 'SL_BT_RTOS_EVENT_HANDLER_STACK_SIZE',
    ['value'] = '1856',
    ['description'] = "Increase SL_BT_RTOS_EVENT_HANDLER_STACK_SIZE to 1856"
  }) 
end
  
return changeset
