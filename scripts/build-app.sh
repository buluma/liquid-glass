#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
configuration="${1:-debug}"
case "$configuration" in debug|release) ;; *) echo "Usage: $0 [debug|release]" >&2; exit 1 ;; esac
swift build -c "$configuration"
binary_dir="$(swift build -c "$configuration" --show-bin-path)"
app="dist/Liquid Glass.app"
mkdir -p "$app/Contents/MacOS"
cp "$binary_dir/LiquidGlass" "$app/Contents/MacOS/LiquidGlass"
cat > "$app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>LiquidGlass</string>
<key>CFBundleIdentifier</key><string>space.opsio.liquid-glass</string>
<key>CFBundleName</key><string>Liquid Glass</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0.0</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>26.0</string>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
codesign --force --sign - "$app"
echo "Built: $app"
