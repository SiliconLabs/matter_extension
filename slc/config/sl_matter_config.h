#ifndef SL_MATTER_CONFIG_H
#define SL_MATTER_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// <o SL_MATTER_STACK_LOCK_TRACKING_MODE> Stack Lock Tracking Mode
// <SL_MATTER_STACK_LOCK_TRACKING_NONE=> None
// <SL_MATTER_STACK_LOCK_TRACKING_LOG=> Log
// <SL_MATTER_STACK_LOCK_TRACKING_FATAL=> Fatal
// <i> Default: SL_MATTER_STACK_LOCK_TRACKING_FATAL
// <i> Controls how Matter stack lock violations are handled during development
#define SL_MATTER_STACK_LOCK_TRACKING_MODE SL_MATTER_STACK_LOCK_TRACKING_FATAL

// <o SL_MATTER_LOG_LEVEL> Log Level
// <SL_MATTER_LOG_NONE=> None
// <SL_MATTER_LOG_ERROR=> Error
// <SL_MATTER_LOG_PROGRESS=> Progress
// <SL_MATTER_LOG_DETAIL=> Detailed log (debug)
// <SL_MATTER_LOG_AUTOMATION=> Automation
// <i> Default: SL_MATTER_LOG_PROGRESS
// <i> Sets the verbosity of Matter stack logging output
#ifndef SL_MATTER_LOG_LEVEL
#define SL_MATTER_LOG_LEVEL SL_MATTER_LOG_PROGRESS
#endif

// <q SILABS_LOG_ENABLED> Enable Silabs specific log used in matter
// <i> Default: 1
// <i> Enables Silicon Labs platform-specific logging within the Matter stack
#ifndef SILABS_LOG_ENABLED
#define SILABS_LOG_ENABLED 1
#endif

// <q HARD_FAULT_LOG_ENABLE> Enable hard fault logging
// <i> Default: 1
// <i> Enables detailed logging when a hard fault (crash) occurs
#ifndef HARD_FAULT_LOG_ENABLE
#define HARD_FAULT_LOG_ENABLE 1
#endif

// <o CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION> Device software version
// <i> Default: 1
// <i> Must be incremented for each OTA firmware update
#define CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION 1

// <s.128 CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION_STRING> Device software version string
// <i> Human-readable software version string
#define CHIP_DEVICE_CONFIG_DEVICE_SOFTWARE_VERSION_STRING "1"

// <o CHIP_DEVICE_CONFIG_DEFAULT_DEVICE_HARDWARE_VERSION> Device hardware version
// <i> Default: 1
#define CHIP_DEVICE_CONFIG_DEFAULT_DEVICE_HARDWARE_VERSION 1

// <q SL_MATTER_CLI_ARG_PARSER> Enable CLI Argument Parser
// <i> Default: 1
// <i> Enables command-line interface argument parsing for Matter shell commands
// <i> Allows interactive debugging and testing via UART/RTT console
#ifndef SL_MATTER_CLI_ARG_PARSER
#define SL_MATTER_CLI_ARG_PARSER 1
#endif

// <q SL_MATTER_DEBUG_WATCHDOG_ENABLE> Enable a Watchdog with debug features
// <i> Default: 0
#ifndef SL_MATTER_DEBUG_WATCHDOG_ENABLE
#define SL_MATTER_DEBUG_WATCHDOG_ENABLE 0
#endif

// <o CHIP_DEVICE_CONFIG_MAX_DISCOVERED_IP_ADDRESSES> Define the default number of ip addresses to discover
// <i> Default: 5
// <i> Maximum number of IP addresses that can be discovered during device commissioning
#define CHIP_DEVICE_CONFIG_MAX_DISCOVERED_IP_ADDRESSES 5

// <o KVS_MAX_ENTRIES> Maximum amount of KVS Entries
// <i> Default: 511
// <i> Maximum number of Key-Value Store (KVS) entries for persistent storage
#define KVS_MAX_ENTRIES 511

// <q CHIP_CONFIG_SYNCHRONOUS_REPORTS_ENABLED> Synchronous Reports
// <i> Default: 0
#define CHIP_CONFIG_SYNCHRONOUS_REPORTS_ENABLED 0

// <o SL_MATTER_DEFERRED_ATTRIBUTE_STORE_DELAY_MS> Delay before the deferred attribute are stored in nvm
// <i> Default: 2000
#ifndef SL_MATTER_DEFERRED_ATTRIBUTE_STORE_DELAY_MS
#define SL_MATTER_DEFERRED_ATTRIBUTE_STORE_DELAY_MS 2000
#endif

// <<< end of configuration section >>>

#endif // SL_MATTER_CONFIG_H
