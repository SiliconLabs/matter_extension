/***************************************************************************
 * @file FreeRTOSRuntimeStats.h
 * @brief FreeRTOS runtime statistics API for Silicon Labs platform.
 *******************************************************************************
 * # License
 * <b>Copyright 2024 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#pragma once

#if defined(configGENERATE_RUN_TIME_STATS) && configGENERATE_RUN_TIME_STATS == 1

#include "FreeRTOS.h"
#include "task.h"
#include <platform/silabs/tracing/SilabsTracingConfig.h>
#include <stdbool.h>
#include <stdint.h>

// Define configMAX_TASK_NAME_LEN if not already defined
#ifndef configMAX_TASK_NAME_LEN
#define configMAX_TASK_NAME_LEN 24
#endif
typedef struct
{
    TaskHandle_t handle;
    char name[configMAX_TASK_NAME_LEN];
    uint32_t switchOutCount;
    uint32_t preemptionCount;
    uint32_t lastSwitchOutTime;
    uint32_t lastMovedToReadyTime;
    uint32_t totalReadyTime;
    uint32_t readyTimeHighWaterMark;
    uint32_t lastMovedToRunningTime;
    uint32_t totalRunningTime;
    bool isDeleted;
} TaskStats;

typedef struct
{
    TaskStats stats;                // Core task statistics
    eTaskState state;               // Current task state
    UBaseType_t priority;           // Task priority
    UBaseType_t stackHighWaterMark; // Max stack used in bytes
    UBaseType_t stackMaxSize;       // Total allocated stack in bytes
    uint32_t runTimeCounter;        // Total CPU time in ms
    uint32_t cpuPercentage;         // CPU usage percentage (in basis points)
    uint32_t preemptionPercentage;  // Preemption percentage (in basis points)
} TaskInfo;

typedef struct
{
    uint32_t totalRunTime; // Total system run time in ms
    uint32_t totalSwitchOutCount;
    uint32_t totalPreemptionCount;
    uint32_t systemPreemptionRatio;
    uint32_t activeTaskCount;
    uint32_t terminatedTaskCount;
} SystemTaskStats;

/**
 * @brief Get the current runtime counter value in milliseconds.
 * @return Current runtime in milliseconds since system start
 */
uint32_t ulGetRunTimeCounterValue(void);

/**
 * @brief Task switch out hook function called when a task is switched out.
 */
void vTaskSwitchedOut(void);

/**
 * @brief Task switch in hook function called when a task is switched in.
 */
void vTaskSwitchedIn(void);

/**
 * @brief Task deletion hook function called when a task is deleted.
 * @param xTask Handle of the task being deleted
 */
void vTaskDeleted(void * xTask);

/**
 * @brief Task creation hook function called when a task is created.
 * @param xTask Handle of the task being created
 */
void vTaskCreated(void * xTask);

/**
 * @brief Task ready state hook function called when a task is moved to ready state.
 * @param xTask Handle of the task being moved to ready state
 */
void vTaskMovedToReadyState(void * xTask);

/**
 * @brief Get comprehensive task statistics for active and deleted tasks.
 * All times are in milliseconds and sizes are in bytes.
 * The statistics related to time such as Ready time and Running time should be considered approximate, as they are based on task
 * switch hooks and a timer with a resolution of 1 ms. The values are best effort and may not be accurate. Furthermore, systems that
 * use FreeRTOS tickless idle may have even less accuracy.
 * @param taskInfoArray Array to store task information
 * @param taskInfoArraySize Maximum number of tasks the array can hold
 * @param systemStats Pointer to store system-wide statistics (optional)
 * @return Number of tasks actually returned, or 0 on error
 */
uint32_t ulGetAllTaskInfo(TaskInfo * taskInfoArray, uint32_t taskInfoArraySize, SystemTaskStats * systemStats);

#endif // configGENERATE_RUN_TIME_STATS == 1
