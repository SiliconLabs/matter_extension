#!/usr/bin/env python3
"""
Console Log Parser - Message parsing and filtering logic.

This module handles all log parsing, filtering, and categorization logic
for the Silicon Labs Matter Console application.
"""

import re
from typing import Optional, Tuple


class LogParser:
    """Handles parsing and categorization of log messages."""
    
    START_OF_FRAME = 0x01
    END_OF_FRAME = 0x04
    MESSAGE_TERMINATOR = b'\r\n'
    
    def __init__(self) -> None:
        """Initialize the log parser."""
        self.missed_logs_pattern = re.compile(r'Missed Logs:\s*(\d+)')
    
    def get_message_category(self, message: str) -> str:
        """
        Determine the category of a log message.
        Args:
            message: The log message to categorize.
        Returns:
            Category string: 'error', 'warn', 'silabs', 'detail', or 'info'.
        """
        message_lower = message.lower()
        if '[error]' in message_lower or '[error ]' in message_lower:
            return 'error'
        elif '[warn]' in message_lower or '[warn ]' in message_lower:
            return 'warn'
        elif '[silabs]' in message_lower or '[silabs ]' in message_lower:
            return 'silabs'
        elif '[detail]' in message_lower or '[detail ]' in message_lower:
            return 'detail'
        elif '[info]' in message_lower or '[info ]' in message_lower:
            return 'info'
        else:
            return 'info'
    
    def get_message_module(self, message: str) -> Optional[str]:
        """
        Determine the module of a log message.
        Args:
            message: The log message to check.
        Returns:
            Module string or None if no specific module is identified.
        """
        message_lower = message.lower()
        if '[zcl]' in message_lower:
            return 'zcl'
        elif '[dl]' in message_lower:
            return 'dl'
        elif '[im]' in message_lower:
            return 'im'
        elif '[ot]' in message_lower:
            return 'ot'
        elif '[svr]' in message_lower:
            return 'svr'
        elif '[dis]' in message_lower:
            return 'dis'
        elif '[swu]' in message_lower:
            return 'swu'
        elif '[tst]' in message_lower:
            return 'tst'
        else:
            return None
    
    def is_truncated_log(self, message: str) -> bool:
        """
        Check if a log message is truncated.
        Args:
            message: The log message to check.
        Returns:
            True if the message ends with '.....', False otherwise.
        """
        return message.rstrip().endswith('.....')
    
    def extract_missed_logs_count(self, message: str) -> Optional[int]:
        """
        Extract missed logs count from a message.
        Args:
            message: The message to parse.
        Returns:
            The number of missed logs, or None if pattern not found.
        """
        match = self.missed_logs_pattern.search(message)
        if match:
            return int(match.group(1))
        return None


