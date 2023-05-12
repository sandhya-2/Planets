//
//  NetworkManager.swift
//  PlanetApp
//
//  Created by Sandiya on 10/05/2023.
//

import Foundation

protocol Networkable {
    func get(url: URL, completion:@escaping(Result<Data, NetworkError>)-> Void)
}

struct NetworkManager {
    let urlSession: Networking
    init(urlSession: Networking = URLSession.shared) {
        self.urlSession = urlSession
    }
}

extension NetworkManager: Networkable {
    /**
        Get the data from the API using URLSession
       @ Parameters: url of type URL
        completion: ('Result<Data, NetworkError>')
       @ Returns:
     */
    
    func get(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data , error == nil else {
                completion(.failure(NetworkError.dataNotFound))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
