//
//  Favorite.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 09/03/2025.
//

import Foundation
import SwiftData

@Model class Favorite {

    @Attribute(.unique) var clothingId: Int

    init(clothingId: Int) {
        self.clothingId = clothingId
    }
}
