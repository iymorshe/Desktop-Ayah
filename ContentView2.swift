//
//  ContentView.swift
//  Binary Clock
//
//  Created by Iman Morshed on 4/28/24.
//

import SwiftUI
struct ContentVie: View {
    var body: some View {
            VStack(spacing: 20) {
                VSliderDemo()
                Spacer()
            }
            .padding()
    }
}

struct ContentVie_Previews: PreviewProvider {
    static var previews: some View {
        ContentVie()
    }
}
