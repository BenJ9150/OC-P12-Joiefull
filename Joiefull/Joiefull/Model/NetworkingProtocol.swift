//
//  NetworkingProtocol.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 17/01/2025.
//

import Foundation

protocol Networking {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: Networking {}
