import os
import json
import time
import datetime
import src.utils as utils

DAY_IN_SECONDS = 86400

class LogManager:
    def __init__(self) -> None:
        self.JsonPath = os.path.join(os.path.dirname(__file__), "../json/session.json")
        self.CurrentLogFile = None
        self.CurrentLogFileName = None
        JsonFile = open(self.JsonPath)
        SessionData = json.load(JsonFile)

        self.LogsPath = os.path.join(os.path.dirname(__file__), "../logs")

        # Routine cleanup of LOGS older than "LOGS_LIFESPAN_DAYS" in session.json
        ExistingLogs = os.listdir(self.LogsPath)
        for log in ExistingLogs:
            if ".txt" in log and "mattertool_log" in log.lower():
                LogLocation = os.path.join(self.LogsPath + log)
                LogTime = os.stat(LogLocation).st_mtime

                if LogTime < time.time() - SessionData["LOGS_LIFESPAN_DAYS"] * DAY_IN_SECONDS:
                    os.remove(LogLocation)

        self.GetCurrentLogFile()

    # Close the current log file for safety
    def ExitRoutine(self) -> None:
        self.CurrentLogFile.close()

    # Close and remove the current log file
    def DeleteCurrentLogFile(self):
        utils.print_green("Erasing current logs...")
        self.CurrentLogFile.close()
        os.remove(self.CurrentLogFileName)
        self.CurrentLogFileName = None

    # Print current log file in terminal
    def PrintCurrentLogFile(self):
        if self.CurrentLogFile:
            self.CurrentLogFile.close()
            self.CurrentLogFile = open(self.CurrentLogFileName, 'r')
            print(self.CurrentLogFile.read())
            self.CurrentLogFile.close()
            self.CurrentLogFile = open(self.CurrentLogFileName, 'a')
        else:
            utils.print_red("Error: no log file within logs folder.")

    # List all the existing log files and their creation / modification time
    def ListLogs(self):
        utils.print_blue("Existing logs:")
        ExistingLogs = [self.LogsPath +  '/' + x for x in os.listdir(self.LogsPath)]
        for log in ExistingLogs:
            logname = log[log.rfind('/')+1:]
            utils.print_bold(logname)

    # Set self._current_log_file to most recent log file or create a new one
    def GetCurrentLogFile(self):
        ExistingLogs = [self.LogsPath +  '/' + x for x in os.listdir(self.LogsPath)]
        if len(ExistingLogs) > 0:
            current_log = max(ExistingLogs, key=os.path.getctime)
            self.CurrentLogFileName = current_log
            self.CurrentLogFile = open(current_log, 'a')
            return
        # Create a new log file
        LogFileName = "logs_{date:%Y-%m-%d_%H:%M:%S}.txt".format(date=datetime.datetime.now())
        self.CurrentLogFileName = self.LogsPath + '/' + LogFileName
        self.CurrentLogFile = open(self.CurrentLogFileName, 'x')

    def DumpCommandInfo(self, command: str) -> None:
        self.CurrentLogFile.write("==========")
        self.CurrentLogFile.write('\n')
        self.CurrentLogFile.write(command[command.rfind('/')+1:] + " at: " + '{date:%Y-%m-%d_%H:%M:%S}'.format(date=datetime.datetime.now()) + '\n')
        self.CurrentLogFile.write('\n')

    def DumpLine(self, line: str) -> None:
        self.CurrentLogFile.write(line + '\n')
        

        
