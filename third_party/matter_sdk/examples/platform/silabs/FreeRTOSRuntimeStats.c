/***************************************************************************
 * @file FreeRTOSRuntimeStats.c
 * @brief FreeRTOS runtime statistics timer implementation for Silicon Labs platform.
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
#include "FreeRTOSConfig.h"

#if defined(configGENERATE_RUN_TIME_STATS) && configGENERATE_RUN_TIME_STATS == 1

#include "FreeRTOS.h"
#include "FreeRTOSRuntimeStats.h"
#include "task.h"
#include <string.h>

#pragma message(                                                                                                                   \
        "FreeRTOS Runtime statistics are enabled. This is a debugging feature and may have an impact on performance. Disable for release builds. Set TRACING_RUNTIME_STATS to 0 in SilabsTracingConfig.h to disable.")

// Global tracking variables
static volatile uint32_t sTaskSwitchCount         = 0;
static volatile uint32_t sPreemptionCount         = 0;
static volatile TaskHandle_t sLastTaskSwitchedOut = NULL;

// Simple task statistics tracking (only active tasks)
static TaskStats sTaskStats[TRACING_RUNTIME_STATS_MAX_TASKS];
static volatile uint32_t sTaskCount = 0;

static TaskStats * findTaskStats(TaskHandle_t handle)
{
    for (uint32_t i = 0; i < sTaskCount; i++)
    {
        if (sTaskStats[i].handle == handle && !sTaskStats[i].isDeleted)
        {
            return &sTaskStats[i];
        }
    }
    return NULL;
}

static TaskStats * createTaskStats(TaskHandle_t handle)
{
    if (sTaskCount >= TRACING_RUNTIME_STATS_MAX_TASKS || handle == NULL)
    {
        return NULL;
    }

    TaskStats * stats = &sTaskStats[sTaskCount++];
    memset(stats, 0, sizeof(TaskStats));
    stats->handle = handle;

    // Store task name
    const char * taskName = pcTaskGetName(handle);
    if (taskName)
    {
        strncpy(stats->name, taskName, configMAX_TASK_NAME_LEN - 1);
        stats->name[configMAX_TASK_NAME_LEN - 1] = '\0';
    }

    return stats;
}

void vTaskDeleted(void * xTask)
{
    if (xTask == NULL)
        return;

    TaskHandle_t handle = (TaskHandle_t) xTask;
    TaskStats * stats   = findTaskStats(handle);
    if (stats != NULL)
    {
        stats->handle    = NULL;
        stats->isDeleted = true;
        return;
    }

    // Task not found in our tracking, task was never switched out
    if (sTaskCount < TRACING_RUNTIME_STATS_MAX_TASKS)
    {
        TaskStats * stats        = &sTaskStats[sTaskCount++];
        stats->handle            = NULL;
        stats->switchOutCount    = 0;
        stats->preemptionCount   = 0;
        stats->totalReadyTime    = 0;
        stats->totalRunningTime  = 0;
        stats->lastSwitchOutTime = ulGetRunTimeCounterValue(); // Deletion time since we don't have any other details about it
        stats->isDeleted         = true;

        // Try to get task name before it's completely gone
        const char * taskName = pcTaskGetName((TaskHandle_t) xTask);
        if (taskName)
        {
            strncpy(stats->name, taskName, configMAX_TASK_NAME_LEN - 1);
            stats->name[configMAX_TASK_NAME_LEN - 1] = '\0';
        }
    }
}

void vTaskCreated(void * xTask)
{
    if (xTask == NULL)
        return;

    TaskHandle_t handle = (TaskHandle_t) xTask;
    TaskStats * stats   = findTaskStats(handle);
    if (stats == NULL)
    {
        createTaskStats(handle);
    }
    if (stats != NULL)
    {
        stats->lastMovedToReadyTime = ulGetRunTimeCounterValue();
    }
}

void vTaskMovedToReadyState(void * xTask)
{
    if (xTask == NULL)
        return;

    TaskHandle_t handle = (TaskHandle_t) xTask;
    TaskStats * stats   = findTaskStats(handle);
    if (stats == NULL)
    {
        stats = createTaskStats(handle);
    }
    if (stats != NULL)
    {
        stats->lastMovedToReadyTime = ulGetRunTimeCounterValue();
    }
}

uint32_t ulGetRunTimeCounterValue(void)
{
    // Return time in milliseconds since system start
    // The '1000' is for second to millisecond conversion
    return ((uint64_t) xTaskGetTickCount() * 1000) / configTICK_RATE_HZ;
}

void vTaskSwitchedOut(void)
{
    sTaskSwitchCount++;
    TaskHandle_t currentTask = xTaskGetCurrentTaskHandle();
    sLastTaskSwitchedOut     = currentTask;

    TaskStats * stats = findTaskStats(currentTask);
    if (stats == NULL)
    {
        stats = createTaskStats(currentTask);
    }

    if (stats != NULL)
    {
        stats->switchOutCount++;
        stats->lastSwitchOutTime = ulGetRunTimeCounterValue();
        // Don't set lastMovedToReadyTime here - we don't know the target state yet
        if (stats->lastMovedToRunningTime != 0)
        {
            uint32_t timeInRunning = ulGetRunTimeCounterValue() - stats->lastMovedToRunningTime;
            stats->totalRunningTime += timeInRunning;
            stats->lastMovedToRunningTime = 0;
        }
    }
}

void vTaskSwitchedIn(void)
{
    TaskStats * lastTaskStats = findTaskStats(sLastTaskSwitchedOut);
    // Check if last task was preempted (in Ready state right after being switched out)
    if (sLastTaskSwitchedOut != NULL && eTaskGetState(sLastTaskSwitchedOut) == eReady && lastTaskStats != NULL)
    {
        sPreemptionCount++;
        lastTaskStats->preemptionCount++;
        lastTaskStats->lastMovedToReadyTime = ulGetRunTimeCounterValue();
    }

    TaskHandle_t currentTask = xTaskGetCurrentTaskHandle();
    TaskStats * currentStats = findTaskStats(currentTask);
    if (currentStats == NULL)
    {
        currentStats = createTaskStats(currentTask);
    }

    if (currentStats != NULL && currentStats->lastMovedToReadyTime != 0)
    {
        uint32_t timeInReady = ulGetRunTimeCounterValue() - currentStats->lastMovedToReadyTime;
        currentStats->totalReadyTime += timeInReady;
        if (timeInReady > currentStats->readyTimeHighWaterMark)
        {
            currentStats->readyTimeHighWaterMark = timeInReady;
        }
        currentStats->lastMovedToReadyTime = 0;
    }

    if (currentStats != NULL)
    {
        currentStats->lastMovedToRunningTime = ulGetRunTimeCounterValue();
    }
}

uint32_t ulGetAllTaskInfo(TaskInfo * taskInfoArray, uint32_t taskInfoArraySize, SystemTaskStats * systemStats)
{
    if (taskInfoArray == NULL || taskInfoArraySize == 0)
        return 0;

    uint32_t taskCount = 0;

    // Initialize system stats
    if (systemStats != NULL)
    {
        memset(systemStats, 0, sizeof(SystemTaskStats));
        systemStats->totalRunTime         = ulGetRunTimeCounterValue();
        systemStats->totalSwitchOutCount  = sTaskSwitchCount;
        systemStats->totalPreemptionCount = sPreemptionCount;
        systemStats->systemPreemptionRatio =
            sTaskSwitchCount > 0 ? (uint32_t) (((uint64_t) sPreemptionCount * 10000) / sTaskSwitchCount) : 0;
    }

    // Don't exceed configured max tasks we can track.
    UBaseType_t numTasks = uxTaskGetNumberOfTasks();
    if (numTasks > taskInfoArraySize)
        numTasks = taskInfoArraySize;

    TaskStatus_t stackArray[TRACING_RUNTIME_STATS_MAX_TASKS];
    TaskStatus_t * taskArray = stackArray;

    uint32_t totalRunTime;
    UBaseType_t actualTasks = uxTaskGetSystemState(taskArray, numTasks, &totalRunTime);
    // actualTasks will be 0 if the array provided is too small

    // Populate task info for each active task returned by FreeRTOS
    for (UBaseType_t i = 0; i < actualTasks && taskCount < TRACING_RUNTIME_STATS_MAX_TASKS; i++)
    {
        TaskInfo * info       = &taskInfoArray[taskCount];
        TaskStatus_t * status = &taskArray[i];
        TaskStats * stats     = findTaskStats(status->xHandle);

        // Copy basic info
        strncpy(info->stats.name, status->pcTaskName, configMAX_TASK_NAME_LEN - 1);
        info->stats.name[configMAX_TASK_NAME_LEN - 1] = '\0';
        info->stats.handle                            = status->xHandle;
        info->state                                   = status->eCurrentState;
        info->priority                                = status->uxCurrentPriority;

        // Calculate stack sizes using the stack pointers
        size_t totalStackSize = (status->pxEndOfStack - status->pxStackBase) * sizeof(StackType_t);
        size_t usedStackSize  = totalStackSize - (status->usStackHighWaterMark * sizeof(StackType_t));

        info->stackHighWaterMark = usedStackSize;  // Max stack used in bytes
        info->stackMaxSize       = totalStackSize; // Total allocated stack in bytes

        info->runTimeCounter = status->ulRunTimeCounter;
        info->cpuPercentage  = totalRunTime > 0 ? (uint32_t) (((uint64_t) status->ulRunTimeCounter * 10000) / totalRunTime) : 0;

        // Add tracking stats if available
        if (stats != NULL)
        {
            info->stats = *stats;
            info->preemptionPercentage =
                stats->switchOutCount > 0 ? (uint32_t) (((uint64_t) stats->preemptionCount * 10000) / stats->switchOutCount) : 0;
        }
        else
        {
            memset(&info->stats, 0, sizeof(TaskStats));
        }

        taskCount++;
    }

    // Add deleted tasks from our tracking
    uint32_t deletedCount = 0;
    for (uint32_t i = 0; i < sTaskCount && taskCount < TRACING_RUNTIME_STATS_MAX_TASKS; i++)
    {
        if (sTaskStats[i].isDeleted)
        {
            TaskInfo * info   = &taskInfoArray[taskCount];
            TaskStats * stats = &sTaskStats[i];

            // Copy deleted task info
            strncpy(info->stats.name, stats->name, configMAX_TASK_NAME_LEN - 1);
            info->stats.name[configMAX_TASK_NAME_LEN - 1] = '\0';
            info->stats.handle                            = NULL;
            info->state = eDeleted; // While technically the deleted state is something else in FreeRTOS, we use eDeleted for the
                                    // purpose of this debug feature.
            info->priority           = 0;
            info->stackHighWaterMark = 0;
            info->runTimeCounter     = 0;
            info->cpuPercentage      = 0;
            info->stats              = *stats;
            info->preemptionPercentage =
                stats->switchOutCount > 0 ? (uint32_t) (((uint64_t) stats->preemptionCount * 10000) / stats->switchOutCount) : 0;

            taskCount++;
            deletedCount++;
        }
    }

    // Final system stats update
    if (systemStats != NULL)
    {
        systemStats->terminatedTaskCount = deletedCount;
        systemStats->activeTaskCount     = actualTasks;
    }

    return taskCount;
}

#endif // configGENERATE_RUN_TIME_STATS == 1
