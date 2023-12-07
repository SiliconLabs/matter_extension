
#ifndef SL_MATTER_ICD_CONFIG_H
#define SL_MATTER_ICD_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// <o SL_ACTIVE_MODE_THRESHOLD> OpenThread Active Mode Threshold
#define SL_ACTIVE_MODE_THRESHOLD 500

// <o SL_ACTIVE_MODE_INTERVAL> OpenThread Active Mode Interval
#define SL_ACTIVE_MODE_INTERVAL 1000

// <o SL_IDLE_MODE_INTERVAL> OpenThread Idle Mode
#define SL_IDLE_MODE_INTERVAL 600

// <o SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC> OpenThread ICD Supported Clients
#define SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC 2

// These defines are needed only for applications using OpenThread
// <o SL_OT_IDLE_INTERVAL> OpenThread Idle Interval
#define SL_OT_IDLE_INTERVAL 15000 

// <o SL_OT_ACTIVE_INTERVAL> OpenThread Active Interval
#define SL_OT_ACTIVE_INTERVAL 200

// <<< end of configuration section >>>

#endif // SL_MATTER_ICD_CONFIG_H