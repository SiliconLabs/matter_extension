# Silicon Labs Matter Console

A feature-rich Qt-based dual-terminal interface for monitoring and interacting with Silicon Labs devices over serial connections. Designed specifically for Matter development with advanced log filtering, real-time statistics, and session management capabilities.

## Architecture

The console is built with a modular architecture for maintainability and extensibility:

- **silabs_console.py**: Main application entry point and serial communication handler
- **console_ui.py**: Qt-based user interface components and widgets
- **console_log_parser.py**: Message parsing, filtering, and categorization logic

## Features

### Dual Terminal Interface
- **Log Terminal**: Displays framed log messages (SOF 0x01 ... EOF 0x04) with color-coded severity levels
- **Interactive Terminal**: Shows unframed messages and command responses

### Advanced Filtering
- **Log Level Filters**: `[error]`, `[warn]`, `[info]`, `[detail]`, `[silabs]`
- **Module Filters**: Filter by component (Data Model, Device Layer, Interaction Model, OpenThread, etc.)
- **Real-time Toggle**: Enable/disable filters on the fly without losing logged data

### Session Management
- **Save Logs**: Export both terminals to timestamped `.txt` files
- **Load Logs**: Review saved sessions in read-only replay mode
- **Replay Mode**: Analyze past sessions with full filter support

### Real-time Statistics
- **Missed Logs Counter**: Track logs missed on device due to UART queue overflow
- **Stats Button**: View comprehensive statistics including:
  - Missed Logs (device-side buffer full)
  - Corrupted Logs (console reception errors)
  - Logs Truncated (messages exceeding UART buffer size)
  - Total Logs Received
- **Clickable Reset**: Reset missed logs counter with a single click

### Connection Control
- **Manual Connect**: Launch without device connected - perfect for reviewing logs
- **Connect/Disconnect**: Toggle serial connection on demand
- **Hardware Flow Control**: RTS/CTS and DSR/DTR enabled by default

### UI Customization
- **Font Size Control**: Adjust text size for both terminals
- **Resizable Windows**: Split view with adjustable pane sizes
- **Dark Theme**: Easy-on-the-eyes color scheme optimized for long sessions

## Requirements

- Python 3.6+
- PyQt5
- pyserial

## Installation

1. Install the required Python packages:
```bash
pip install -r requirements.txt
```

Or manually:
```bash
pip install PyQt5>=5.15.0 pyserial>=3.5
```

2. Make the script executable (Linux/macOS):
```bash
chmod +x silabs_console.py
```

## Usage

### Basic Usage

```bash
./silabs_console.py /dev/ttyACM0
```

Or on Windows:
```bash
python silabs_console.py COM3
```

### Custom Baudrate

```bash
./silabs_console.py /dev/ttyACM0 -b 921600
```

### Command-Line Options

```
positional arguments:
  port                  Serial port to connect to (e.g., /dev/ttyACM0 or COM3)

optional arguments:
  -h, --help            show this help message and exit
  -b BAUDRATE, --baudrate BAUDRATE
                        Baudrate for serial communication (default: 115200)
```

## User Interface Guide

### Log Terminal (Top)
The log terminal displays framed messages with color-coded categories:
- **Red**: `[error]` messages
- **Orange**: `[warn]` messages  
- **Blue**: `[silabs]` messages
- **White**: `[info]` messages
- **Gray**: `[detail]` messages

### Interactive Terminal (Bottom)
Shows unframed messages and command responses. Use the input field to send commands to the device.

Note: Messages matching the pattern `Missed Logs: X` are automatically captured and counted, not displayed in the terminal.

### Controls

#### Filter Buttons
- Click any filter button (`[error]`, `[warn]`, etc.) to toggle that log level
- Checked = visible, Unchecked = hidden
- **More Options**: Opens advanced module filtering dialog

#### Module Filtering
Click "More Options" to filter by module:
- **Data Model** (`[ZCL]`)
- **Device Layer** (`[DL]`)
- **Interaction Model** (`[IM]`)
- **OpenThread** (`[ot]`)
- **App Server** (`[SVR]`)
- **Discovery** (`[DIS]`)
- **Software Updates** (`[SWU]`)
- **Test** (`[TST]`)

#### Save/Load Buttons
- **Save**: Creates two timestamped files:
  - `silabs_logs_YYYYMMDD_HHMMSS.txt` - Log terminal content
  - `silabs_interactive_YYYYMMDD_HHMMSS.txt` - Interactive terminal content
- **Load**: Opens file browser to load a saved log file
- **Close** (Replay Mode): Exit replay mode and return to live monitoring

#### Statistics and Connection Control
- **Missed Logs**: Displays count of device-side missed logs
  - Click to reset counter
  - Turns red when count is greater than zero
  - Automatically increments when device reports missed logs
