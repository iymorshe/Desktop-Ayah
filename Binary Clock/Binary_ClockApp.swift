//
//  Binary_ClockApp.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI
import Combine
@main
struct DesktopQuran: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var shown: Bool = true
    var body: some Scene {
        MenuBarExtra("Binary Clock", systemImage: "clock.circle.fill") {
            Button("Refresh Verse") {
                DispatchQueue.main.async {
                    appDelegate.newVerse()
                }
            }
            Button("Copy Verse") {
                let copiedText = "\(appDelegate.ayah?.englishTranslation ?? "") ( \(appDelegate.ayah?.surahNumber ?? 0):\(appDelegate.ayah?.ayahNumber ?? 0) )"
                NSPasteboard.general.clearContents() // Clear the clipboard
                NSPasteboard.general.setString(copiedText, forType: .string) // Set the copied text to the clipboard
            }
            Divider()
            Button("Preferences") {
                appDelegate.showPreferences()
            }
            /*
            Button("Toggle Background") {
                appDelegate.color.toggle()
            } */
            
            Divider()
            Button("Toggle Visibility") { //doesnt work
                if shown { //hide the window
                    appDelegate.hideWindow()
                } else {
                    appDelegate.showWindow()
                }
                shown.toggle()
            }
            Button("Feedback") {
                DispatchQueue.main.async {
                    NSApplication.shared.terminate(nil)
                }
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
    
    private var preferencesController: NSWindowController?
    var isShown = true
    var window: NSWindow!
    var preferencesWindow: NSWindow!
    @Published var ayah: Ayah?
    @Published var string: String = "habibti"
    @Published var color: Bool = false
    @Published var fontSize: Int = 36
    @MainActor func newVerse() {
        Task {
            do {
                ayah = try await randomVerse()
                string = ayah?.englishTranslation ?? ""
            } catch {
                print("Failed to fetch random verse: \(error)")
            }
        }
    }
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
            window.collectionBehavior = [.transient]
            //window.level = .floating
            window.isMovableByWindowBackground = false
            window.setFrame(NSRect(x: 0,
                                   y: 0,
                                   width: screenWidth,
                                   height: screenHeight),
                            display: false)  // Make the window as big as the readable part on the screen
            window.backgroundColor = .clear
            NSApp.setActivationPolicy(.regular)

                // Use the Ayah object to initialize BinaryClockView
                window.contentView = NSHostingView(rootView: BinaryClockView().environmentObject(self))
                     // Assign the SwiftUI ContentView to imageWindow
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
    func showPreferences() {
        if preferencesController != nil { return } else {
            print("haibib")
            // Define the window
            preferencesWindow = NSWindow(contentRect: NSRect(x: Int(NSScreen.main?.visibleFrame.midX ?? 0) - 100,
                                                             y: Int(NSScreen.main?.visibleFrame.midY ?? 0) - 100,
                                                             width: 200,
                                                             height: 200),
                                         styleMask: .closable,
                                         backing: .buffered,
                                         defer: true
            )
            //preferencesWindow.collectionBehavior = [.transient]
            preferencesWindow.isMovableByWindowBackground = true
            //preferencesWindow.backgroundColor = .black
            preferencesWindow.setFrame(NSRect(x: Int(NSScreen.main?.visibleFrame.midX ?? 0) - 100,
                                              y: Int(NSScreen.main?.visibleFrame.midY ?? 0) - 100,
                                              width: 200,
                                              height: 200),
                            display: true)
            preferencesWindow.contentView = NSHostingView(rootView: Preferences())
            
            preferencesController = .init(window: preferencesWindow)
            // Show window

            preferencesWindow.makeKeyAndOrderInFrontOfSpaces()
            
        }
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
