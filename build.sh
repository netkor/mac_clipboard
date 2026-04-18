#!/bin/bash

# Exit on error
set -e

echo "Building Clipboard App..."

APP_NAME="ClipboardApp"
APP_DIR="$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"

# Clean up old build
rm -rf "$APP_DIR"

# Create directories
mkdir -p "$MACOS_DIR"

# Compile swift file
swiftc -parse-as-library main.swift -o "$MACOS_DIR/$APP_NAME"

# Copy Info.plist
cp Info.plist "$CONTENTS_DIR/"

echo "Build complete! App is located at $PWD/$APP_DIR"
echo "Launching app..."
open "$APP_DIR"
