//
//  RequestBuilder.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 27/02/2025.
//

import Foundation

class RequestBuilder {

    enum Method: String {
        case get = "GET"
        case post = "POST"
    }

    func build(httpMethod: Method, url: URL?, httpBody: [String: Any]? = nil) throws -> URLRequest {
        /// Build URL
        guard let url = url else {
            throw URLError(.badURL)
        }
        /// Build request
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = httpMethod.rawValue

        /// Accept only JSON as response
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        /// HTTP Body
        if httpMethod == .post, let body = httpBody {
            /// Indicate that will send  json
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            /// Add json to http body
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        return request
    }
}
