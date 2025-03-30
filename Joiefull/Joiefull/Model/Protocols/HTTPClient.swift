//
//  HTTPClient.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}
