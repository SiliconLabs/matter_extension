#ifndef SL_MATTER_ICD_CONFIG_H
#define SL_MATTER_ICD_CONFIG_H

// Default ICD implementation configuration

// <<< Use Configuration Wizard in Context Menu >>>

// <o SL_IDLE_MODE_DURATION_S>  Idle Mode Duration (sec)
// <i> Duration the ICD device remains in idle mode between check-ins
// <i> Longer duration reduces power consumption but increases response latency
// <i> Default: 600 (10 minutes)
#define SL_IDLE_MODE_DURATION_S 600

// <o SL_SHORT_IDLE_MODE_DURATION_S>  Short Idle Mode Duration (sec)
// <i> A shorter idle mode duration when a LIT capable device is operating as a SIT
// <i> Default value is to use the same value as SL_IDLE_MODE_DURATION_S
#define SL_SHORT_IDLE_MODE_DURATION_S SL_IDLE_MODE_DURATION_S

// <o SL_ACTIVE_MODE_DURATION_MS>  Active Mode Duration (ms)
// <i> Duration the ICD device remains in active mode to process messages
// <i> Device stays awake during this period to handle incoming communications
// <i> Default: 1000 (1 second)
#define SL_ACTIVE_MODE_DURATION_MS 1000

// <o SL_ACTIVE_MODE_THRESHOLD>  Active Mode Threshold (ms)
// <i> Minimum time device must remain active after receiving a message
// <i> Default: 500 milliseconds
#define SL_ACTIVE_MODE_THRESHOLD 500

// <o SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC>  ICD Supported Clients
// <i> Maximum number of clients that can register with this ICD device per fabric
// <i> Default: 2 clients
#define SL_ICD_SUPPORTED_CLIENTS_PER_FABRIC 2

// <o SL_TRANSPORT_IDLE_INTERVAL>  Transport Idle Interval (ms)
// <i> Controllers wait this long before retrying communication with sleeping device
// <i> Default: 15000 milliseconds (15 seconds)
#define SL_TRANSPORT_IDLE_INTERVAL 15000

// <o SL_TRANSPORT_ACTIVE_INTERVAL>  Transport Active Interval (ms)
// <i> Controllers use this shorter timeout when device is known to be awake
// <i> Default: 200 milliseconds
#define SL_TRANSPORT_ACTIVE_INTERVAL 200

// <o SL_CSL_TIMEOUT>  CSL Timeout (sec)
// <i> Maximum time device waits for synchronized communication window
// <i> Coordinated Sampled Listening Timeout (Default: 30 seconds)
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