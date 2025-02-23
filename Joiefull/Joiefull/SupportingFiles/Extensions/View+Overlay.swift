//
//  View+Overlay.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 23/02/2025.
//

import SwiftUI

extension View {

    func overlay<Overlay: View>(
        alignment: Alignment = .center,
        when condition: Bool, @ViewBuilder content: () -> Overlay
    ) -> some View {
        self.overlay(condition ? AnyView(content()) : AnyView(EmptyView()), alignment: alignment)
    }
}
