//
//  CGFloat+DynamicTypeSize.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 07/02/2025.
//

import SwiftUI

extension CGFloat {

    /// Increase the current value when dynamic type size increases
    func adaptTo(_ dynamicTypeSize: DynamicTypeSize) -> CGFloat {
        let extraWidth: CGFloat = switch dynamicTypeSize {
        case .xSmall, .small, .medium: 0
        case .large: 12
        case .xLarge: 36
        case .xxLarge: 62
        case .xxxLarge: 80
        case .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5: 80
        @unknown default: 0
        }
        return self + extraWidth
    }
}
