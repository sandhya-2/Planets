//
//  MockRespository.swift
//  PlanetAppTests
//
//  Created by Sandiya on 20/04/2023.
//

import Foundation
@testable import PlanetApp

class MockRepository: PlanetsListRepository {
        
    private var planets: [Planet] = []
    private var error: NetworkError?
    
    func getPlanets(for url: URL, completion: @escaping (Result<[PlanetApp.Planet], PlanetApp.NetworkError>) -> Void) {
        
        if error != nil {
            completion(.failure(error!))
            
        }else{
            completion(.success(planets))
        }
    }
    
    func setError(error:NetworkError){
        self.error = error
    }
    
    func setResponse(planets:[Planet]){
        self.planets = planets
    }
    
}
