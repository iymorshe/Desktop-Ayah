//
//  Binary_ClockApp.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI

@main
struct Binary_ClockApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        MenuBarExtra("Binary Clock", systemImage: "clock.circle.fill") {
            Text("Binary Clock")
            Button("Refresh Verse") {
                //NotificationCenter.default.post(name: Notification.Name.toggleVisibility, object: nil)
            }
            Button("Copy Verse"){
            }
            Button("Preferences") {
                //NSApplication.shared.terminate(nil)
            }
            Button("Preferences") {
                //NSApplication.shared.terminate(nil)
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Define the window's controller
    private var windowController: NSWindowController?
    
    var isShown = true
    
    var window: NSWindow!
    func applicationDidFinishLaunching(_ notification: Notification) {
            showWindow()
    }
    
    func showWindow() {
        // Get screen dimensions
        guard let screen = NSScreen.deepest else { return }
        let screenWidth = Int(screen.visibleFrame.width)
        let screenHeight = Int(screen.visibleFrame.height)
        
        if windowController != nil { return } else {
            // Define the window
            window = NSWindow(contentRect: .zero,
                                  styleMask: .borderless,
                                 backing: .buffered,
                                 defer: true
                                 )
            window.collectionBehavior = .transient
            window.isMovableByWindowBackground = false      // Makes window unmoveable by user
            window.backgroundColor = .clear                 // Makes window transparent (window is made in SwiftUI)

            window.setFrame(NSRect(x: 0,
                                   y: 0,
                                   width: screenWidth,
                                   height: screenHeight),
                            display: false)  // Make the window as big as the readable part on the screen

            NSApp.setActivationPolicy(.regular)
            // Assign the SwiftUI ContentView to imageWindow
            window.contentView = NSHostingView(rootView: BinaryClockView())
            
            // Assign imageWindow to imageWindowController (NSWindowController)
            windowController = .init(window: window)
            // Show window

            window.orderFrontRegardless()
            
        }
    }
    
    func hideWindow() {
        guard let windowController = windowController else { return } // If there's no open window, return
        
        windowController.close()       // Close window
        self.windowController = nil    // Release window controller (will need to be re-made to show window again)
    }
}

extension NSPanel {
    open override var canBecomeKey: Bool {
        return true
    }
}
