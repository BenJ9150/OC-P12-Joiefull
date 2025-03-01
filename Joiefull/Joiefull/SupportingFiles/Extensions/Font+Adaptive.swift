//
//  Font+Adaptive.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 15/02/2025.
//

import SwiftUI

extension Font {

    static let adaptiveFootnote: Font = UIDevice.isPad ? .body : .footnote
    static let adaptiveBody: Font = UIDevice.isPad ? .title2 : .body
}
