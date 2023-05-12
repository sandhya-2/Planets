//
//  PlanetsListRepository.swift
//  PlanetApp
//
//  Created by Sandiya on 10/05/2023.
//

import Foundation
import CoreData

class PlanetsListRepositoryImplemenation {
    
    private var networkManager: Networkable
    private let persistence: PersistenceController
    
    init(networkManager: Networkable, persistence: PersistenceController = .shared){
        self.networkManager = networkManager
        self.persistence =  persistence
    }
    
    private func getPlanetResponseFromApi(for url: URL, hasOfflineData: Bool,  completion:@escaping(Result<[Planet], NetworkError>)-> Void)  {
        networkManager.get(url: url) { result in
            switch result {
            case .success( let data ):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let planetData = try decoder.decode(PlanetResponse.self, from: data)
                   
                    
                    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateContext.persistentStoreCoordinator = self.persistence.persistentStoreCoordinator

                    Task{
                        // Perform operations in the private context
                        try await privateContext.perform {
                           
                            try PlanetObjectEntity.insertEPlanet(planets:planetData.results , moc: privateContext)
                            DispatchQueue.main.async {
                                completion(.success(planetData.results))
                            }
                        }
                    }
                }catch {
                    if !hasOfflineData {
                        completion(.failure(.dataNotFound))
                    }
                }
            case .failure(_):
                if !hasOfflineData {
                    completion(.failure(.dataNotFound))
                }
            }
        }
    }
    
    private func getPlanetsFromOfflineStorage()async -> [Planet] {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = self.persistence.persistentStoreCoordinator
            // Perform operations in the private context
        return await privateContext.perform {
                let ePlanets = PlanetObjectEntity.fetchAllPlanets(moc: privateContext)
                // Mapping core data entity to model (PlanetObjectEntity to Planet)
                return ePlanets.map { $0.toPlanet() }
            }
    }
}
    /**
        Get the data from the API,  if not then get the data from the CoreData
       @ Parameters: url as URL
       @ Returns: Planet response from the API
     */
    
extension PlanetsListRepositoryImplemenation: PlanetsListRepository {
    func getPlanets(for url: URL, completion:@escaping(Result<[Planet], NetworkError>)-> Void) {
        
        Task{
            let planets = await getPlanetsFromOfflineStorage()
             getPlanetResponseFromApi(for: url,hasOfflineData: !planets.isEmpty , completion: completion)
            
             if !planets.isEmpty {
                 completion(.success(planets))
             }
        }
       
    }
}
