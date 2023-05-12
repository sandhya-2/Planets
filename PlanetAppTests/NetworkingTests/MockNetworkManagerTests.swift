//
//  MockNetworkManagerTests.swift
//  PlanetAppTests
//
//  Created by Sandiya on 19/04/2023.
//

import XCTest
@testable import PlanetApp

final class MockNetworkManagerTests: XCTestCase {

    var mockNetworking: MockNetworking!
    var networkManager: NetworkManager!
    
    @MainActor override func setUp() {
        mockNetworking = MockNetworking()
        networkManager = NetworkManager(urlSession: mockNetworking)
    }

    override func tearDown() {
        mockNetworking = nil
        networkManager = nil
    }

    /*when API is successful, get function will return expected data*/
    func testGetPlanentsWhenResponseIs_200() {
        
        // GIVEN
         let actualData = "response".data(using: .utf8)
        mockNetworking.mockData = actualData
        mockNetworking.mockResponse = HTTPURLResponse(url:URL(string: "test")!, statusCode: 200, httpVersion:nil, headerFields:nil)
        
        // When
        networkManager.get(url: URL(string: "testURl")!, completion: { result in
            switch result{
            case .success(let data):
                // Then
                XCTAssertEqual(actualData, data)

            case .failure(let error):
                XCTAssertNotNil(error)

            }
        })
        
    }
    
    /*when API is fails with status code 404 */
    func testGetPlanetsWhenAPIFailsToReturnExpectedData() {

        // Given
         let actualData = "response".data(using: .utf8)
        mockNetworking.mockData = actualData
        mockNetworking.mockResponse = HTTPURLResponse(url:URL(string: "test")!, statusCode: 404, httpVersion:nil, headerFields:nil)
        
        networkManager.get(url: URL(string: "testURl")!, completion: { result in
            switch result{
            case .success(let data):
                // Then
                XCTAssertNil(data)

            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, NetworkError.invalidURL)

            }
        })
    }
    
    /*when API is fails with request invalid*/
    func testPlanetsWhenRequestIsInValidAndYouDontGetData() {
        
        networkManager.get(url: URL(string: "someWrongURL")!, completion: { result in
            switch result{
            case .success(let data):
                // Then
                XCTAssertNil(data)

            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, NetworkError.dataNotFound)

            }
        })
    }

}
