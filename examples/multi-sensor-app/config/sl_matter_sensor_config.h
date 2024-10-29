#ifndef SL_MATTER_SENSOR_CONFIG_H
#define SL_MATTER_SENSOR_CONFIG_H

// <<< Use Configuration Wizard in Context Menu >>>

// <h> Matter multi-sensor application Configuration Header
// This header defines the multi-sensor application specific configurations.
// </h>

// <o SL_MATTER_SENSOR_TIMER_PERIOD_S> Timer period for the timer that reads the sensor value (s) <f.d>
// <0..4294967295:30>
// <i> The application will check the sensor value every SL_MATTER_SENSOR_TIMER_PERIOD_S seconds
// <i> and update the data model attributes each time. Reading the sensor value and updating it
// <i> does not always trigger an update to the controller.
// <d> 60
#define SL_MATTER_SENSOR_TIMER_PERIOD_S 60

// <o SL_MATTER_SENSOR_REPORT_THRESHOLD> Attribute report centi-unit change threshold
// <0..255:1>
// <i> Configuration option that dictates how much the attribute value must change, from the last report
// <i> to trigger Subscription update to controllers. A single step in the configuration option increasing
// <i> the attribute threshold of centi-unit. For a temperature sensor, 1 unit equals to 0.01 centigrade.
// <d> 100
#define SL_MATTER_SENSOR_REPORT_THRESHOLD 100

// <<< end of configuration section >>>

#endif // SL_MATTER_SENSOR_CONFIG_H