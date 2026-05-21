#!/usr/bin/env python3

import sys
import csv
import re
from pathlib import Path

def extract_board_name(file_path):
    """Extract board name (brdXXXX) from file path."""
    match = re.search(r'brd\w+', file_path, re.IGNORECASE)
    return match.group(0).lower() if match else None

def read_csv_data(csv_file):
    """Read CSV file and return a dictionary with board names as keys."""
    data = {}
    
    # Check if file is empty
    try:
        with open(csv_file, 'r') as f:
            content = f.read()
            if not content.strip():
                print(f"Error: CSV file is empty: {csv_file}")
                sys.exit(1)
    except FileNotFoundError:
        print(f"Error: CSV file not found: {csv_file}")
        sys.exit(1)
    
    with open(csv_file, 'r') as f:
        reader = csv.reader(f)
        # Skip header row
        header = next(reader, None)
        
        # Check if file has only header or no content
        has_data = False
        for row in reader:
            has_data = True
            if len(row) >= 3:
                file_path = row[0].strip()
                flash_size = int(row[1].strip())
                ram_size = int(row[2].strip())
                
                board_name = extract_board_name(file_path)
                if board_name:
                    # Store with board name as key, keeping full path for reference
                    data[board_name] = {
                        'file_path': file_path,
                        'flash': flash_size,
                        'ram': ram_size
                    }
        
        if not has_data:
            print(f"Error: CSV file contains no data rows: {csv_file}")
            sys.exit(1)
    
    return data

def main():
    if len(sys.argv) != 3:
        print("Usage: python code_size_diff_check.py <csv_file1> <csv_file2>")
        sys.exit(1)
    
    csv1 = sys.argv[1]
    csv2 = sys.argv[2]
    
    # Determine which file is "current"
    if 'current' in csv1.lower():
        current_file = csv1
        baseline_file = csv2
    elif 'current' in csv2.lower():
        current_file = csv2
        baseline_file = csv1
    else:
        print("Error: One of the CSV files must contain 'current' in its name")
        sys.exit(1)
    
    # Read both CSV files
    current_data = read_csv_data(current_file)
    baseline_data = read_csv_data(baseline_file)
    
    # Check if CSV files contain valid data
    if not current_data:
        print(f"Error: No valid board data found in current file: {current_file}")
        sys.exit(1)
    
    if not baseline_data:
        print(f"Error: No valid board data found in baseline file: {baseline_file}")
        sys.exit(1)
    
    # Thresholds
    FLASH_THRESHOLD_PCT = 0.2 # Allow 0.2% increase in flash size (for a 1MB baseline, this is 2KB)
    RAM_THRESHOLD_PCT = 1.0
    
    print(f"Comparing current build ({Path(current_file).name}) against baseline ({Path(baseline_file).name})")
    print(f"Thresholds: Flash > {FLASH_THRESHOLD_PCT}%, RAM > {RAM_THRESHOLD_PCT}%")
    print("=" * 100)
    
    # Print table header
    print(f"{'Board':<15} {'Flash Change':<25} {'RAM Change':<25} {'Status':<10}")
    print("-" * 100)
    
    # Track if any threshold violations were found
    threshold_exceeded = False
    
    # Compare board by board
    for board, current in sorted(current_data.items()):
        if board in baseline_data:
            baseline = baseline_data[board]
            
            flash_diff = current['flash'] - baseline['flash']
            ram_diff = current['ram'] - baseline['ram']
            
            flash_pct = (flash_diff / baseline['flash'] * 100) if baseline['flash'] > 0 else 0
            ram_pct = (ram_diff / baseline['ram'] * 100) if baseline['ram'] > 0 else 0
            
            # Check if thresholds are exceeded
            flash_exceeds = flash_diff > 0 and flash_pct > FLASH_THRESHOLD_PCT
            ram_exceeds = ram_diff > 0 and ram_pct > RAM_THRESHOLD_PCT
            
            if flash_exceeds or ram_exceeds:
                threshold_exceeded = True
                status = "FAIL"
            else:
                status = "PASS"
            
            # Format flash change
            if flash_diff > 0:
                flash_str = f"+{flash_diff:,} bytes (+{flash_pct:.2f}%)"
            elif flash_diff < 0:
                flash_str = f"{flash_diff:,} bytes ({flash_pct:.2f}%)"
            else:
                flash_str = "0 bytes (0.00%)"
            
            # Format RAM change
            if ram_diff > 0:
                ram_str = f"+{ram_diff:,} bytes (+{ram_pct:.2f}%)"
            elif ram_diff < 0:
                ram_str = f"{ram_diff:,} bytes ({ram_pct:.2f}%)"
            else:
                ram_str = "0 bytes (0.00%)"
            
            print(f"{board:<15} {flash_str:<25} {ram_str:<25} {status:<10}")
        else:
            print(f"{board:<15} {'NOT IN BASELINE':<25} {'NOT IN BASELINE':<25} {'WARN':<10}")
    
    print("=" * 100)
    
    if threshold_exceeded:
        print("Code size increase threshold exceeded!")
        sys.exit(1)
    else:
        print("All boards within acceptable code size thresholds")
        sys.exit(0)

if __name__ == "__main__":
    main()
