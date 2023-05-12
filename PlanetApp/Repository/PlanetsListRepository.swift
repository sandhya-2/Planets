//
//  PlanetsListRepository.swift
//  PlanetApp
//
//  Created by Sandiya on 10/05/2023.
//

import Foundation
import CoreData

protocol PlanetsListRepository {
    func getPlanets(for url: URL, completion:@escaping(Result<[Planet], NetworkError>)-> Void)
}
protocol PlanetListUseCase {
    func getDataForPlanets(urlString: String) async
}
