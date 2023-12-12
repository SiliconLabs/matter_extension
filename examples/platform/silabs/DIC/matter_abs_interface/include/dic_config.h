/**
 * @file
 * @brief Matter abstraction layer for Direct Internet Connectivity.
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc.
 *www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon
 *Laboratories Inc. Your use of this software is
 *governed by the terms of Silicon Labs Master
 *Software License Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement.
 *This software is distributed to you in Source Code
 *format and is governed by the sections of the MSLA
 *applicable to Source Code.
 *
 ******************************************************************************/

#ifndef __DIC_CONFIG_H
#define __DIC_CONFIG_H

/*certificates*/
#define USE_AWS 1
#define USE_MOSQUITTO 0

/* Task Configuration*/
#define DIC_TASK_NAME "DIC"
#define DIC_TASK_STACK_SIZE (2*1024)  //2k
#define DIC_TASK_PRIORITY 5

/* Network Configuration*/
#define DIC_SERVER_PORT	8883

#define DIC_KEEP_ALIVE 0

#if USE_AWS
#define DIC_CLIENT_ID "SQA_DIC_C2"
#define DIC_CLIENT_USER NULL
#define DIC_CLIENT_PASS NULL

#elif USE_MOSQUITTO

#define DIC_CLIENT_USER ""
#define DIC_CLIENT_PASS ""


#endif //USE_MOSQUITTO

#endif // __DIC_CONFIG_H