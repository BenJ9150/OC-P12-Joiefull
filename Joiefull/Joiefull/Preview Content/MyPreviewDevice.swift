//
//  MyPreviewDevice.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 14/02/2025.
//

import SwiftUI

enum MyPreviewDevice: String {

    case iPhoneMini = "iPhone 13 mini"
    case iPhoneMax = "iPhone 16 Pro Max"
    case iPadMini = "iPad mini (6th generation)"
    case iPadPro = "iPad Pro 13-inch (M4)"

    var preview: PreviewDevice {
        PreviewDevice(rawValue: rawValue)
    }
}