class MessageBuffer:
    """Handles buffering and processing of serial data into messages."""
    
    def __init__(self, parser: LogParser) -> None:
        """
        Initialize the message buffer.
        Args:
            parser: LogParser instance for message categorization.
        """
        self.parser: LogParser = parser
        self.buffer: bytearray = bytearray()
        self.frame_buffer: bytearray = bytearray()
        self.cmd_buffer: bytearray = bytearray()
        self.in_frame: bool = False
        self.first_terminator_received: bool = False
    
    def process_data(self, data: bytes) -> Tuple[list, list, int, int, int]:
        """
        Process incoming serial data and extract messages.
        Args:
            data: Raw bytes from serial port.
        Returns:
            Tuple containing:
                - List of (log_message, category, module) tuples
                - List of interactive messages
                - Number of corrupted logs detected
                - Number of truncated logs detected
                - Missed logs count
        """
        log_messages = []
        interactive_messages = []
        corrupted_count = 0
        truncated_count = 0
        missed_logs_count = 0
        
        self.buffer.extend(data)
        
        i = 0
        while i < len(self.buffer):
            byte = self.buffer[i]
            
            if byte == self.parser.START_OF_FRAME and not self.in_frame:
                # Start of a new frame
                self.in_frame = True
                self.frame_buffer = bytearray()
                i += 1
                
            elif byte == self.parser.END_OF_FRAME and not self.in_frame:
                # EOF without SOF - framing error
                corrupted_count += 1
                i += 1
                
            elif self.in_frame:
                # Check for end of frame
                if byte == self.parser.END_OF_FRAME:
                    # Decode and prepare log message
                    log_msg = self.frame_buffer.decode('ascii', errors='replace')
                    category = self.parser.get_message_category(log_msg)
                    module = self.parser.get_message_module(log_msg)
                    log_messages.append((log_msg, category, module))
                    
                    # Check if log is truncated
                    if self.parser.is_truncated_log(log_msg):
                        truncated_count += 1
                    
                    self.in_frame = False
                    self.frame_buffer = bytearray()
                else:
                    self.frame_buffer.append(byte)
                i += 1
                
            elif not self.in_frame:
                self.cmd_buffer.append(byte)
                i += 1
                if byte == self.parser.MESSAGE_TERMINATOR[0]:
                    self.first_terminator_received = True
                elif self.first_terminator_received and byte == self.parser.MESSAGE_TERMINATOR[1]:
                    message = self.cmd_buffer.decode('ascii', errors='replace')
                    
                    # Check for "Missed Logs: X" pattern
                    count = self.parser.extract_missed_logs_count(message)
                    if count is not None:
                        missed_logs_count += count
                    else:
                        # Normal message
                        interactive_messages.append(message)
                    
                    self.cmd_buffer = bytearray()
                    self.first_terminator_received = False
            else:
                i += 1
        
        # Clear processed bytes from buffer
        self.buffer = self.buffer[i:]
        
        return log_messages, interactive_messages, corrupted_count, truncated_count, missed_logs_count
    
    def reset(self) -> None:
        """Reset all buffers to initial state."""
        self.buffer = bytearray()
        self.frame_buffer = bytearray()
        self.cmd_buffer = bytearray()
        self.in_frame = False
        self.first_terminator_received = False


class LogFilter:
    """Manages log filtering based on categories and modules."""
    
    def __init__(self) -> None:
        """Initialize the log filter with default settings."""
        self.category_filters: dict = {
            'error': True,
            'warn': True,
            'info': True,
            'detail': True,
            'silabs': True
        }
        
        self.module_filters: dict = {
            'zcl': True,
            'dl': True,
            'im': True,
            'ot': True,
            'svr': True,
            'dis': True,
            'swu': True,
            'tst': True
        }
    
    def should_display_message(self, category: str, module: Optional[str]) -> bool:
        """
        Check if a message should be displayed based on current filters.
        
        Args:
            category: Message category ('error', 'warn', etc.).
            module: Message module ('zcl', 'dl', etc.) or None.
            
        Returns:
            True if message should be displayed, False otherwise.
        """
        category_enabled = self.category_filters.get(category, True)
        module_enabled = self.module_filters.get(module, True) if module else True
        return category_enabled and module_enabled
    
    def toggle_category(self, category: str) -> None:
        """
        Toggle a category filter on/off.
        
        Args:
            category: The category to toggle.
        """
        if category in self.category_filters:
            self.category_filters[category] = not self.category_filters[category]
    
    def get_active_categories(self) -> list:
        """
        Get list of currently active category filters.
        
        Returns:
            List of category names that are enabled.
        """
        return [cat for cat, enabled in self.category_filters.items() if enabled]
    
    def get_active_modules(self) -> list:
        """
        Get list of currently active module filters.
        
        Returns:
            List of module names that are enabled.
        """
        return [mod for mod, enabled in self.module_filters.items() if enabled]
    
    def set_module_filters(self, filters: dict) -> None:
        """
        Update module filters.
        
        Args:
            filters: Dictionary mapping module names to enabled state.
        """
        self.module_filters = filters.copy()
