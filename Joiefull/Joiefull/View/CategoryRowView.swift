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
                .font(.system(size: 22, weight: .semibold))
            itemsList
        }
        .padding(.top, 18)
    }
}

// MARK: Items

private extension CategoryRowView {

    var itemsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: sizeClass == .regular ? 15 : 8) {
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
