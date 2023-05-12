//
//  MockRESTAPIManager.swift
//  PlanetAppTests
//
//  Created by Sandiya on 11/05/2023.
//

import Foundation
@testable import PlanetApp

class MockRestAPIManager: Networkable {
   
    func get(url: URL, completion: @escaping (Result<Data, PlanetApp.NetworkError>) -> Void) {
        do {
            let bundle = Bundle(for: MockRestAPIManager.self)
            guard let resourcePath =  bundle.url(forResource:url.absoluteString, withExtension: "json") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            let data = try Data(contentsOf: resourcePath)
            completion(.success(data))
            
        } catch {
            completion(.failure(.dataNotFound))
        }
    }
}


