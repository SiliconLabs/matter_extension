#!/usr/bin/env python3
"""
Console UI - Qt-based user interface components.

This module contains all Qt UI components for the Silicon Labs Matter Console
application, including the main window, dialogs, and widgets.
"""

from datetime import datetime
from typing import Optional

from PyQt5.QtCore import QObject, QTimer, Qt, pyqtSignal
from PyQt5.QtGui import QColor, QFont, QTextCharFormat, QTextCursor
from PyQt5.QtWidgets import (
    QCheckBox,
    QDialog,
    QFileDialog,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMainWindow,
    QPushButton,
    QSplitter,
    QTextEdit,
    QVBoxLayout,
    QWidget,
)


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
            'silabs': True
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
        
        # Signals
        self.signals: SignalEmitter = SignalEmitter()
        
        # Callbacks (to be set by main application)
        self.on_connect_callback = None
        self.on_disconnect_callback = None
        self.on_send_command_callback = None
        
        self.init_ui()
        self.setup_connections()
    
    def set_callbacks(self, on_connect, on_disconnect, on_send_command) -> None:
        """
        Set callback functions for user actions.
        
        Args:
            on_connect: Callback for connect action.
            on_disconnect: Callback for disconnect action.
            on_send_command: Callback for sending commands.
        """
        self.on_connect_callback = on_connect
        self.on_disconnect_callback = on_disconnect
        self.on_send_command_callback = on_send_command
    
    def init_ui(self) -> None:
        """Initialize the Qt UI components."""
        self.setWindowTitle(f"Silicon Labs Console - {self.port}")
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
        self.statusBar().showMessage(f"Ready - Not Connected to {self.port}")
    
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
        
        # Only display if both category and module filters are enabled
        category_enabled = self.log_filters.get(category, True)
        module_enabled = self.module_filters.get(module, True) if module else True
        
        if category_enabled and module_enabled:
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
            category_enabled = self.log_filters.get(category, True)
            module_enabled = self.module_filters.get(module, True) if module else True
            
            if category_enabled and module_enabled:
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
    
    def toggle_connection(self) -> None:
        """Toggle serial connection on/off."""
        if self.connected:
            if self.on_disconnect_callback:
                self.on_disconnect_callback()
        else:
            if self.on_connect_callback:
                self.on_connect_callback()
    
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
