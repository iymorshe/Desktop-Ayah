//
//  Preferences.swift
//  Binary Clock
//
//  Created by Iman Morshed on 4/28/24.
//

import SwiftUI

struct Preferences: View {
    @State private var selectedTab = "General"
    @State private var sliderValue: Double = 0.5
    @State private var placeOverDesktopIcons: Bool = true

    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralView().tabItem {
                Label("General", systemImage: "gear")
            }.tag("General")
            
            PositionView(sliderValue: $sliderValue, placeOverDesktopIcons: $placeOverDesktopIcons).tabItem {
                Label("Position", systemImage: "arrow.up.arrow.down")
            }.tag("Position")
            
            Text("Text Options").tabItem {
                Label("Text", systemImage: "textformat")
            }.tag("Text")
            
            Text("Overlay Options").tabItem {
                Label("Overlay", systemImage: "camera.filters")
            }.tag("Overlay")
        }
        .frame(width: 400, height: 300)
    }
}

struct GeneralView: View {
    var body: some View {
        Text("General Settings")
    }
}

struct PositionView: View {
    @Binding var sliderValue: Double
    @Binding var placeOverDesktopIcons: Bool
    
    var body: some View {
        VStack {
            Slider(value: $sliderValue, in: 0...1, step: 0.1)
            Toggle("Place over desktop icons", isOn: $placeOverDesktopIcons)
        }
        .padding()
    }
}

