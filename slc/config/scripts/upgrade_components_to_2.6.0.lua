local changeset = {}

if slc.is_selected('matter_gatt') then
  table.insert(changeset, {
    ['component'] = '%extension-matter%matter_gatt',
    ['action'] = 'remove',
  })

  if slc.is_selected('matter_zigbee_multiprotocol_common') then
    table.insert(changeset, {
      ['component'] = '%extension-matter%matter_ble_side_channel',
      ['action'] = 'add'
    })
  else
    table.insert(changeset, {
      ['component'] = '%extension-matter%matter_gatt_static',
      ['action'] = 'add'
    })
  end
end
if slc.is_selected('matter_platform_siwx917') or slc.is_selected('siwx917_ncp') then
  table.insert(changeset, {
    ['component'] = '%extension-matter%wifi_resources',
    ['action'] = 'remove'
  })
  table.insert(changeset, {
    ['component'] = '%extension-wiseconnect3_sdk%wifi_resources',
    ['action'] = 'add'
  })
  table.insert(changeset, {
    ['component'] = '%extension-wiseconnect3_sdk%sl_si91x_lwip_stack',
    ['action'] = 'remove'
  })
  table.insert(changeset, {
    ['component'] = '%extension-matter%matter_lwip',
    ['action'] = 'add'
  })
end

return changeset