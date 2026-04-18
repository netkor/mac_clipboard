# Mac Clipboard Manager

A lightweight, purely native macOS menu bar app for managing your clipboard history. Written in Swift and SwiftUI.

## Features
- **Unobtrusive**: Lives entirely in your menu bar with no dock icon.
- **Persistent History**: Saves history across restarts, holding up to 100 of your most recent copies.
- **Smart Tracking**: Ignores empty/whitespace copies and deduplicates existing items by moving them back to the top of your list.
- **Native UI**: Built entirely using native SwiftUI `MenuBarExtra`.

## Requirements
- macOS 13.0 or later
- Swift 5+

## How to Build & Run
You can easily compile and run the project natively without opening Xcode. A build script is provided:

```bash
chmod +x build.sh
./build.sh
```

This will compile the Swift code, create an application bundle (`ClipboardApp.app`), and automatically launch it. 

## Structure
- `main.swift`: Contains the core logic including the SwiftUI views and `NSPasteboard` monitoring.
- `Info.plist`: Application metadata. Configures the app as an agent (`LSUIElement`) to prevent a dock icon from appearing.
- `build.sh`: A simple Bash script to compile the Swift source code into a `.app` bundle format without Xcode overhead.
