//
//  Preferences.swift
//  Binary Clock
//
//  Created by Iman Morshed on 4/28/24.
//

import Foundation
import SwiftUI
class Preferences: ObservableObject {
    
    @Published var clear = true
    var verticalPosition: Double = 0.0
    
    init() {
    }
    
    
}
