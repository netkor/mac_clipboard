# Mac Clipboard Manager 📋

A lightweight, purely native macOS menu bar app for managing your clipboard history. Written completely in Swift and SwiftUI.

<p align="center">
<img src="./image.png" width="100" alt="Clipboard Manager Icon">
</p>

## ✨ Features
- **Unobtrusive**: Lives entirely in your menu bar with no dock icon.
- **Persistent History**: Saves history across restarts, holding up to 100 of your most recent copies.
- **Smart Tracking**: Ignores empty/whitespace copies and deduplicates existing items by moving them back to the top of your list.
- **Launch at Login**: Easily toggle the app to start automatically when you log into your Mac.
- **Native UI**: Built entirely using native SwiftUI `MenuBarExtra` for a completely native look and feel.

## 🚀 Requirements
- macOS 13.0 or later
- Swift 5+

## 🛠 How to Build & Run

You can easily compile and run the project natively without opening Xcode. A build script is provided to automate the process.

**Step-by-step instructions:**

1. **Open Terminal** and navigate to the project directory:
   ```bash
   cd /path/to/mac_clipboard
   ```
2. **Make the build script executable** (you only need to do this once):
   ```bash
   chmod +x build.sh
   ```
3. **Run the build script**:
   ```bash
   ./build.sh
   ```

This script will compile the Swift code, create an application bundle (`ClipboardApp.app`), and automatically launch it.

Once launched, look for the new icon in your **macOS menu bar** (top right of your screen). The app runs silently in the background and has no Dock icon.

**To run the app later:**
You don't need to rebuild it. Simply double-click the generated `ClipboardApp.app` in Finder, or drag it to your `/Applications` folder to keep it handy!

## Structure
- `main.swift`: Contains the core logic including the SwiftUI views and `NSPasteboard` monitoring.
- `Info.plist`: Application metadata. Configures the app as an agent (`LSUIElement`) to prevent a dock icon from appearing.
- `build.sh`: A simple Bash script to compile the Swift source code into a `.app` bundle format without Xcode overhead.