- **Stats**: Opens real-time statistics dialog showing:
  - Missed Logs: Device UART queue overflow count
  - Corrupted Logs: Console reception errors (framing issues)
  - Logs Truncated: Messages ending with `...` (exceeded buffer size)
  - Total Logs Received: Overall log count
- **Connect** (Green): Manually connect to the serial port
- **Disconnect** (Red): Close the serial connection
- Connection is not automatic on startup, allowing offline log review

#### Font Size
- **+/-** buttons: Increase or decrease font size for all terminals
- Range: 6pt to 24pt

## Workflow Examples

### Standard Development Session
1. Launch the console: `./silabs_console.py /dev/ttyACM0`
2. Click **Connect** when ready to monitor
3. Send commands via the input field
4. Use filters to focus on specific log types
5. Click **Save** to preserve the session
6. Click **Disconnect** or close the window when done

### Analyzing Saved Logs
1. Launch the console: `./silabs_console.py /dev/ttyACM0`
2. Click **Load** and select a saved log file
3. Use filters to narrow down specific issues
4. Review with module filters for component-specific analysis
5. Click **Close** to exit replay mode

### Debugging a Specific Module
1. Connect to your device
2. Click **More Options**
3. Deselect all modules except the one you're debugging
4. Monitor only relevant messages
5. Re-enable other modules as needed

### Monitoring System Health
1. Connect to your device
2. Click **Stats** to open the statistics dialog
3. Monitor in real-time:
   - Missed Logs: If increasing, device is generating logs faster than UART can transmit
   - Corrupted Logs: If non-zero, check cable quality or baudrate
   - Logs Truncated: If increasing, consider increasing UART buffer size in firmware
4. Use **Missed Logs** button for quick reset during testing

## Message Format

The console expects the following message formats from the device:

### Framed Log Messages
```
SOF (0x01) + ASCII message content + EOF (0x04) + \r\n
```
These appear in the **Log Terminal** with color coding based on log level tags.

**Truncation Detection**: Messages ending with `.....` are automatically detected as truncated and counted in statistics.

### Unframed Messages
```
ASCII message content + \r\n
```
These appear in the **Interactive Terminal** without processing.

### Special Message Patterns
```
Missed Logs: <number>\r\n
```
Automatically captured and counted. The number is added to the Missed Logs counter without displaying the message in the terminal.

## Troubleshooting

### Port Permission Issues (Linux/macOS)
```bash
sudo usermod -a -G dialout $USER
# Log out and back in for changes to take effect
```

### Port Already in Use
- Ensure no other terminal program is connected to the port
- Check for stale processes: `lsof | grep ttyACM0`

### Connection Fails
- Verify the correct port: `ls /dev/tty*` (Linux/macOS) or Device Manager (Windows)
- Check device is powered and enumerated
- Try a different USB port or cable
- Verify baudrate matches device configuration

### Application Crashes on Exit
If you experience crashes when closing while connected:
- Click **Disconnect** before closing the window
- This has been addressed in recent versions but older Python/Qt combinations may still experience issues

## Advanced Tips

### Keyboard Shortcuts
- **Enter**: Send command from input field
- **Ctrl+C**: Copy selected text from terminals

### Log Retention
- All messages remain in memory even when filtered out
- Changing filters instantly shows or hides relevant messages
- Useful for toggling between overview and detailed views

### Statistics Monitoring
- Statistics dialog updates in real-time every 100ms
- Non-modal dialog allows continued console interaction
- Color coding:
  - Green: Normal (0 errors)
  - Yellow: Warning (truncated logs detected)
  - Red: Error (corrupted logs detected)

### Timestamped Logs
- Log files include the full session history
- Filenames use ISO 8601-like format: `YYYYMMDD_HHMMSS`
- Interactive terminal captures your commands with `>` prefix

## Contributing

When reporting issues or suggesting features, please include:
- Operating system and version
- Python version: `python --version`
- PyQt5 version: `pip show PyQt5`
- Serial device information
- Steps to reproduce (for bugs)

## License

This tool is part of the Connected Home over IP (Matter) project.
See the project's main LICENSE file for details.

## Module Overview

### console_log_parser.py
Handles all message parsing and filtering logic:
- `LogParser`: Message categorization and pattern detection
- `MessageBuffer`: Serial data buffering and frame extraction
- `LogFilter`: Category and module filtering management

### console_ui.py
Provides all Qt-based UI components:
- `ConsoleUI`: Main window with dual terminals
- `StatsDialog`: Real-time statistics popup
- `ModuleFilterDialog`: Advanced filtering options
- `SignalEmitter`: Thread-safe UI update signals

### silabs_console.py
Main application coordinator:
- `SilabsMatterConsole`: Serial connection and data flow management
- `main()`: Application entry point and argument parsing
