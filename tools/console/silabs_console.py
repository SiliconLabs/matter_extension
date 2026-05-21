#!/usr/bin/env python3
"""
Silicon Labs Matter Console - Main Application.

This script provides the main entry point for the Silicon Labs Matter Console,
handling serial communication and coordinating between the UI and parser modules.
"""

import argparse
import sys
import threading
import time
from typing import Optional

import serial
from PyQt5.QtWidgets import QApplication

from console_log_parser import LogParser, MessageBuffer
from console_ui import ConsoleUI


class SilabsMatterConsole:
    """Main application class managing serial connection and UI coordination."""
    
    def __init__(self, port: str, baudrate: int) -> None:
        """
        Initialize the Matter console application.
        Args:
            port: Serial port name.
            baudrate: Serial baudrate.
        """
        self.port: str = port
        self.baudrate: int = baudrate
        self.serial_conn: Optional[serial.Serial] = None
        self.running: bool = False
        self.serial_thread: Optional[threading.Thread] = None
        
        # Initialize parser and UI
        self.parser: LogParser = LogParser()
        self.message_buffer: MessageBuffer = MessageBuffer(self.parser)
        self.ui: ConsoleUI = ConsoleUI(port, baudrate)
        
        # Set UI callbacks
        self.ui.set_callbacks(
            on_connect=self.connect_serial,
            on_disconnect=self.disconnect_serial,
            on_send_command=self.send_command
        )
    
    def open_serial(self) -> bool:
        """
        Open the serial port connection with flow control enabled.
        Returns:
            True if successful, False otherwise.
        """
        try:
            self.serial_conn = serial.Serial(
                self.port,
                self.baudrate,
                timeout=0.1,
                rtscts=True,
                dsrdtr=True
            )
            return True
        except serial.SerialException as e:
            self.ui.signals.error_message.emit(f"Error opening serial port: {e}")
            return False
    
    def close_serial(self) -> None:
        """Close the serial port connection."""
        if self.serial_conn and self.serial_conn.is_open:
            self.serial_conn.close()
    
    def connect_serial(self) -> None:
        """Connect to the serial port and start monitoring."""
        if self.ui.replay_mode:
            self.ui.statusBar().showMessage("Cannot connect while in replay mode", 3000)
            return
        
        if self.open_serial():
            self.running = True
            self.message_buffer.reset()
            
            # Start serial reading thread
            self.serial_thread = threading.Thread(target=self.read_serial_thread, daemon=True)
            self.serial_thread.start()
            
            # Update UI
            self.ui.set_connected_state(True)
        else:
            self.ui.statusBar().showMessage("Failed to connect to serial port", 5000)
    
    def disconnect_serial(self) -> None:
        """Disconnect from the serial port."""
        self.running = False
        time.sleep(0.2)
        self.close_serial()
        
        # Update UI
        self.ui.set_connected_state(False)
    
    def read_serial_thread(self) -> None:
        """Background thread to read from serial port and parse messages."""
        while self.running:
            try:
                if self.serial_conn and self.serial_conn.is_open and self.serial_conn.in_waiting > 0:
                    data = self.serial_conn.read(self.serial_conn.in_waiting)
                    
                    # Process data through message buffer
                    log_messages, interactive_messages, corrupted_count, truncated_count, missed_logs_count = \
                        self.message_buffer.process_data(data)
                    
                    # Emit log messages
                    for log_msg, category, module in log_messages:
                        self.ui.signals.log_message.emit(log_msg, category, module)
                        self.ui.signals.total_logs_increment.emit()
                    
                    # Emit interactive messages
                    for msg in interactive_messages:
                        self.ui.signals.interactive_message.emit(msg)
                    
                    # Emit statistics updates
                    if corrupted_count > 0:
                        for _ in range(corrupted_count):
                            self.ui.signals.corrupted_logs_increment.emit()
                    
                    if truncated_count > 0:
                        for _ in range(truncated_count):
                            self.ui.signals.truncated_logs_increment.emit()
                    
                    if missed_logs_count > 0:
                        self.ui.signals.missed_logs_increment.emit(missed_logs_count)
                    
            except (serial.SerialException, OSError) as e:
                if self.running:
                    self.ui.signals.error_message.emit(f"Error reading serial: {e}")
    
    def send_command(self, command: str) -> None:
        """
        Send a command to the serial port.
        
        Args:
            command: Command string to send.
        """
        if self.serial_conn and self.serial_conn.is_open:
            try:
                message = command.encode('ascii') + self.parser.MESSAGE_TERMINATOR
                self.serial_conn.write(message)
                self.ui.signals.interactive_message.emit(f"> {command}\r\n")
            except (serial.SerialException, OSError) as e:
                self.ui.signals.error_message.emit(f"Error sending command: {e}")
    
    def run(self) -> bool:
        """
        Start the console application.
        
        Returns:
            True if successful, False otherwise.
        """
        self.ui.show()
        return True
    
    def cleanup(self) -> None:
        """Clean up resources on application exit."""
        if self.running:
            self.running = False
            
            # Wait for serial thread to finish
            if self.serial_thread and self.serial_thread.is_alive():
                self.serial_thread.join(timeout=1.0)
            
            # Close serial connection
            self.close_serial()


def main() -> None:
    """Main entry point for the Silicon Labs Matter Console application."""
    parser = argparse.ArgumentParser(
        description="Silicon Labs Matter Console - Dual terminal interface for serial communication",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
This script provides a Qt-based dual terminal interface for monitoring and interacting
with a Silicon Labs device over a serial connection.

Features:
  - Dedicated log terminal for framed messages (SOF 0x01 ... EOF 0x04)
  - Interactive terminal for unframed messages
  - Color-coded log levels: [error] (red), [silabs] (blue), [info]/[detail] (white)
  - Auto-scrolling terminals with smooth rendering
  - Command input with history
  - Hardware flow control (RTS/CTS) enabled
  - Resizable window

Message Format:
  Framed logs: SOF(0x01) + message + EOF(0x04) + \\r\\n
  Unframed data goes directly to interactive terminal

Requirements:
  - PyQt5: pip install PyQt5
  - pyserial: pip install pyserial
        """
    )
    
    parser.add_argument(
        "port",
        help="Serial port to connect to (e.g., /dev/ttyACM0 or COM3)"
    )
    
    parser.add_argument(
        "-b", "--baudrate",
        type=int,
        default=115200,
        help="Baudrate for serial communication (default: 115200)"
    )
    
    args = parser.parse_args()
    
    app = QApplication(sys.argv)
    
    # Set dark theme
    app.setStyle('Fusion')
    
    console = SilabsMatterConsole(args.port, args.baudrate)
    
    # Handle cleanup on exit
    app.aboutToQuit.connect(console.cleanup)
    
    if console.run():
        sys.exit(app.exec_())
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
