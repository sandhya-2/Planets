//
//  MockNetworkManager.swift
//  PlanetAppTests
//
//  Created by Sandiya on 11/05/2023.
//

import Foundation
@testable import PlanetApp

class MockNetworking: Networking {
    
    var mockData: Data!
    var mockResponse: URLResponse!
    var error: Error?
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if error != nil {
            throw error!
        }
        return (mockData, mockResponse)
    }
}
