local changeset = {}

-- Setting the Listen interval of 3000ms for wifi sleepy apps
if slc.is_selected('matter_wifi') and slc.is_selected('matter_icd_core') then
  table.insert(changeset, {
    ['option'] = 'SL_TRANSPORT_IDLE_INTERVAL',
    ['value'] = '3000',
    ['description'] = "Setting the IDLE interval to 3000sec for WiFi sleepy"
  })
end

return changeset