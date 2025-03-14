//
//  HTTPClientPreview.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 14/03/2025.
//

import Foundation

class HTTPClientPreview: HTTPClient {

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: URL(string: "www.joifull-test.com")!,
            statusCode: 200, httpVersion: nil, headerFields: [:]
        )!
        try await Task.sleep(nanoseconds: 500_000_000)
        return (Data(), response)
    }
}
