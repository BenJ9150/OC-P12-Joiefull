//
//  View+Alert.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/02/2025.
//

import SwiftUI

extension View {

    func reviewAlert(
        show: Binding<Bool>,
        addCommentBtn: Bool,
        onSubmit: @escaping () -> Void,
        onAddComment: @escaping () -> Void
    ) -> some View {
        self.modifier(ReviewAlertModifier(
            show: show,
            addCommentBtn: addCommentBtn,
            onSubmit: onSubmit,
            onAddComment: onAddComment
        ))
    }
}
