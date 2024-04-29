//
//  Binary_ClockApp.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI
import Combine
@main
struct Binary_ClockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        MenuBarExtra("Binary Clock", systemImage: "clock.circle.fill") {
            Text("Binary Clock")
            Button("Toggle Visibility") { //doesnt work
                NotificationCenter.default.post(name: Notification.Name.toggleVisibility, object: nil)
            }
            //Button("Copy Verse"){
            //}
            //Button("Preferences") {
            //}
            Button("Toggle Background") {
                appDelegate.color.toggle()
            }
            Button("New Verse") {
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
        
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    // Define the window's controller
    private var windowController: NSWindowController?
    var isShown = true
    var window: NSWindow!
    @Published var ayah: Ayah?
    @Published var color: Bool = false
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
            window.isMovableByWindowBackground = false
            window.setFrame(NSRect(x: 0,
                                   y: 0,
                                   width: screenWidth,
                                   height: screenHeight),
                            display: false)  // Make the window as big as the readable part on the screen
            window.backgroundColor = .clear
            NSApp.setActivationPolicy(.regular)
            do {
                // Get the URL for the data.json file in the app bundle
                guard let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") else {
                    print("Failed to locate data.json in bundle.")
                    return
                }

                // Load the data from the file into a Data object
                let data = try Data(contentsOf: fileURL)

                // Decode the JSON data into an Ayah object
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(AyahDataWrapper.self, from: data)
                let ayah = decodedData.data

                // Use the Ayah object to initialize BinaryClockView
                window.contentView = NSHostingView(rootView: BinaryClockView(ayahString: ayah).environmentObject(self))
            } catch {
                print("Failed to load or decode data: \(error)")
            }            // Assign the SwiftUI ContentView to imageWindow
            //window.contentView = NSHostingView(rootView: BinaryClockView(ayahString: Ayah)
               // .environmentObject(self))
            
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

extension Notification.Name {
    static let preferencesChanged = Notification.Name("preferencesChanged")
}
