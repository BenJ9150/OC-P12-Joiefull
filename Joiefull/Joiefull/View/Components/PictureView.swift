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
        .frame(
            minWidth: 0,
            idealWidth: width == .infinity ? nil : width,
            maxWidth: width,
            minHeight: 0,
            idealHeight: height == .infinity ? nil : height,
            maxHeight: height
        )
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
        .padding(.horizontal, 2)
        .background(
            Capsule().fill(.background)
        )
    }
}

// MARK: - Preview

#Preview {
    let testInfinity = true
    let clothing = ClothesPreview().getClothing()

    if testInfinity {
        VStack {
            PictureView(clothing: clothing, width: .infinity, height: .infinity)
        }
        .padding()
    } else {
        ScrollView {
            PictureView(clothing: clothing, width: 198, height: 198)
        }
        .padding()
    }
}
