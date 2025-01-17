//
//  DetailView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct DetailView: View {
    let clothing: Clothing

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

#Preview {

    let urlPar1 = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
    let urlPar2 = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg"

    let clothing: Clothing = Clothing(
        id: 0,
        picture: Picture(
            url: urlPar1 + urlPar2,
            description: "Sac à main orange posé sur une poignée de porte"
        ),
        name: "Sac à main orange",
        category: "ACCESSORIES",
        likes: 56,
        price: 69.99,
        originalPrice: 69.99
    )

    DetailView(clothing: clothing)
}
