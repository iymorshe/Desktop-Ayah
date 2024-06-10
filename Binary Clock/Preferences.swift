//
//  Preferences.swift
//  Binary Clock
//
//  Created by Iman Morshed on 4/28/24.
//

import SwiftUI

struct Preferences: View {
    
    @EnvironmentObject var appDelegate: AppDelegate
    @State private var selectedTab = "General"
    @State private var placeOverDesktopIcons: Bool = true

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    appDelegate.hidePreferences()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            TabView(selection: $selectedTab) {
                GeneralView().tabItem {
                    Label("Timing", systemImage: "gear")
                }.tag("General")
                
                PositionView()
                    .environmentObject(appDelegate)
                    .tabItem {
                    Label("Position", systemImage: "arrow.up.arrow.down")
                }.tag("Position")
                
                TextView()
                    .environmentObject(appDelegate)
                    .tabItem {
                    Label("Text", systemImage: "arrow.up.arrow.down")
                }.tag("Text")
                
                /*
                Text("Text Options").tabItem {
                    Label("Text", systemImage: "textformat")
                }.tag("Text")
                
                Text("Overlay Options").tabItem {
                    Label("Overlay", systemImage: "camera.filters")
                }.tag("Overlay")
                 */
            }
            .frame(width: 400, height: 300)
        }
    }
}

struct GeneralView: View {
    @EnvironmentObject var appDelegate: AppDelegate

    var body: some View {
        VStack {

            Picker("Refresh Interval", selection: $appDelegate.timerUpdate) {
                Text("Every 1 second").tag(1.0/960/2)
                Text("Every 3 seconds").tag(1.0/960)
                Text("Every 7 seconds").tag(1.0/480)
                Text("Every 15 seconds").tag(1.0/240)
                Text("Every 30 seconds").tag(1.0/120)
                Text("Every 1 minute").tag(1.0/60)
                Text("Every 1 hour").tag(1.0)
                Text("Every 12 hours").tag(12.0)
                Text("Every 24 hours").tag(24.0)
                Text("Don't refresh automatically").tag(999)
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }
}


struct PositionView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Text("Top of Screen")
            VSlider(value: $appDelegate.sliderValue,
                    in: 0...1,
                    step: 0.01,
                    onEditingChanged: { _ in
                
            }
                    
            )
            Text("Bottom of Screen")
        }
        .padding()
    }
}

struct TextView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    var body: some View {
        VStack(alignment: .leading) {
            Text("Text Alignment")
                .font(.headline)
            HStack {
                Spacer()
                Button("Left") {
                    appDelegate.textAlignment = .leading
                }
                Spacer()
                Button("Center") {
                    // Action for Center
                    appDelegate.textAlignment = .center
                }
                Spacer()
                Button("Right") {
                    // Action for Right
                    appDelegate.textAlignment = .trailing
                }
                Spacer()
            }
            .padding()
            .padding(.vertical)
            
            // Text Font/Size
            VStack(alignment: .leading) {
                Text("Text Font/Size")
                    .font(.headline)
                HStack {
                    Spacer()
                    Button("Fonts") {
                        FontManager.shared.setAppDelegate(appDelegate)
                        FontManager.shared.showFontPanel()
                        //update appDelegate.font
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}


class FontManager: NSObject, NSFontChanging, NSColorChanging{
    func changeColor(_ sender: NSColorPanel?) {
       guard let sender = sender, let appDelegate = appDelegate else { return }
       let color = sender.color
       appDelegate.textColor = color
    }
    
    static let shared = FontManager()
    private var appDelegate: AppDelegate?

    func setAppDelegate(_ appDelegate: AppDelegate) {
        //print("salam")
        self.appDelegate = appDelegate
    }

    func changeFont(_ sender: NSFontManager?) {
        guard let sender = sender, let appDelegate = appDelegate else { return }
        let font = sender.convert(.systemFont(ofSize: NSFont.systemFontSize))
        appDelegate.font = font
    }

    private func validModes(forFontPanel fontPanel: NSFontPanel) -> NSFontPanel.ModeMask {
        return [.collection, .face, .size]
    }
    
    func showFontPanel() {
        let fontManager = NSFontManager.shared
        fontManager.target = self
        fontManager.action = #selector(changeFont(_:))
        fontManager.orderFrontFontPanel(nil)
    }
}

class ColorManager: NSObject, NSColorChanging {
    func changeColor(_ sender: NSColorPanel?) {
        guard let sender = sender, let appDelegate = appDelegate else { return }
            //let c = sender.convert(
        //appDelegate.font = font
    }
    
    static let shared = ColorManager()
    private var appDelegate: AppDelegate?

    func setAppDelegate(_ appDelegate: AppDelegate) {
        print("salamaaa")
        self.appDelegate = appDelegate
    }
    func showFontPanel() {
        let fontManager = NSFontManager.shared
        fontManager.target = self
        fontManager.action = #selector(changeColor(_:))
        fontManager.orderFrontFontPanel(nil)
    }
}


extension Font {
    init(nsFont: NSFont) {
        self = Font.custom(nsFont.fontName, size: nsFont.pointSize)
    }
}
