#!/usr/bin/env python3
"""
Console UI - Qt-based user interface components.

This module contains all Qt UI components for the Silicon Labs Matter Console
application, including the main window, dialogs, and widgets.
"""

import glob
from datetime import datetime
from typing import List, Optional

from PyQt5.QtCore import QObject, QTimer, Qt, pyqtSignal
from PyQt5.QtGui import QColor, QFont, QTextCharFormat, QTextCursor
from PyQt5.QtWidgets import (
    QCheckBox,
    QComboBox,
    QDialog,
    QFileDialog,
    QFormLayout,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMainWindow,
    QMessageBox,
    QPushButton,
    QSplitter,
    QTextEdit,
    QVBoxLayout,
    QWidget,
)


# Light purple color used to render Zigbee ([ZB]) log entries.
ZIGBEE_COLOR = "#C77DFF"

# Glob patterns matching plausible serial ports for a Matter project under /dev/.
SERIAL_PORT_GLOBS = (
    "/dev/cu.*",
    "/dev/tty.usb*",
    "/dev/ttyACM*",
)


def find_available_serial_ports() -> List[str]:
    """
    Scan /dev/ for serial port device files plausible for a Matter project.
    
    Matches files against ``cu.*``, ``tty.usb*`` and ``ttyACM*`` patterns.
    
    Returns:
        Sorted list of unique device paths.
    """
    ports: set = set()
    for pattern in SERIAL_PORT_GLOBS:
        ports.update(glob.glob(pattern))
    return sorted(ports)


class SignalEmitter(QObject):
    """Qt signal emitter for thread-safe UI updates."""

    log_message = pyqtSignal(str, str, object)  # message, category, module
    interactive_message = pyqtSignal(str)
    error_message = pyqtSignal(str)
    missed_logs_increment = pyqtSignal(int)
    corrupted_logs_increment = pyqtSignal()
    truncated_logs_increment = pyqtSignal()
    total_logs_increment = pyqtSignal()


