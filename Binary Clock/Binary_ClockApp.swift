//
//  Binary_ClockApp.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI
import Combine
import SwiftData
import StoreKit
@main
struct DesktopQuran: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var shown: Bool = true
    var body: some Scene {
        MenuBarExtra("Binary Clock", systemImage: "moon.stars.circle") {
            Button("Refresh Verse") {
                    appDelegate.newVerse()
            }
            Button("Copy Verse") {
                //let copiedText = "\(appDelegate.ayah?.englishTranslation ?? "") ( \(appDelegate.ayah?.surahNumber ?? 0):\(appDelegate.ayah?.ayahNumber ?? 0) )"
                if let firstAyah = appDelegate.ayah?.first {
                    let copiedText = "\(firstAyah.englishTranslation)"
                    NSPasteboard.general.clearContents() // Clear the clipboard
                    NSPasteboard.general.setString(copiedText, forType: .string) // Set the copied text to the clipboard
                }
                
            }
            Divider()
            Button("Preferences") {
                appDelegate.showPreferences()
            }
            Divider()
            Button(action: {
                appDelegate.color.toggle()
            }, label: {
                Text("Toggle Background")
            })
            /*Button("Donate") {
                appDelegate.showDonation()

            }*/
            Button("Toggle Visibility") { //doesnt work
                if shown { //hide the window
                    appDelegate.hideWindow()
                } else {
                    appDelegate.showWindow()
                }
                shown.toggle()
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
    @Published var ayah: [Ayah]?
    @Published var string: String = "habibti"
    @Published var color: Bool = false
    @Published var fontSize: Int = 36
    @Published var sliderValue: Double = 0.5
    @Published var timerUpdate: Double = 24
    @Published var font: NSFont = .systemFont(ofSize: 20)
    @Published var textColor: NSColor = .white
    @Published var textAlignment: HorizontalAlignment = .center
    @MainActor func newVerse() {
        Task {
            do {
                ayah = try await randomVerses()
                //ayah = try await fetchVerses(number: 7)
                //string = ayah?.englishTranslation ?? ""
            } catch {
                print("Failed to fetch random verse: \(error)")
            }
        }
    }
    func applicationDidFinishLaunching(_ notification: Notification) {
            showWindow()
    
    }
    @MainActor func showWindow() {
        // Get screen dimensions
        guard let screen = NSScreen.deepest else { return }
        let screenWidth = Int(screen.visibleFrame.width)
        let screenHeight = Int(screen.visibleFrame.height)
        if ayah == nil {
            self.newVerse()
        }
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
                                   y: screenHeight - Int(screen.visibleFrame.height),
                                   width: screenWidth,
                                   height: screenHeight),
                            display: false)  // Move the window to the top of the screen
            window.backgroundColor = .clear
            NSApp.setActivationPolicy(.regular) //have an option to toggle the desktop icon
                // Use the Ayah object to initialize BinaryClockView
                window.contentView = NSHostingView(rootView: BinaryClockView().environmentObject(self))
            windowController = .init(window: window)
            // Show window
            window.orderFront(nil)
            //window.orderFrontRegardless()
            
        }
    }
    func showDonation() {
            if preferencesController != nil { return } else {
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
                
                preferencesWindow.isOpaque = false
                preferencesWindow.setFrame(NSRect(x: Int(NSScreen.main?.visibleFrame.midX ?? 0) - 100,
                                                  y: Int(NSScreen.main?.visibleFrame.midY ?? 0) - 100,
                                                  width: 200,
                                                  height: 200),
                                display: true)
                preferencesWindow.contentView = NSHostingView(rootView: DonationsWindow().environmentObject(self))
                
                preferencesController = .init(window: preferencesWindow )
                // Show window
                preferencesWindow.orderFrontRegardless()
               
            }
    }
    
    func hideWindow() {
        guard let windowController = windowController else { return } // If there's no open window, return
        
        windowController.close()       // Close window
        self.windowController = nil    // Release window controller (will need to be re-made to show window again)
    }
    func hidePreferences() {
        guard let preferencesController = preferencesController else { return } // If there's no open window, return
        
        preferencesController.close()       // Close window
        self.preferencesController = nil    // Release window controller (will need to be re-made to show window again)
    }
    func showPreferences() {
        if preferencesController != nil { return } else {
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
            
            preferencesWindow.isOpaque = false
            preferencesWindow.setFrame(NSRect(x: Int(NSScreen.main?.visibleFrame.midX ?? 0) - 100,
                                              y: Int(NSScreen.main?.visibleFrame.midY ?? 0) - 100,
                                              width: 200,
                                              height: 200),
                            display: true)
            preferencesWindow.contentView = NSHostingView(rootView: Preferences().environmentObject(self))
            
            preferencesController = .init(window: preferencesWindow)
            // Show window
            preferencesWindow.orderFrontRegardless()
           
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



struct DonationsWindow: View {
    @StateObject private var storeManager = StoreManager()
    
    var body: some View {
        HStack {
            ForEach(storeManager.products, id: \.self) { product in
                Button(action: {
                    storeManager.purchaseProduct(product: product)
                }) {
                    Text(product.localizedTitle)
                }
            }
        }
        .onAppear {
            storeManager.getProducts()
        }
    }
}

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func getProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.yourapp.donation1", "com.yourapp.donation5", "com.yourapp.donation10", "com.yourapp.donation25", "com.yourapp.donation50"])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // Handle failed purchase
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}
