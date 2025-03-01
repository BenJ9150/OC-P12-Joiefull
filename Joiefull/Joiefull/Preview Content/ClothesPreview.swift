//
//  ClothesPreview.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 31/01/2025.
//

import SwiftUI

class ClothesPreview {

    enum ClothingType: Int {
        case withSmallDescription = 5
        case withBigDescription = 12
    }

    func getClothing(_ clothingType: ClothingType) -> Clothing {
        let index = clothingType.rawValue
        let clothing = getClothes()
        guard index < clothing.count else {
            fatalError("Failed to load clothing at index \(index) from clothesPreview.json")
        }
        return clothing[index]
    }

    func getClothing(_ index: Int = 0) -> Clothing {
        let clothing = getClothes()
        guard index < clothing.count else {
            fatalError("Failed to load clothing at index \(index) from clothesPreview.json")
        }
        return clothing[index]
    }

    func getClothes() -> [Clothing] {
        /// Get bundle for json localization
        let bundle = Bundle(for: ClothesPreview.self)

        /// Get url of clothesPreview json
        guard let clothesPreviewUrl = bundle.url(forResource: "clothesPreview", withExtension: "json") else {
            fatalError("Failed to get url of clothesPreview.json")
        }
        /// Get url of preview picture
        let clothingImageUrl = clothingImageUrl()

        do {
            let data = try Data(contentsOf: clothesPreviewUrl)
            let clothes = try JSONDecoder().decode([Clothing].self, from: data)

            return clothes.map { clothing in
                return Clothing(
                    id: clothing.id,
                    picture: Picture(
                        url: clothingImageUrl.absoluteString,
                        description: clothing.picture.description
                    ),
                    name: clothing.name,
                    category: clothing.category,
                    likes: clothing.likes,
                    price: clothing.price,
                    originalPrice: clothing.originalPrice
                )
            }
        } catch {
            fatalError("Failed to decode clothesPreview.json")
        }
    }

    func clothingImage() -> Image {
        let url = clothingImageUrl()
        return Image(uiImage: UIImage(contentsOfFile: url.path)!)
    }
}

// MARK: Private

private extension ClothesPreview {

    private func clothingImageUrl() -> URL {
        /// Get bundle for json localization
        let bundle = Bundle(for: ClothesPreview.self)

        /// Get url of preview picture
        guard let clothingImageUrl = bundle.url(forResource: "clothingImage", withExtension: "jpg") else {
            fatalError("Failed to get url of clothingImageUrl.jpg")
        }
        return clothingImageUrl
    }
}
