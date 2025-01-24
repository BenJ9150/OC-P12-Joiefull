//
//  CategoryRowView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import SwiftUI

struct CategoryRowView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    let category: String
    let items: [Clothing]

    var body: some View {
        VStack(alignment: .leading, spacing: sizeClass == .regular ? 16 : 12) {
            Text(category.capitalized)
                .font(.title3.weight(.semibold))
            itemsList
        }
        .padding(.top, 18)
    }
}

// MARK: Items

private extension CategoryRowView {

    var itemsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: sizeClass == .regular ? 15 : 8) {
                ForEach(items) { clothing in
                    NavigationLink {
                        DetailView(clothing: clothing)
                    } label: {
                        CategoryItemView(clothing: clothing)
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let jsonString = """
    [
      {
        "id": 3,
        "picture": {
          "url": "test",
          "description": "Homme en costume et veste de blazer qui regarde la caméra"
        },
        "name": "Blazer marron",
        "category": "TOPS",
        "likes": 15,
        "price": 79.99,
        "original_price": 79.99
      },
      {
        "id": 4,
        "picture": {
          "url": "test",
          "description": "Femme dehors qui pose avec un pull en maille vert"
        },
        "name": "Pull vert femme",
        "category": "TOPS",
        "likes": 15,
        "price": 29.99,
        "original_price": 39.99
      },
      {
        "id": 7,
        "picture": {
          "url": "test",
          "description": "Homme jeune stylé en jean et bomber qui pose dans la rue"
        },
        "name": "Bomber automnal pour homme",
        "category": "TOPS",
        "likes": 30,
        "price": 89.99,
        "original_price": 109.99
      },
      {
        "id": 8,
        "picture": {
          "url": "test",
          "description": "Homme en sweat jaune qui regarde à droite"
        },
        "name": "Sweat jaune",
        "category": "TOPS",
        "likes": 6,
        "price": 39.99,
        "original_price": 39.99
      }
    ]
    """

    let clothes: [Clothing]
    do {
        clothes = try JSONDecoder().decode([Clothing].self, from: jsonString.data(using: .utf8)!)
    } catch {
        fatalError("Failed to decode Clothes: \(error)")
    }

    return CategoryRowView(category: clothes[0].category, items: clothes)
}
