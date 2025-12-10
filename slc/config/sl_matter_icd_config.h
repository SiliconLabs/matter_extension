#ifndef SL_MATTER_ICD_CONFIG_H
#define SL_MATTER_ICD_CONFIG_H

// Default ICD implementation configuration

// <<< Use Configuration Wizard in Context Menu >>>

// <o SL_IDLE_MODE_DURATION_S>  Idle Mode Duration (sec)
// <i> 10 minute Idle Mode Duration
// <i> Default: 600
#define SL_IDLE_MODE_DURATION_S 600

// <o SL_SHORT_IDLE_MODE_DURATION_S>  Short Idle Mode Duration (sec)
// <i> A shorter idle mode duration when a LIT capable device is operating as a SIT
// <i> Default value is to use the same value as SL_IDLE_MODE_DURATION_S
#define SL_SHORT_IDLE_MODE_DURATION_S SL_IDLE_MODE_DURATION_S

// <o SL_ACTIVE_MODE_DURATION_MS>  Active Mode Duration (ms)
// <i> 1 second Active Mode Duration
// <i> Default: 1000
#define SL_ACTIVE_MODE_DURATION_MS 1000

// <o SL_ACTIVE_MODE_THRESHOLD>  Active Mode Threshold (ms)
// <i> 500ms Active Mode Threshold
// <i> Default: 500
#define SL_ACTIVE_MODE_THRESHOLD 500

// <o SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC>  ICD Supported Clients
// <i> Default: 2
#define SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC 2

// <o SL_TRANSPORT_IDLE_INTERVAL>  Transport Idle Interval (ms)
// <i> Default: 15000
#define SL_TRANSPORT_IDLE_INTERVAL 15000

// <o SL_TRANSPORT_ACTIVE_INTERVAL>  Transport Active Interval (ms)
// <i> Default: 200
#define SL_TRANSPORT_ACTIVE_INTERVAL 200

// <o SL_CSL_TIMEOUT>  CSL Timeout (sec)
// <i> Coordinated Sampled Listening Timeout (Default: 30)
// <i> Feature requires matter_synchronized_sed component
#define SL_CSL_TIMEOUT 30

// <q CHIP_CONFIG_ENABLE_ICD_DSLS>  Enable Dynamic SIT-LIT Switching
// <i> Dynamic Switching from Short Idle Time to Long Idle Time (Default: 0)
// <i> Set to true if device supports dynamic switching from SIT to LIT operating modes (DSLS)
#define CHIP_CONFIG_ENABLE_ICD_DSLS 0

// <q SL_ICD_ENABLE_SELECTIVE_SLEEP>  Enable Dynamic DTIM-LI-based Switching
// <i> Dynamic Switching from DTIM based to Long Interval based sleep (Default: 1)
// <i> Set to true, if device supports dynamic switching from DTIM based to Long Interval based sleep (Selective Sleep)
// <i> This feature is used to reduce power consumption in devices that support both DTIM and Long Interval based sleep modes.
#define SL_ICD_ENABLE_SELECTIVE_SLEEP 1

// <<< end of configuration section >>>

#endif // SL_MATTER_ICD_CONFIG_H