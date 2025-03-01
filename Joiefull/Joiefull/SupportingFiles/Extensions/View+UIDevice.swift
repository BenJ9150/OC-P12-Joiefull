//
//  View+UIDevice.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 01/03/2025.
//

import SwiftUI

extension View {

    var isPad: Bool {
        UIDevice.isPad
    }
}

extension UIDevice {
    static let isPad = current.userInterfaceIdiom == .pad
}
