//
//  Endpoint.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/03/2025.
//

import Foundation

enum Endpoint {

    case getClothes
    case postReview
    case postLike

    var url: URL? {
        let baseURL = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/"
        let apiEndpoint = "Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api"

        switch self {
        case .getClothes:
            return URL(string: "\(baseURL)\(apiEndpoint)/clothes.json")
        case .postReview:
            return URL(string: "\(baseURL)\(apiEndpoint)/review")
        case .postLike:
            return URL(string: "\(baseURL)\(apiEndpoint)/like")
        }
    }
}
