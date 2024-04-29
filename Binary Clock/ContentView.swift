//
//  ContentView.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI

struct BinaryClockView: View {

    @EnvironmentObject var appDelegate: AppDelegate
    @State var ayahString : Ayah
    var body: some View {
        // REFRESH TIME
            Text("\(appDelegate.string)")
                .padding()
                .background(appDelegate.color ? .black : .clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

