//
//  PictureView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 31/01/2025.
//

import SwiftUI

struct PictureView: View {

    let clothing: Clothing
    let width: CGFloat
    let height: CGFloat

    // MARK: Body

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            asyncPicture
            if clothing.likes > 0 {
                likesBanner
                    .padding(.all, 12)
            }
        }
    }
}

extension PictureView {

    // MARK: Async image

    var asyncPicture: some View {
        AsyncImage(url: URL(string: clothing.picture.url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: width)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
        )
    }

    // MARK: Likes banner

    var likesBanner: some View {
        HStack(spacing: 2) {
            Image(systemName: "heart")
                .font(.footnote.weight(.semibold))
            Text("\(clothing.likes)")
                .font(.footnote.weight(.semibold))
        }
        .padding(.all, 6)
        .background(
            Capsule().fill(.white)
        )
    }
}

// MARK: - Preview

#Preview {
    let clothing = ClothesPreview().getClothing()
    PictureView(clothing: clothing, width: 198, height: 198)
}
