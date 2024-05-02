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
        // REFRESH TIME
        Text("\(appDelegate.ayah?.englishTranslation ?? "") ( \(appDelegate.ayah?.surahNumber ?? 0):\(appDelegate.ayah?.ayahNumber ?? 0) )")
            .font(Font.custom("uthmani", size: CGFloat(appDelegate.fontSize)))
                .multilineTextAlignment(.center)
                .padding()
                .background(appDelegate.color ? .black : .clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear {
                    appDelegate.newVerse()
                }
        }
        
        
    }

