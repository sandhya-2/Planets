//
//  PlanetViewModel.swift
//  PlanetApp
//
//  Created by Sandiya on 18/04/2023.
//

import Foundation
import CoreData

@MainActor
class PlanetViewModel:ObservableObject {
    
    @Published var planetList: [Planet] = []
    @Published var customError: NetworkError?
    
    //this dependency injection method = dependency of networkable protocol
    
    private let repository: PlanetsListRepository
   
    init(repository: PlanetsListRepository) {
        self.repository = repository
    }
          
}

extension PlanetViewModel: PlanetListUseCase {
    /**
        Get the list of planet by sending urlString
       @ Parameters: urlString of type string
       @ Returns:
     */
        
    func getDataForPlanets(urlString: String) async {
        guard let url = URL(string: urlString) else{
                self.customError = NetworkError.invalidURL
            return
        }
        repository.getPlanets(for: url) { [weak self] reuslt in
            DispatchQueue.main.async {
                switch reuslt {
                case .success(let planets):
                        self?.planetList = planets
                        self?.customError = nil
                case .failure(let error):
                        self?.customError = error
                }
            }
        }
    }
}
