//
//  DynamicTypeSize+HighAccessSize.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 07/02/2025.
//

import SwiftUI

extension DynamicTypeSize {

    /// From accessibility3, is an high accessibility size.
    var isHighAccessibilitySize: Bool {
        switch self {
        case .accessibility3:
            return true
        case .accessibility4:
            return true
        case .accessibility5:
            return true
        default:
            return false
        }
    }
}
