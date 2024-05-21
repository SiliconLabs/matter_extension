
#ifndef SL_MATTER_ICD_CONFIG_H
#define SL_MATTER_ICD_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

#ifndef CHIP_CONFIG_ENABLE_ICD_SERVER
#define CHIP_CONFIG_ENABLE_ICD_SERVER 0
#endif

#ifndef ICD_REPORT_ON_ENTER_ACTIVE_MODE
#define ICD_REPORT_ON_ENTER_ACTIVE_MODE 1
#endif

// <<< Use Configuration Wizard in Context Menu >>>

// <o SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC> OpenThread ICD Supported Clients
#define SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC 2

// These defines are needed only for applications using OpenThread
// <o SL_OT_IDLE_INTERVAL> OpenThread Idle Interval
#define SL_OT_IDLE_INTERVAL 15000 

// <o SL_OT_ACTIVE_INTERVAL> OpenThread Active Interval
#define SL_OT_ACTIVE_INTERVAL 200

// <o SL_IDLE_MODE_DURATION_S> Matter Idle Mode duration
#define SL_IDLE_MODE_DURATION_S 600

// <o SL_IDLE_MODE_DURATION_S> Matter Active Mode duration
#define SL_ACTIVE_MODE_DURATION_MS 10000

// <o SL_IDLE_MODE_DURATION_S> Matter Active Mode threshold
#define SL_ACTIVE_MODE_THRESHOLD 1000

// <<< end of configuration section >>>

#endif // SL_MATTER_ICD_CONFIG_H