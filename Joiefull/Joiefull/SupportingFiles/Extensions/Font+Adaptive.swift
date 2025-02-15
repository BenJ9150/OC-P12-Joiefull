//
//  Font+Adaptive.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 15/02/2025.
//

import SwiftUI

extension Font {

    private static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    static let adaptiveFootnote: Font = isPad ? .body : .footnote
    static let adaptiveBody: Font = isPad ? .title2 : .body
}
