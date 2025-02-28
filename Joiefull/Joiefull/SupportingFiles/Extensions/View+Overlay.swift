//
//  View+Overlay.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 23/02/2025.
//

import SwiftUI

extension View {

    /// Use this method to add a condtion for show content of overlay
    func overlay<Overlay: View>(
        alignment: Alignment = .center,
        when condition: Bool, @ViewBuilder content: () -> Overlay
    ) -> some View {
        self.overlay(condition ? AnyView(content()) : AnyView(EmptyView()), alignment: alignment)
    }
}
