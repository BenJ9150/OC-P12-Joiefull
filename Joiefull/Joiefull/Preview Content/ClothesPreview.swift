//
//  ClothesPreview.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 31/01/2025.
//

import SwiftUI

class ClothesPreview {

    func getClothing() -> Clothing {
        guard let clothing = getClothes().first else {
            fatalError("Failed to load first clothin of clothesPreview.json")
        }
        return clothing
    }

    func getClothes() -> [Clothing] {
        // Get bundle for json localization
        let bundle = Bundle(for: ClothesPreview.self)

        // Get url of clothesPreview json
        guard let clothesPreviewUrl = bundle.url(forResource: "clothesPreview", withExtension: "json") else {
            fatalError("Failed to get url of clothesPreview.json")
        }
        // Get url of preview picture
        guard let clothingImageUrl = bundle.url(forResource: "clothingImage", withExtension: "jpg") else {
            fatalError("Failed to get url of clothingImageUrl.jpg")
        }

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
}