class ConsoleUI(QMainWindow):
    """Main window UI for the dual-terminal console interface."""
    
    def __init__(self, port: str, baudrate: int) -> None:
        """
        Initialize the console UI.
        
        Args:
            port: Serial port name.
            baudrate: Serial baudrate.
        """
        super().__init__()
        self.port: str = port
        self.baudrate: int = baudrate
        self.font_size: int = 10
        self.replay_mode: bool = False
        self.connected: bool = False
        
        # Statistics
        self.missed_logs: int = 0
        self.corrupted_logs: int = 0
        self.truncated_logs: int = 0
        self.total_logs: int = 0
        
        # Store all log messages with their category and module
        self.all_log_messages: list = []
        
        # Log filtering state
        self.log_filters: dict = {
            'error': True,
            'warn': True,
            'info': True,
            'detail': True,
            'silabs': True,
            'zigbee': True
        }
        
        # Module filtering state
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
        
        # Custom filter state
        self.custom_filter_enabled: bool = False
        self.custom_filter_pattern: str = ""
        
        # Signals
        self.signals: SignalEmitter = SignalEmitter()
        
        # Serial settings (defaults)
        self.stopbits: float = 1.0
        self.parity: str = 'N'
        self.flowcontrol: str = 'rtscts'
        
        # Callbacks (to be set by main application)
        self.on_connect_callback = None
        self.on_disconnect_callback = None
        self.on_send_command_callback = None
        self.on_settings_changed_callback = None
        self.on_port_changed_callback = None
        
        self.init_ui()
        self.setup_connections()
    
    def set_callbacks(
        self,
        on_connect,
        on_disconnect,
        on_send_command,
        on_settings_changed=None,
        on_port_changed=None,
    ) -> None:
        """
        Set callback functions for user actions.
        
        Args:
            on_connect: Callback for connect action.
            on_disconnect: Callback for disconnect action.
            on_send_command: Callback for sending commands.
            on_settings_changed: Callback for serial settings changes.
            on_port_changed: Callback invoked with a new port string when the
                user selects a port (e.g. from the port selection dialog).
        """
        self.on_connect_callback = on_connect
        self.on_disconnect_callback = on_disconnect
        self.on_send_command_callback = on_send_command
        self.on_settings_changed_callback = on_settings_changed
        self.on_port_changed_callback = on_port_changed
    
    def init_ui(self) -> None:
        """Initialize the Qt UI components."""
        self._update_window_title()
        self.setGeometry(100, 100, 1200, 800)
        
        # Central widget and layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        
        # Splitter for two terminals
        splitter = QSplitter(Qt.Vertical)
        
        # Log terminal (top)
        log_container = self._create_log_terminal()
        
        # Interactive terminal (bottom)
        interactive_container = self._create_interactive_terminal()
        
        # Add both containers to splitter
        splitter.addWidget(log_container)
        splitter.addWidget(interactive_container)
        splitter.setStretchFactor(0, 1)
        splitter.setStretchFactor(1, 1)
        
        layout.addWidget(splitter)
        
        # Status bar
        if self.port:
            self.statusBar().showMessage(f"Ready - Not Connected to {self.port}")
        else:
            self.statusBar().showMessage("Ready - No port selected. Click Connect to choose one.")
    
    def _update_window_title(self) -> None:
        """Refresh the main window title to reflect the current port."""
        if self.port:
            self.setWindowTitle(f"Silicon Labs Console - {self.port}")
        else:
            self.setWindowTitle("Silicon Labs Console")
    
    def _create_log_terminal(self) -> QWidget:
        """Create the log terminal widget."""
        log_container = QWidget()
        log_layout = QVBoxLayout(log_container)
        log_layout.setContentsMargins(0, 0, 0, 0)
        
        # Log terminal header
        log_header = self._create_log_header()
        log_layout.addWidget(log_header)
        
        # Log terminal text area
        self.log_terminal = QTextEdit()
        self.log_terminal.setReadOnly(True)
        self.log_terminal.setStyleSheet("""
            QTextEdit {
                background-color: #1e1e1e;
                color: #d4d4d4;
                font-family: 'Courier New', monospace;
            }
        """)
        self.log_terminal.setLineWrapMode(QTextEdit.WidgetWidth)
        self.update_log_font()
        log_layout.addWidget(self.log_terminal)
        
        return log_container
    
    def _create_log_header(self) -> QWidget:
        """Create the log terminal header with controls."""
        log_header = QWidget()
        log_header_layout = QHBoxLayout(log_header)
        log_header_layout.setContentsMargins(5, 5, 5, 5)
        
        log_label = QLabel("=== Log Terminal ===")
        log_label.setStyleSheet("color: white; font-weight: bold;")
        log_header_layout.addWidget(log_label)
        
        log_header_layout.addStretch()
        
        # Filter buttons
        self._add_filter_buttons(log_header_layout)
        
        # Separator
        separator = QLabel("|")
        separator.setStyleSheet("color: #555; margin: 0 5px;")
        log_header_layout.addWidget(separator)
        
        # Save/Load buttons
        self._add_save_load_buttons(log_header_layout)
        
        # Separator
        separator2 = QLabel("|")
        separator2.setStyleSheet("color: #555; margin: 0 5px;")
        log_header_layout.addWidget(separator2)
        
        # Font size controls
        self.log_minus_btn = self._create_font_button("-", self.decrease_font_size)
        log_header_layout.addWidget(self.log_minus_btn)
        
        self.log_plus_btn = self._create_font_button("+", self.increase_font_size)
        log_header_layout.addWidget(self.log_plus_btn)
        
        log_header.setStyleSheet("background-color: #2b2b2b;")
        return log_header
    
    def _add_filter_buttons(self, layout: QHBoxLayout) -> None:
        """Add filter buttons to the layout."""
        filter_label = QLabel("Filters:")
        filter_label.setStyleSheet("color: #999; font-size: 9pt; margin-right: 5px;")
        layout.addWidget(filter_label)
        
        # Filter configurations: (name, display_text, width, color)
        filters = [
            ('error', '[error]', 60, '#ff6464'),
            ('warn', '[warn]', 55, '#ffaa00'),
            ('info', '[info]', 50, '#d4d4d4'),
            ('detail', '[detail]', 60, '#aaaaaa'),
            ('silabs', '[silabs]', 60, '#6496ff'),
            ('zigbee', '[ZB]', 50, ZIGBEE_COLOR),
        ]
        
        self.filter_buttons = {}
        for name, text, width, color in filters:
            btn = QPushButton(text)
            btn.setCheckable(True)
            btn.setChecked(True)
            btn.setFixedSize(width, 25)
            btn.setStyleSheet(f"""
                QPushButton {{
                    background-color: #3c3c3c;
                    color: {color};
                    border: 1px solid #555;
                    font-size: 9pt;
                }}
                QPushButton:hover {{
                    background-color: #4c4c4c;
                }}
                QPushButton:checked {{
                    background-color: {color};
                    color: #1e1e1e;
                    border: 1px solid {color};
                }}
            """)
            btn.clicked.connect(lambda checked, n=name: self.toggle_filter(n))
            self.filter_buttons[name] = btn
            layout.addWidget(btn)
        
        # More Options button
        self.more_options_btn = QPushButton("More Options")
        self.more_options_btn.setFixedSize(95, 25)
        self.more_options_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #d4d4d4;
                border: 1px solid #555;
                font-size: 9pt;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.more_options_btn.clicked.connect(self.show_module_filter_dialog)
        layout.addWidget(self.more_options_btn)
        
        # Separator
        separator_custom = QLabel("|")
        separator_custom.setStyleSheet("color: #555; margin: 0 5px;")
        layout.addWidget(separator_custom)
        
        # Custom filter checkbox
        self.custom_filter_checkbox = QCheckBox("Custom:")
        self.custom_filter_checkbox.setChecked(False)
        self.custom_filter_checkbox.setStyleSheet("""
            QCheckBox {
                color: #d4d4d4;
                font-size: 9pt;
                spacing: 5px;
            }
            QCheckBox::indicator {
                width: 16px;
                height: 16px;
                border: 1px solid #555;
                background-color: #3c3c3c;
            }
            QCheckBox::indicator:checked {
                background-color: #4CAF50;
                border: 1px solid #4CAF50;
            }
        """)
        self.custom_filter_checkbox.stateChanged.connect(self.on_custom_filter_changed)
        layout.addWidget(self.custom_filter_checkbox)
        
        # Custom filter input
        self.custom_filter_input = QLineEdit()
        self.custom_filter_input.setPlaceholderText("Enter filter text...")
        self.custom_filter_input.setFixedWidth(200)
        self.custom_filter_input.setStyleSheet("""
            QLineEdit {
                background-color: #3c3c3c;
                color: #d4d4d4;
                border: 1px solid #555;
                padding: 3px 5px;
                font-size: 9pt;
            }
            QLineEdit:focus {
                border: 1px solid #4CAF50;
            }
        """)
        self.custom_filter_input.textChanged.connect(self.on_custom_filter_changed)
        layout.addWidget(self.custom_filter_input)
    
    def _add_save_load_buttons(self, layout: QHBoxLayout) -> None:
        """Add save/load buttons to the layout."""
        self.save_btn = QPushButton("Save")
        self.save_btn.setFixedSize(50, 25)
        self.save_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #4CAF50;
                border: 1px solid #555;
                font-size: 9pt;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.save_btn.clicked.connect(self.save_logs)
        layout.addWidget(self.save_btn)
        
        self.load_btn = QPushButton("Load")
        self.load_btn.setFixedSize(50, 25)
        self.load_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #2196F3;
                border: 1px solid #555;
                font-size: 9pt;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.load_btn.clicked.connect(self.load_logs)
        layout.addWidget(self.load_btn)
        
        self.close_replay_btn = QPushButton("Close")
        self.close_replay_btn.setFixedSize(50, 25)
        self.close_replay_btn.setStyleSheet("""
            QPushButton {
                background-color: #f44336;
                color: white;
                border: 1px solid #d32f2f;
                font-size: 9pt;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #d32f2f;
            }
        """)
        self.close_replay_btn.clicked.connect(self.close_replay_mode)
        self.close_replay_btn.hide()
        layout.addWidget(self.close_replay_btn)
    
    def _create_interactive_terminal(self) -> QWidget:
        """Create the interactive terminal widget."""
        interactive_container = QWidget()
        interactive_layout = QVBoxLayout(interactive_container)
        interactive_layout.setContentsMargins(0, 0, 0, 0)
        
        # Interactive terminal header
        interactive_header = self._create_interactive_header()
        interactive_layout.addWidget(interactive_header)
        
        # Interactive terminal text area
        self.interactive_terminal = QTextEdit()
        self.interactive_terminal.setReadOnly(True)
        self.interactive_terminal.setStyleSheet("""
            QTextEdit {
                background-color: #1e1e1e;
                color: #d4d4d4;
                font-family: 'Courier New', monospace;
            }
        """)
        self.interactive_terminal.setLineWrapMode(QTextEdit.WidgetWidth)
        self.update_interactive_font()
        interactive_layout.addWidget(self.interactive_terminal)
        
        # Command input
        self.command_input = QLineEdit()
        self.command_input.setPlaceholderText("[Not Connected - Click Connect to start]")
        self.command_input.setStyleSheet("""
            QLineEdit {
                background-color: #2b2b2b;
                color: white;
                padding: 5px;
                font-family: 'Courier New', monospace;
                border: 1px solid #555;
            }
        """)
        self.update_input_font()
        self.command_input.returnPressed.connect(self.send_command_from_input)
        self.command_input.setEnabled(False)
        interactive_layout.addWidget(self.command_input)
        
        return interactive_container
    
    def _create_interactive_header(self) -> QWidget:
        """Create the interactive terminal header with controls."""
        interactive_header = QWidget()
        interactive_header_layout = QHBoxLayout(interactive_header)
        interactive_header_layout.setContentsMargins(5, 5, 5, 5)
        
        interactive_label = QLabel("=== Interactive Terminal ===")
        interactive_label.setStyleSheet("color: white; font-weight: bold;")
        interactive_header_layout.addWidget(interactive_label)
        
        interactive_header_layout.addStretch()
        
        # Serial Settings button (gear icon)
        self.settings_btn = QPushButton("\u2699")
        self.settings_btn.setFixedSize(30, 25)
        self.settings_btn.setToolTip("Serial Communication Settings")
        self.settings_btn.setCursor(Qt.PointingHandCursor)
        self.settings_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #d4d4d4;
                border: 1px solid #555;
                font-size: 14pt;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
                color: #ffffff;
            }
        """)
        self.settings_btn.clicked.connect(self.show_serial_settings_dialog)
        interactive_header_layout.addWidget(self.settings_btn)
        
        # Connect/Disconnect button
        self.connect_btn = QPushButton("Connect")
        self.connect_btn.setFixedSize(75, 25)
        self.connect_btn.setStyleSheet("""
            QPushButton {
                background-color: #4CAF50;
                color: white;
                border: 1px solid #45a049;
                font-size: 9pt;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #45a049;
            }
        """)
        self.connect_btn.clicked.connect(self.toggle_connection)
        interactive_header_layout.addWidget(self.connect_btn)
        
        # Missed Logs label
        self.missed_logs_label = QPushButton("Missed Logs: 0")
        self.missed_logs_label.setFixedHeight(25)
        self.missed_logs_label.setCursor(Qt.PointingHandCursor)
        self.missed_logs_label.setStyleSheet("""
            QPushButton {
                color: #ffaa00;
                font-size: 9pt;
                font-weight: bold;
                padding: 0 10px;
                background-color: #3c3c3c;
                border: 1px solid #555;
                border-radius: 3px;
                text-align: left;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.missed_logs_label.clicked.connect(self.reset_missed_logs)
        interactive_header_layout.addWidget(self.missed_logs_label)
        
        # Stats button
        self.stats_btn = QPushButton("Stats")
        self.stats_btn.setFixedSize(60, 25)
        self.stats_btn.setCursor(Qt.PointingHandCursor)
        self.stats_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #4CAF50;
                border: 1px solid #555;
                font-size: 9pt;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.stats_btn.clicked.connect(self.show_stats_dialog)
        interactive_header_layout.addWidget(self.stats_btn)
        
        # Clear button
        self.clear_btn = QPushButton("Clear")
        self.clear_btn.setFixedSize(60, 25)
        self.clear_btn.setCursor(Qt.PointingHandCursor)
        self.clear_btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: #ff9800;
                border: 1px solid #555;
                font-size: 9pt;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        self.clear_btn.clicked.connect(self.clear_terminals)
        interactive_header_layout.addWidget(self.clear_btn)
        
        # Separator
        separator3 = QLabel("|")
        separator3.setStyleSheet("color: #555; margin: 0 5px;")
        interactive_header_layout.addWidget(separator3)
        
        # Font size controls
        self.interactive_minus_btn = self._create_font_button("-", self.decrease_font_size)
        interactive_header_layout.addWidget(self.interactive_minus_btn)
        
        self.interactive_plus_btn = self._create_font_button("+", self.increase_font_size)
        interactive_header_layout.addWidget(self.interactive_plus_btn)
        
        interactive_header.setStyleSheet("background-color: #2b2b2b;")
        return interactive_header
    
    def _create_font_button(self, text: str, callback) -> QPushButton:
        """Create a font size control button."""
        btn = QPushButton(text)
        btn.setFixedSize(30, 25)
        btn.setStyleSheet("""
            QPushButton {
                background-color: #3c3c3c;
                color: white;
                border: 1px solid #555;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        btn.clicked.connect(callback)
        return btn
    
    def setup_connections(self) -> None:
        """Setup Qt signal connections."""
        self.signals.log_message.connect(self.append_log_message)
        self.signals.interactive_message.connect(self.append_interactive_message)
        self.signals.error_message.connect(self.show_error)
        self.signals.missed_logs_increment.connect(self.increment_missed_logs)
        self.signals.corrupted_logs_increment.connect(self.increment_corrupted_logs)
        self.signals.truncated_logs_increment.connect(self.increment_truncated_logs)
        self.signals.total_logs_increment.connect(self.increment_total_logs)
    
    def append_log_message(self, message: str, category: str, module: Optional[str]) -> None:
        """
        Append message to log terminal with color formatting.
        
        Args:
            message: The log message to append.
            category: Message category ('error', 'warn', etc.).
            module: Message module or None.
        """
        self.all_log_messages.append((message, category, module))
        
        # Check if message should be displayed (custom filter bypasses category/module filters)
        if self.should_display_with_custom_filter(message, category, module):
            self.display_log_message(message, category)
    
    def display_log_message(self, message: str, category: str) -> None:
        """
        Display a single log message in the terminal.
        
        Args:
            message: The message to display.
            category: Message category for color formatting.
        """
        cursor = self.log_terminal.textCursor()
        cursor.movePosition(QTextCursor.End)
        
        # Determine color based on log category
        fmt = QTextCharFormat()
        if category == 'error':
            fmt.setForeground(QColor(255, 100, 100))
        elif category == 'warn':
            fmt.setForeground(QColor(255, 170, 0))
        elif category == 'silabs':
            fmt.setForeground(QColor(100, 150, 255))
        elif category == 'zigbee':
            fmt.setForeground(QColor(ZIGBEE_COLOR))
        elif category == 'detail':
            fmt.setForeground(QColor(170, 170, 170))
        else:
            fmt.setForeground(QColor(212, 212, 212))
        
        cursor.setCharFormat(fmt)
        cursor.insertText(message)
        
        self.log_terminal.setTextCursor(cursor)
        self.log_terminal.ensureCursorVisible()
    
    def append_interactive_message(self, message: str) -> None:
        """
        Append message to interactive terminal.
        
        Args:
            message: The message to append.
        """
        cursor = self.interactive_terminal.textCursor()
        cursor.movePosition(QTextCursor.End)
        cursor.insertText(message)
        
        self.interactive_terminal.setTextCursor(cursor)
        self.interactive_terminal.ensureCursorVisible()
    
    def show_error(self, error: str) -> None:
        """
        Show error in status bar.
        
        Args:
            error: Error message to display.
        """
        self.statusBar().showMessage(f"Error: {error}", 5000)
    
    def update_log_font(self) -> None:
        """Update log terminal font size."""
        font = QFont('Courier New', self.font_size)
        self.log_terminal.setFont(font)
    
    def update_interactive_font(self) -> None:
        """Update interactive terminal font size."""
        font = QFont('Courier New', self.font_size)
        self.interactive_terminal.setFont(font)
    
    def update_input_font(self) -> None:
        """Update command input font size."""
        font = QFont('Courier New', self.font_size)
        self.command_input.setFont(font)
    
    def increase_font_size(self) -> None:
        """Increase font size for all terminals."""
        if self.font_size < 24:
            self.font_size += 1
            self.update_log_font()
            self.update_interactive_font()
            self.update_input_font()
            self.statusBar().showMessage(f"Font size: {self.font_size}pt", 2000)
    
    def decrease_font_size(self) -> None:
        """Decrease font size for all terminals."""
        if self.font_size > 6:
            self.font_size -= 1
            self.update_log_font()
            self.update_interactive_font()
            self.update_input_font()
            self.statusBar().showMessage(f"Font size: {self.font_size}pt", 2000)
    
    def on_custom_filter_changed(self) -> None:
        """Handle changes to custom filter checkbox or input."""
        self.custom_filter_enabled = self.custom_filter_checkbox.isChecked()
        self.custom_filter_pattern = self.custom_filter_input.text().strip()
        self.refresh_log_display()
    
    def should_display_with_custom_filter(self, message: str, category: str, module: Optional[str]) -> bool:
        """
        Check if a message should be displayed considering custom filter priority.
        Custom filter, when active, bypasses category and module filters.
        
        Args:
            message: The message to check.
            category: Message category.
            module: Message module or None.
            
        Returns:
            True if message should be displayed, False otherwise.
        """
        # If custom filter is active (enabled and has text), it takes priority
        if self.custom_filter_enabled and self.custom_filter_pattern:
            return self.custom_filter_pattern.lower() in message.lower()
        
        # Otherwise, use normal category and module filtering
        category_enabled = self.log_filters.get(category, True)
        module_enabled = self.module_filters.get(module, True) if module else True
        return category_enabled and module_enabled
    
    def toggle_filter(self, category: str) -> None:
        """
        Toggle log filter for a specific category.
        
        Args:
            category: The category to toggle.
        """
        self.log_filters[category] = not self.log_filters[category]
        self.refresh_log_display()
        
        active_filters = [cat for cat, enabled in self.log_filters.items() if enabled]
        if active_filters:
            self.statusBar().showMessage(f"Active filters: {', '.join(active_filters)}", 2000)
        else:
            self.statusBar().showMessage("All filters disabled - no logs shown", 2000)
    
    def refresh_log_display(self) -> None:
        """Refresh the log display based on current filters."""
        self.log_terminal.clear()
        
        for message, category, module in self.all_log_messages:
            if self.should_display_with_custom_filter(message, category, module):
                self.display_log_message(message, category)
    
    def show_module_filter_dialog(self) -> None:
        """Show a dialog with module filter options."""
        dialog = ModuleFilterDialog(self.module_filters, self)
        if dialog.exec_() == QDialog.Accepted:
            self.module_filters = dialog.get_filters()
            self.refresh_log_display()
            
            active_modules = [mod for mod, enabled in self.module_filters.items() if enabled]
            if len(active_modules) == len(self.module_filters):
                self.statusBar().showMessage("All module filters enabled", 2000)
            else:
                self.statusBar().showMessage(f"Active module filters: {', '.join(active_modules)}", 2000)
    
    def save_logs(self) -> None:
        """Save logs and interactive terminal content to timestamped files."""
        try:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            
            log_filename = f"silabs_logs_{timestamp}.txt"
            with open(log_filename, 'w', encoding='utf-8') as f:
                for message, category, module in self.all_log_messages:
                    f.write(message)
            
            interactive_filename = f"silabs_interactive_{timestamp}.txt"
            interactive_content = self.interactive_terminal.toPlainText()
            with open(interactive_filename, 'w', encoding='utf-8') as f:
                f.write(interactive_content)
            
            self.statusBar().showMessage(
                f"Saved: {log_filename} and {interactive_filename}", 5000
            )
        except (OSError, IOError) as e:
            self.signals.error_message.emit(f"Error saving logs: {e}")
    
    def load_logs(self) -> None:
        """Load a saved log file and enter replay mode."""
        try:
            filename, _ = QFileDialog.getOpenFileName(
                self,
                "Load Log File",
                "",
                "Text Files (*.txt);;All Files (*)"
            )
            
            if not filename:
                return
            
            # Trigger disconnect if connected
            if self.connected and self.on_disconnect_callback:
                self.on_disconnect_callback()
            
            self.enter_replay_mode(filename)
            
        except (OSError, IOError) as e:
            self.signals.error_message.emit(f"Error loading logs: {e}")
    
    def enter_replay_mode(self, filename: str) -> None:
        """
        Enter replay mode with a loaded log file.
        
        Args:
            filename: Path to the log file to load.
        """
        from console_log_parser import LogParser
        
        self.replay_mode = True
        self.all_log_messages = []
        self.log_terminal.clear()
        
        parser = LogParser()
        
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
            for line in content.split('\n'):
                if line.strip():
                    category = parser.get_message_category(line)
                    module = parser.get_message_module(line)
                    self.all_log_messages.append((line + '\n', category, module))
        
        self.refresh_log_display()
        
        # Update UI for replay mode
        self.command_input.setEnabled(False)
        self.command_input.setPlaceholderText("[Replay Mode - Input Disabled]")
        self.save_btn.setEnabled(False)
        self.load_btn.setEnabled(False)
        self.connect_btn.setEnabled(False)
        self.close_replay_btn.show()
        
        self.statusBar().showMessage(
            f"Loaded: {filename} (Replay Mode - Read Only)", 5000
        )
    
    def close_replay_mode(self) -> None:
        """Exit replay mode and return to live mode."""
        try:
            self.all_log_messages = []
            self.log_terminal.clear()
            self.interactive_terminal.clear()
            
            self.replay_mode = False
            
            self.save_btn.setEnabled(True)
            self.load_btn.setEnabled(True)
            self.close_replay_btn.hide()
            
            self.connect_btn.setEnabled(True)
            self.command_input.setEnabled(False)
            self.command_input.setPlaceholderText("[Not Connected - Click Connect to start]")
            
            self.statusBar().showMessage("Exited replay mode - Click Connect to resume live monitoring", 3000)
        except (RuntimeError, AttributeError) as e:
            self.signals.error_message.emit(f"Error closing replay mode: {e}")
    
    def update_missed_logs_label(self) -> None:
        """Update the missed logs label with current count."""
        self.missed_logs_label.setText(f"Missed Logs: {self.missed_logs}")
        if self.missed_logs > 0:
            self.missed_logs_label.setStyleSheet("""
                QPushButton {
                    color: #ff6464;
                    font-size: 9pt;
                    font-weight: bold;
                    padding: 0 10px;
                    background-color: #3c3c3c;
                    border: 1px solid #ff6464;
                    border-radius: 3px;
                    text-align: left;
                }
                QPushButton:hover {
                    background-color: #4c4c4c;
                }
            """)
        else:
            self.missed_logs_label.setStyleSheet("""
                QPushButton {
                    color: #ffaa00;
                    font-size: 9pt;
                    font-weight: bold;
                    padding: 0 10px;
                    background-color: #3c3c3c;
                    border: 1px solid #555;
                    border-radius: 3px;
                    text-align: left;
                }
                QPushButton:hover {
                    background-color: #4c4c4c;
                }
            """)
    
    def increment_missed_logs(self, count: int) -> None:
        """
        Increment missed logs counter.
        
        Args:
            count: Number to increment by.
        """
        self.missed_logs += count
        self.update_missed_logs_label()
    
    def reset_missed_logs(self) -> None:
        """Reset missed logs counter to zero."""
        self.missed_logs = 0
        self.update_missed_logs_label()
        self.statusBar().showMessage("Missed logs counter reset", 2000)
    
    def clear_terminals(self) -> None:
        """Clear both log and interactive terminal windows."""
        self.log_terminal.clear()
        self.interactive_terminal.clear()
        self.all_log_messages.clear()
        self.statusBar().showMessage("Terminals cleared", 2000)
    
    def increment_corrupted_logs(self) -> None:
        """Increment corrupted logs counter."""
        self.corrupted_logs += 1
    
    def increment_truncated_logs(self) -> None:
        """Increment truncated logs counter."""
        self.truncated_logs += 1
    
    def increment_total_logs(self) -> None:
        """Increment total logs counter."""
        self.total_logs += 1
    
    def show_stats_dialog(self) -> None:
        """Show the statistics dialog."""
        dialog = StatsDialog(self)
        dialog.exec_()
    
    def show_serial_settings_dialog(self) -> None:
        """Show the serial communication settings dialog."""
        dialog = SerialSettingsDialog(
            baudrate=self.baudrate,
            stopbits=self.stopbits,
            parity=self.parity,
            flowcontrol=self.flowcontrol,
            parent=self
        )
        if dialog.exec_() == QDialog.Accepted:
            settings = dialog.get_settings()
            self.baudrate = settings['baudrate']
            self.stopbits = settings['stopbits']
            self.parity = settings['parity']
            self.flowcontrol = settings['flowcontrol']
            
            if self.on_settings_changed_callback:
                self.on_settings_changed_callback(
                    settings['baudrate'],
                    settings['stopbits'],
                    settings['parity'],
                    settings['flowcontrol']
                )
            
            self.statusBar().showMessage(
                f"Serial settings updated: {settings['baudrate']} baud", 3000
            )
    
    def toggle_connection(self) -> None:
        """Toggle serial connection on/off."""
        if self.connected:
            if self.on_disconnect_callback:
                self.on_disconnect_callback()
            return
        
        # If no port is set yet, prompt the user to pick one.
        if not self.port:
            if not self.prompt_for_serial_port():
                return
        
        if self.on_connect_callback:
            self.on_connect_callback()
    
    def prompt_for_serial_port(self) -> bool:
        """
        Show a dialog letting the user pick a serial port from /dev/.
        
        Returns:
            True if the user accepted a selection (and the port was updated),
            False if the dialog was cancelled or no ports were available.
        """
        available_ports = find_available_serial_ports()
        
        if not available_ports:
            QMessageBox.warning(
                self,
                "No Serial Ports Found",
                "No serial ports were found under /dev/ matching "
                "'cu.*', 'tty.usb*' or 'ttyACM*'.\n\n"
                "Plug in a device and try again, or pass the port path on the "
                "command line.",
            )
            return False
        
        dialog = PortSelectionDialog(available_ports, self)
        if dialog.exec_() != QDialog.Accepted:
            return False
        
        selected = dialog.get_selected_port()
        if not selected:
            return False
        
        self.port = selected
        self._update_window_title()
        
        if self.on_port_changed_callback:
            self.on_port_changed_callback(selected)
        
        self.statusBar().showMessage(f"Selected port: {selected}", 3000)
        return True
    
    def set_connected_state(self, connected: bool) -> None:
        """
        Update UI to reflect connection state.
        
        Args:
            connected: True if connected, False otherwise.
        """
        self.connected = connected
        
        if connected:
            self.command_input.setEnabled(True)
            self.command_input.setPlaceholderText("Type command and press Enter...")
            self.connect_btn.setText("Disconnect")
            self.connect_btn.setStyleSheet("""
                QPushButton {
                    background-color: #f44336;
                    color: white;
                    border: 1px solid #d32f2f;
                    font-size: 9pt;
                    font-weight: bold;
                }
                QPushButton:hover {
                    background-color: #d32f2f;
                }
            """)
            self.statusBar().showMessage(f"Connected to {self.port} at {self.baudrate} baud", 3000)
        else:
            self.command_input.setEnabled(False)
            self.command_input.setPlaceholderText("[Not Connected - Click Connect to start]")
            self.command_input.clear()
            self.connect_btn.setText("Connect")
            self.connect_btn.setStyleSheet("""
                QPushButton {
                    background-color: #4CAF50;
                    color: white;
                    border: 1px solid #45a049;
                    font-size: 9pt;
                    font-weight: bold;
                }
                QPushButton:hover {
                    background-color: #45a049;
                }
            """)
            self.statusBar().showMessage("Disconnected from serial port", 3000)
    
    def send_command_from_input(self) -> None:
        """Send command from input field."""
        command = self.command_input.text().strip()
        if command and self.on_send_command_callback:
            self.on_send_command_callback(command)
            self.command_input.clear()


class StatsDialog(QDialog):
    """Dialog for displaying real-time console statistics."""
    
    def __init__(self, parent: Optional[ConsoleUI] = None) -> None:
        """
        Initialize the stats dialog.
        
        Args:
            parent: Parent ConsoleUI instance.
        """
        super().__init__(parent)
        self.console: Optional[ConsoleUI] = parent
        self.init_ui()
        
        self.update_timer: QTimer = QTimer()
        self.update_timer.timeout.connect(self.update_stats)
        self.update_timer.start(100)
    
    def init_ui(self) -> None:
        """Initialize the dialog UI."""
        self.setWindowTitle("Console Statistics")
        self.setModal(False)
        self.setMinimumWidth(400)
        
        layout = QVBoxLayout(self)
        
        title = QLabel("Console Statistics")
        title.setStyleSheet("font-weight: bold; font-size: 12pt; margin-bottom: 15px;")
        layout.addWidget(title)
        
        stats_container = QWidget()
        stats_layout = QVBoxLayout(stats_container)
        stats_layout.setSpacing(10)
        
        self.missed_logs_stat = self.create_stat_label(
            "Missed Logs:",
            "Missed Logs on the device because of the UART queue being full"
        )
        stats_layout.addWidget(self.missed_logs_stat)
        
        self.corrupted_logs_stat = self.create_stat_label(
            "Corrupted Logs:",
            "Logs that the Silabs Matter Console failed to received properly"
        )
        stats_layout.addWidget(self.corrupted_logs_stat)
        
        self.truncated_logs_stat = self.create_stat_label(
            "Logs Truncated:",
            "Number of Logs generated by the application that exceeded the size configured in the UART.cpp file"
        )
        stats_layout.addWidget(self.truncated_logs_stat)
        
        self.total_logs_stat = self.create_stat_label(
            "Total Logs Received:",
            "Total Logs Received"
        )
        stats_layout.addWidget(self.total_logs_stat)
        
        layout.addWidget(stats_container)
        
        separator = QLabel()
        separator.setStyleSheet("background-color: #555; min-height: 1px; max-height: 1px; margin: 10px 0;")
        layout.addWidget(separator)
        
        close_btn = QPushButton("Close")
        close_btn.clicked.connect(self.accept)
        close_btn.setDefault(True)
        close_btn.setStyleSheet("""
            QPushButton {
                padding: 8px 30px;
                background-color: #0066cc;
                color: white;
                border: 1px solid #0066cc;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #0077dd;
            }
        """)
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        button_layout.addWidget(close_btn)
        layout.addLayout(button_layout)
        
        self.setStyleSheet("""
            QDialog {
                background-color: #2b2b2b;
                color: white;
            }
            QLabel {
                color: white;
            }
        """)
        
        self.update_stats()
    
    def create_stat_label(self, label_text: str, tooltip_text: str) -> QWidget:
        """
        Create a stat label with hover tooltip.
        
        Args:
            label_text: Label text to display.
            tooltip_text: Tooltip text.
            
        Returns:
            Widget containing the stat label.
        """
        container = QWidget()
        container.setToolTip(tooltip_text)
        container_layout = QHBoxLayout(container)
        container_layout.setContentsMargins(10, 5, 10, 5)
        
        label = QLabel(label_text)
        label.setStyleSheet("font-size: 11pt; font-weight: bold; color: #d4d4d4;")
        container_layout.addWidget(label)
        
        container_layout.addStretch()
        
        value = QLabel("0")
        value.setObjectName("value_label")
        value.setStyleSheet("font-size: 11pt; color: #4CAF50; font-weight: bold;")
        container_layout.addWidget(value)
        
        container.setStyleSheet("""
            QWidget {
                background-color: #3c3c3c;
                border: 1px solid #555;
                border-radius: 5px;
            }
            QWidget:hover {
                background-color: #4c4c4c;
                border: 1px solid #0066cc;
            }
            QLabel {
                background-color: transparent;
                border: none;
            }
        """)
        
        return container
    
    def update_stats(self) -> None:
        """Update all statistics from console."""
        if not self.console:
            return
        
        value_label = self.missed_logs_stat.findChild(QLabel, "value_label")
        if value_label:
            value_label.setText(str(self.console.missed_logs))
        
        value_label = self.corrupted_logs_stat.findChild(QLabel, "value_label")
        if value_label:
            value_label.setText(str(self.console.corrupted_logs))
            if self.console.corrupted_logs > 0:
                value_label.setStyleSheet("font-size: 11pt; color: #ff6464; font-weight: bold;")
            else:
                value_label.setStyleSheet("font-size: 11pt; color: #4CAF50; font-weight: bold;")
        
        value_label = self.truncated_logs_stat.findChild(QLabel, "value_label")
        if value_label:
            value_label.setText(str(self.console.truncated_logs))
            if self.console.truncated_logs > 0:
                value_label.setStyleSheet("font-size: 11pt; color: #ffaa00; font-weight: bold;")
            else:
                value_label.setStyleSheet("font-size: 11pt; color: #4CAF50; font-weight: bold;")
        
        value_label = self.total_logs_stat.findChild(QLabel, "value_label")
        if value_label:
            value_label.setText(str(self.console.total_logs))
    
    def closeEvent(self, event) -> None:
        """Stop timer when dialog closes."""
        self.update_timer.stop()
        event.accept()


class ModuleFilterDialog(QDialog):
    """Dialog for advanced module filtering options."""
    
    def __init__(self, current_filters: dict, parent: Optional[QWidget] = None) -> None:
        """
        Initialize the module filter dialog.
        
        Args:
            current_filters: Current module filter state.
            parent: Parent widget.
        """
        super().__init__(parent)
        self.current_filters: dict = current_filters.copy()
        self.init_ui()
    
    def init_ui(self) -> None:
        """Initialize the dialog UI."""
        self.setWindowTitle("Module Filters")
        self.setModal(True)
        self.setMinimumWidth(300)
        
        layout = QVBoxLayout(self)
        
        title = QLabel("Select modules to display:")
        title.setStyleSheet("font-weight: bold; font-size: 11pt; margin-bottom: 10px;")
        layout.addWidget(title)
        
        self.checkboxes = {}
        
        modules = [
            ('zcl', 'Data Model'),
            ('dl', 'Device Layer'),
            ('im', 'Interaction Model'),
            ('ot', 'Open Thread'),
            ('svr', 'App Server'),
            ('dis', 'Discovery'),
            ('swu', 'Software Updates'),
            ('tst', 'Test')
        ]
        
        for module_key, display_name in modules:
            checkbox = QCheckBox(display_name)
            checkbox.setChecked(self.current_filters.get(module_key, True))
            checkbox.setStyleSheet("QCheckBox { padding: 5px; font-size: 10pt; }")
            self.checkboxes[module_key] = checkbox
            layout.addWidget(checkbox)
        
        button_layout = QHBoxLayout()
        
        select_all_btn = QPushButton("Select All")
        select_all_btn.clicked.connect(self.select_all)
        select_all_btn.setStyleSheet("""
            QPushButton {
                padding: 5px 15px;
                background-color: #3c3c3c;
                color: white;
                border: 1px solid #555;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        button_layout.addWidget(select_all_btn)
        
        deselect_all_btn = QPushButton("Deselect All")
        deselect_all_btn.clicked.connect(self.deselect_all)
        deselect_all_btn.setStyleSheet("""
            QPushButton {
                padding: 5px 15px;
                background-color: #3c3c3c;
                color: white;
                border: 1px solid #555;
            }
            QPushButton:hover {
                background-color: #4c4c4c;
            }
        """)
        button_layout.addWidget(deselect_all_btn)
        
        layout.addLayout(button_layout)
        
        ok_cancel_layout = QHBoxLayout()
        ok_cancel_layout.addStretch()
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.clicked.connect(self.reject)
        cancel_btn.setStyleSheet("""
            QPushButton {
                padding: 5px 20px;
                background-color: #555;
                color: white;
                border: 1px solid #666;
            }
            QPushButton:hover {
                background-color: #666;
            }
        """)
        ok_cancel_layout.addWidget(cancel_btn)
        
        ok_btn = QPushButton("Apply")
        ok_btn.clicked.connect(self.accept)
        ok_btn.setDefault(True)
        ok_btn.setStyleSheet("""
            QPushButton {
                padding: 5px 20px;
                background-color: #0066cc;
                color: white;
                border: 1px solid #0066cc;
            }
            QPushButton:hover {
                background-color: #0077dd;
            }
        """)
        ok_cancel_layout.addWidget(ok_btn)
        
        layout.addLayout(ok_cancel_layout)
        
        self.setStyleSheet("""
            QDialog {
                background-color: #2b2b2b;
                color: white;
            }
            QLabel {
                color: white;
            }
            QCheckBox {
                color: white;
            }
            QCheckBox::indicator {
                width: 18px;
                height: 18px;
                border: 1px solid #555;
                background-color: #1e1e1e;
            }
            QCheckBox::indicator:checked {
                background-color: #0066cc;
                border: 1px solid #0066cc;
            }
            QCheckBox::indicator:hover {
                border: 1px solid #0077dd;
            }
        """)
    
    def select_all(self) -> None:
        """Select all module filters."""
        for checkbox in self.checkboxes.values():
            checkbox.setChecked(True)
    
    def deselect_all(self) -> None:
        """Deselect all module filters."""
        for checkbox in self.checkboxes.values():
            checkbox.setChecked(False)
    
    def get_filters(self) -> dict:
        """
        Get the current filter state.
        
        Returns:
            Dictionary mapping module names to enabled state.
        """
        return {key: checkbox.isChecked() for key, checkbox in self.checkboxes.items()}


class SerialSettingsDialog(QDialog):
    """Dialog for editing serial communication settings."""
    
    BAUDRATES = [300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600]
    STOPBITS_OPTIONS = [('1', 1.0), ('1.5', 1.5), ('2', 2.0)]
    PARITY_OPTIONS = [('None', 'N'), ('Even', 'E'), ('Odd', 'O'), ('Mark', 'M'), ('Space', 'S')]
    FLOWCONTROL_OPTIONS = [
        ('None', 'none'),
        ('RTS/CTS (Hardware)', 'rtscts'),
        ('DSR/DTR (Hardware)', 'dsrdtr'),
        ('XON/XOFF (Software)', 'xonxoff')
    ]
    
    def __init__(
        self,
        baudrate: int = 115200,
        stopbits: float = 1.0,
        parity: str = 'N',
        flowcontrol: str = 'rtscts',
        parent: Optional[QWidget] = None
    ) -> None:
        """
        Initialize the serial settings dialog.
        
        Args:
            baudrate: Current baudrate.
            stopbits: Current stop bits setting.
            parity: Current parity setting.
            flowcontrol: Current flow control setting.
            parent: Parent widget.
        """
        super().__init__(parent)
        self.current_baudrate = baudrate
        self.current_stopbits = stopbits
        self.current_parity = parity
        self.current_flowcontrol = flowcontrol
        self.init_ui()
    
    def init_ui(self) -> None:
        """Initialize the dialog UI."""
        self.setWindowTitle("Serial Communication Settings")
        self.setModal(True)
        self.setMinimumWidth(350)
        
        layout = QVBoxLayout(self)
        
        title = QLabel("Serial Port Configuration")
        title.setStyleSheet("font-weight: bold; font-size: 12pt; margin-bottom: 15px;")
        layout.addWidget(title)
        
        form_layout = QFormLayout()
        form_layout.setSpacing(15)
        
        self.baudrate_combo = QComboBox()
        for rate in self.BAUDRATES:
            self.baudrate_combo.addItem(str(rate), rate)
        current_idx = self.baudrate_combo.findData(self.current_baudrate)
        if current_idx >= 0:
            self.baudrate_combo.setCurrentIndex(current_idx)
        self._style_combo(self.baudrate_combo)
        form_layout.addRow("Baudrate:", self.baudrate_combo)
        
        self.stopbits_combo = QComboBox()
        for display, value in self.STOPBITS_OPTIONS:
            self.stopbits_combo.addItem(display, value)
        current_idx = self.stopbits_combo.findData(self.current_stopbits)
        if current_idx >= 0:
            self.stopbits_combo.setCurrentIndex(current_idx)
        self._style_combo(self.stopbits_combo)
        form_layout.addRow("Stop Bits:", self.stopbits_combo)
        
        self.parity_combo = QComboBox()
        for display, value in self.PARITY_OPTIONS:
            self.parity_combo.addItem(display, value)
        current_idx = self.parity_combo.findData(self.current_parity)
        if current_idx >= 0:
            self.parity_combo.setCurrentIndex(current_idx)
        self._style_combo(self.parity_combo)
        form_layout.addRow("Parity:", self.parity_combo)
        
        self.flowcontrol_combo = QComboBox()
        for display, value in self.FLOWCONTROL_OPTIONS:
            self.flowcontrol_combo.addItem(display, value)
        current_idx = self.flowcontrol_combo.findData(self.current_flowcontrol)
        if current_idx >= 0:
            self.flowcontrol_combo.setCurrentIndex(current_idx)
        self._style_combo(self.flowcontrol_combo)
        form_layout.addRow("Flow Control:", self.flowcontrol_combo)
        
        layout.addLayout(form_layout)
        
        separator = QLabel()
        separator.setStyleSheet("background-color: #555; min-height: 1px; max-height: 1px; margin: 15px 0;")
        layout.addWidget(separator)
        
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.clicked.connect(self.reject)
        cancel_btn.setStyleSheet("""
            QPushButton {
                padding: 8px 25px;
                background-color: #555;
                color: white;
                border: 1px solid #666;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #666;
            }
        """)
        button_layout.addWidget(cancel_btn)
        
        apply_btn = QPushButton("Apply")
        apply_btn.clicked.connect(self.accept)
        apply_btn.setDefault(True)
        apply_btn.setStyleSheet("""
            QPushButton {
                padding: 8px 25px;
                background-color: #0066cc;
                color: white;
                border: 1px solid #0066cc;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #0077dd;
            }
        """)
        button_layout.addWidget(apply_btn)
        
        layout.addLayout(button_layout)
        
        self.setStyleSheet("""
            QDialog {
                background-color: #2b2b2b;
                color: white;
            }
            QLabel {
                color: white;
                font-size: 10pt;
            }
        """)
    
    def _style_combo(self, combo: QComboBox) -> None:
        """Apply consistent styling to a combo box."""
        combo.setStyleSheet("""
            QComboBox {
                background-color: #3c3c3c;
                color: white;
                border: 1px solid #555;
                padding: 5px 10px;
                min-width: 150px;
                font-size: 10pt;
            }
            QComboBox:hover {
                border: 1px solid #0066cc;
            }
            QComboBox::drop-down {
                border: none;
                width: 25px;
            }
            QComboBox::down-arrow {
                image: none;
                border-left: 5px solid transparent;
                border-right: 5px solid transparent;
                border-top: 6px solid #d4d4d4;
                margin-right: 8px;
            }
            QComboBox QAbstractItemView {
                background-color: #3c3c3c;
                color: white;
                selection-background-color: #0066cc;
                border: 1px solid #555;
            }
        """)
    
    def get_settings(self) -> dict:
        """
        Get the current settings from the dialog.
        
        Returns:
            Dictionary with baudrate, stopbits, parity, and flowcontrol values.
        """
        return {
            'baudrate': self.baudrate_combo.currentData(),
            'stopbits': self.stopbits_combo.currentData(),
            'parity': self.parity_combo.currentData(),
            'flowcontrol': self.flowcontrol_combo.currentData()
        }


class PortSelectionDialog(QDialog):
    """Dialog for picking a serial port from the list of plausible /dev/ entries."""
    
    def __init__(self, ports: List[str], parent: Optional[QWidget] = None) -> None:
        """
        Initialize the port selection dialog.
        
        Args:
            ports: Available serial port paths to offer in the combo box.
            parent: Parent widget.
        """
        super().__init__(parent)
        self._ports: List[str] = list(ports)
        self.init_ui()
    
    def init_ui(self) -> None:
        """Initialize the dialog UI."""
        self.setWindowTitle("Select Serial Port")
        self.setModal(True)
        self.setMinimumWidth(420)
        
        layout = QVBoxLayout(self)
        
        title = QLabel("Select a serial port to connect to:")
        title.setStyleSheet("font-weight: bold; font-size: 11pt; margin-bottom: 10px;")
        layout.addWidget(title)
        
        hint = QLabel(
            "Showing devices under /dev/ matching cu.*, tty.usb*, or ttyACM*."
        )
        hint.setStyleSheet("color: #aaaaaa; font-size: 9pt; margin-bottom: 10px;")
        hint.setWordWrap(True)
        layout.addWidget(hint)
        
        self.port_combo = QComboBox()
        for port in self._ports:
            self.port_combo.addItem(port, port)
        self.port_combo.setStyleSheet("""
            QComboBox {
                background-color: #3c3c3c;
                color: white;
                border: 1px solid #555;
                padding: 5px 10px;
                min-width: 300px;
                font-size: 10pt;
            }
            QComboBox:hover {
                border: 1px solid #0066cc;
            }
            QComboBox::drop-down {
                border: none;
                width: 25px;
            }
            QComboBox::down-arrow {
                image: none;
                border-left: 5px solid transparent;
                border-right: 5px solid transparent;
                border-top: 6px solid #d4d4d4;
                margin-right: 8px;
            }
            QComboBox QAbstractItemView {
                background-color: #3c3c3c;
                color: white;
                selection-background-color: #0066cc;
                border: 1px solid #555;
            }
        """)
        layout.addWidget(self.port_combo)
        
        separator = QLabel()
        separator.setStyleSheet("background-color: #555; min-height: 1px; max-height: 1px; margin: 15px 0;")
        layout.addWidget(separator)
        
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.clicked.connect(self.reject)
        cancel_btn.setStyleSheet("""
            QPushButton {
                padding: 6px 20px;
                background-color: #555;
                color: white;
                border: 1px solid #666;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #666;
            }
        """)
        button_layout.addWidget(cancel_btn)
        
        ok_btn = QPushButton("Connect")
        ok_btn.clicked.connect(self.accept)
        ok_btn.setDefault(True)
        ok_btn.setStyleSheet("""
            QPushButton {
                padding: 6px 20px;
                background-color: #0066cc;
                color: white;
                border: 1px solid #0066cc;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #0077dd;
            }
        """)
        button_layout.addWidget(ok_btn)
        
        layout.addLayout(button_layout)
        
        self.setStyleSheet("""
            QDialog {
                background-color: #2b2b2b;
                color: white;
            }
            QLabel {
                color: white;
            }
        """)
    
    def get_selected_port(self) -> str:
        """
        Return the port chosen by the user.
        
        Returns:
            The selected port path, or an empty string if none is selected.
        """
        data = self.port_combo.currentData()
        return data if data else ""
