import SwiftUI
import AppKit

// MARK: - Constants

private enum Constants {
    /// Maximum number of items to keep in the clipboard history
    static let maxHistoryItems = 100
    
    /// Maximum number of characters to show in the menu bar before truncating
    static let maxDisplayLength = 40
    
    /// Key used for storing the history in UserDefaults
    static let userDefaultsKey = "ClipboardHistory"
    
    /// How often (in seconds) to poll the pasteboard for new content
    static let pollingInterval: TimeInterval = 1.0
}

// MARK: - Main Application

@main
struct ClipboardApp: App {
    // Inject AppDelegate to configure app activation policy
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // State object to manage clipboard history and monitoring
    @StateObject private var clipboardMonitor = ClipboardMonitor()

    var body: some Scene {
        MenuBarExtra("Clipboard", systemImage: "doc.on.clipboard") {
            // Main Content Area
            if clipboardMonitor.history.isEmpty {
                Text("No History")
                    .foregroundColor(.secondary)
            } else {
                clipboardHistoryList
                
                Divider()
                
                Button("Clear History") {
                    clipboardMonitor.clearHistory()
                }
            }
            
            Divider()
            
            // App Controls
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var clipboardHistoryList: some View {
        ForEach(clipboardMonitor.history, id: \.self) { item in
            Button(action: {
                clipboardMonitor.copyToClipboard(item: item)
            }) {
                Text(truncateText(item, limit: Constants.maxDisplayLength))
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Truncates text for display in the menu bar, appending ellipses if necessary.
    private func truncateText(_ text: String, limit: Int) -> String {
        return text.count > limit ? String(text.prefix(limit)) + "..." : text
    }
}

// MARK: - App Delegate

/// Configures app behavior, such as preventing it from appearing in the standard Dock.
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as a pure menu bar accessory app
        NSApp.setActivationPolicy(.accessory)
    }
}

// MARK: - Clipboard Monitor

/// Monitors the system pasteboard for changes and maintains a history of copied text.
class ClipboardMonitor: ObservableObject {
    @Published var history: [String] = []
    
    private var timer: Timer?
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int = 0

    init() {
        self.lastChangeCount = pasteboard.changeCount
        loadHistory()
        startMonitoring()
    }

    // MARK: - Monitoring
    
    /// Starts polling the system pasteboard at regular intervals.
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.pollingInterval, repeats: true) { [weak self] _ in
            self?.checkForChanges()
        }
    }

    /// Checks if the pasteboard contents have changed since the last poll.
    private func checkForChanges() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        guard let newString = pasteboard.string(forType: .string) else { return }
        
        // Ignore purely whitespace copies
        let trimmed = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        DispatchQueue.main.async {
            self.addToHistory(trimmed)
        }
    }

    // MARK: - History Management
    
    /// Copies a specific history item back to the system pasteboard.
    func copyToClipboard(item: String) {
        pasteboard.clearContents()
        pasteboard.setString(item, forType: .string)
        
        // Update the change count so we don't trigger our own monitor loop
        lastChangeCount = pasteboard.changeCount
        
        DispatchQueue.main.async {
            self.addToHistory(item)
        }
    }
    
    /// Clears all stored history.
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    /// Adds a new item to the history, bringing it to the top if it already exists, and truncates if necessary.
    private func addToHistory(_ item: String) {
        // Remove item if it already exists to avoid duplicates
        if let index = history.firstIndex(of: item) {
            history.remove(at: index)
        }
        
        // Insert at the beginning (most recent)
        history.insert(item, at: 0)
        
        // Enforce maximum history limit
        if history.count > Constants.maxHistoryItems {
            history.removeLast()
        }
        
        saveHistory()
    }

    // MARK: - Persistence
    
    /// Loads the saved history from UserDefaults.
    private func loadHistory() {
        if let saved = UserDefaults.standard.array(forKey: Constants.userDefaultsKey) as? [String] {
            self.history = saved
        }
    }
    
    /// Persists the current history to UserDefaults.
    private func saveHistory() {
        UserDefaults.standard.set(history, forKey: Constants.userDefaultsKey)
    }
}
