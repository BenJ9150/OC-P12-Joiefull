//
//  ReviewAlertModifier.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/02/2025.
//

import SwiftUI

struct ReviewAlertModifier: ViewModifier {

    @Binding var show: Bool
    let addCommentBtn: Bool
    let onSubmit: () -> Void
    let onAddComment: () -> Void

    private var title: String {
        if addCommentBtn {
            return "Souhaitez-vous partager votre note sans laisser de commentaire ?"
        }
        return "Partager ma note et mon commentaire ?"
    }

    func body(content: Content) -> some View {
        content.alert(title, isPresented: $show) {
            Button("Partager", role: .none, action: onSubmit)
            if addCommentBtn {
                Button("Ajouter un commentaire", role: .none, action: onAddComment)
            }
            Button("Annuler", role: .cancel, action: {})
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var showAlert = false
    @Previewable @State var addCommentBtn = true

    VStack {
        Text("Send review alert preview")
        Button("Show Alert") {
            showAlert.toggle()
            addCommentBtn.toggle()
        }
        .buttonStyle(JoifullButton())
    }
    .reviewAlert(show: $showAlert, addCommentBtn: addCommentBtn, onSubmit: {}, onAddComment: {})
}
