//
//  ButtonStyle.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/02/2025.
//

import SwiftUI

struct JoifullButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .font(.headline.weight(.bold))
            .foregroundStyle(Color.buttonText)
            .padding()
            .padding(.horizontal)
            .background(Color.buttonBackground, in: .capsule)
        }
}

#Preview {
    Button("Mon bouton") {
        print("button pressed")
    }
    .buttonStyle(JoifullButton())
}
