#!/usr/bin/env bash
# Generate inline styles for board compatibility matrix HTML for Confluence compatibility.
#
# Replaces CSS classes with inline styles so colors, borders, and
# headers survive Confluence's HTML sanitizer. Content is unchanged.
#
# Usage: confluence_inline_styles.sh INPUT_HTML OUTPUT_DIR
# Output: OUTPUT_DIR/<stem>.confluence.html
#
# Example:
#   confluence_inline_styles.sh board_compatibility_matrix.html .
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 INPUT_HTML OUTPUT_DIR"
    exit 1
fi

in="$1"
outdir="$2"

mkdir -p "$outdir"

base="$(basename "$in")"
stem="${base%.*}"

out="${outdir}/${stem}.confluence.html"

perl -0777 -pe '
s/<h2>Legend<\/h2>\s*<table>.*?<\/table>//s;
s/<table>/<table style="border-collapse:collapse;border:1px solid #999;">/g;
s/<td class='\''compatible'\''>/<td style="border:1px solid #999;padding:4px;width:50px;text-align:center;background-color:yellow;color:black;">/g;
s/<td class='\''incompatible'\''>/<td style="border:1px solid #999;padding:4px;width:50px;text-align:center;background-color:lightgrey;color:black;">/g;
s/<td class='\''added'\''>/<td style="border:1px solid #999;padding:4px;width:50px;text-align:center;background-color:lightgreen;color:green;">/g;
s/<td class='\''removed'\''>/<td style="border:1px solid #999;padding:4px;width:50px;text-align:center;background-color:lightpink;color:darkred;">/g;
s/<td class='\''first-column'\''/<td style="border:1px solid #999;padding:4px;position:sticky;left:0;background-color:white;white-space:nowrap;"/g;
s/<th class='\''first-column-head'\''>/<th style="border:1px solid #999;padding:4px;writing-mode:horizontal-tb;z-index:1;left:0;background-color:white;">/g;
s/<th>/<th style="border:1px solid #999;padding:4px;writing-mode:sideways-lr;text-align:left;position:sticky;top:0;background-color:white;">/g;
s/<div class='\''sticky-left'\''>/<div style="position:sticky;left:0;display:inline-block;">/g;
' "$in" > "$out"

echo "Wrote $out"
