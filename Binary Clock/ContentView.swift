//
//  ContentView.swift
//  Binary Clock
//
//  Created by Kai Azim on 2022-12-13.
//

import SwiftUI
let fatihah = ["In the name of God, the Gracious, the Merciful",
               
            "Praise be to God, Lord of the Worlds.",

               "3. The Most Gracious, the Most Merciful.",

               "4. Master of the Day of Judgment.",

               "5. It is You we worship, and upon You we call for help.",

               "6. Guide us to the straight path.",

               "7. The path of those You have blessed, not of those against whom there is anger, nor of those who are misguided."
               ]
struct BinaryClockView: View {

    @EnvironmentObject var appDelegate: AppDelegate
    @State var ayahString : String = fatihah[6]
    var body: some View {
        // REFRESH TIME
        Text("\(ayahString)")
            .padding()
            .background(appDelegate.color ? .black : .clear)
        
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            

            
        
            /*.onAppear {
                Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                    ayahString = fatihah.randomElement() ?? ""
                }
            } */
    }
}

