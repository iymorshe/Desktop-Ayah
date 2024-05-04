//
//  ContentView.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI

struct BinaryClockView: View {
    
    @EnvironmentObject var appDelegate: AppDelegate
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("\(appDelegate.ayah?.englishTranslation ?? "") ( \(appDelegate.ayah?.surahNumber ?? 0):\(appDelegate.ayah?.ayahNumber ?? 0) )")
                    .font(Font.custom("uthmani", size: CGFloat(appDelegate.fontSize)))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(appDelegate.color ? .black : .clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * (-appDelegate.sliderValue + 1.05)) // Position the Text based on appDelegate.sliderValue
                    .lineSpacing(10) // Add line spacing to make the text double spaced
                    .onAppear {
                        appDelegate.newVerse()
                    }
                    .onReceive(Timer.publish(every: TimeInterval(appDelegate.timerUpdate * 60 * 60), on: .main, in: .common).autoconnect()) { _ in
                        appDelegate.newVerse()
                    }
                Spacer()
            }
        }
    }
}

