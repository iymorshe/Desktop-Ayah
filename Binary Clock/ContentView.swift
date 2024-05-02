//
//  ContentView.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI
import AppKit
struct BinaryClockView: View {

    @EnvironmentObject var appDelegate: AppDelegate
    @State var height: CGFloat = CGFloat(700)
    var body: some View {
        // REFRESH TIME
        VStack{
            Text("\(appDelegate.ayah?.englishTranslation ?? "") ( \(appDelegate.ayah?.surahNumber ?? 0):\(appDelegate.ayah?.ayahNumber ?? 0) )")
                .font(Font.custom("uthmani", size: CGFloat(appDelegate.fontSize)))
                .multilineTextAlignment(.center)
                .padding()
                .background(appDelegate.color ? .black : .clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(y: CGFloat(appDelegate.sliderValue) * CGFloat(height)) // Move the Text based on sliderValue
                .onAppear {
                    appDelegate.newVerse()
                    if let screen = NSScreen.main {
                        let rect = screen.frame
                        height = rect.size.height
                        let width = rect.size.width
                    }

                }
                .onReceive(Timer.publish(every: 12 * 60 * 60, on: .main, in: .common).autoconnect()) { _ in
                    appDelegate.newVerse()
                    
                }
            Spacer()
        }
        
    }
}

