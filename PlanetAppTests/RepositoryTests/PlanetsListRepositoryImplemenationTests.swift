//
//  PlanetsListRepositoryImplemenationTests.swift
//  PlanetAppTests
//
//  Created by Sandiya on 19/04/2023.
//

import XCTest
@testable import PlanetApp

final class PlanetsListRepositoryImplemenationTests: XCTestCase {

     private var mockRestAPIManager: MockRestAPIManager!
    
    @MainActor override func setUp() {
        mockRestAPIManager = MockRestAPIManager()
    }
    
    override func tearDown() {
        mockRestAPIManager = nil
    }

    // when networkManager return success data
    func testWhenGetPlanetsListSuccess() {
        // GIVEN
        let planetsRepository = PlanetsListRepositoryImplemenation(networkManager: MockRestAPIManager(),persistence: PersistenceController(inMemory: true))
        let expectation = XCTestExpectation(description: "Fetch planets list")
        
        // WHEN
        planetsRepository.getPlanets(for: URL(string: "PlanetsListResponseData")!) { result in
            // THEN
            switch result {
            case .success(let lists):
                XCTAssertEqual(lists.count, 10)
                XCTAssertTrue(lists.isEmpty == false)
                XCTAssertNotNil(lists)
            case .failure(let error):
                XCTAssertNil(error)
                XCTFail("Unexpected failure: \(error)")
            }
            expectation.fulfill()
        }
        
        // Wait for the asynchronous request to finish
        wait(for: [expectation], timeout: 2.0)
    }

    //     when fails, planets list data is not nil but when we don't get the data
    func testWhenGetPlanetsListWhenGetNoData() {
        // GIVEN
        
        let planetsRepository = PlanetsListRepositoryImplemenation(networkManager: MockRestAPIManager(),persistence: PersistenceController(inMemory: true))
        let expectation = XCTestExpectation(description: "Fetch planets but no data received")
        
        // WHEN
        planetsRepository.getPlanets(for: URL(string: "PlanetsListEmpty")!) { result in
            // THEN
            switch result {
            case .success(let lists):
                XCTAssertEqual(lists.count, 0)
                XCTAssertTrue(lists.isEmpty == true)
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.dataNotFound)
            }
            expectation.fulfill()
        }
        
        // Wait for the asynchronous request to finish
        wait(for: [expectation], timeout: 2.0)
    }

    //     when fails, planets list data is not nil and no data
    func testWhenGetPlanetsListFailsButDataIStoredLocally() {
        // GIVEN
        
        let planetsRepository = PlanetsListRepositoryImplemenation(networkManager: MockRestAPIManager(),persistence: PersistenceController(inMemory: true))
        let expectation = XCTestExpectation(description: "Fetch planets from API fails but data received that is stored locally ")
        
        //Just saving some data in database for testing
        planetsRepository.getPlanets(for: URL(string: "PlanetsListResponseData")!) { result in
            // THEN
            switch result {
            case .success(let lists):
                XCTAssertEqual(lists.count, 10)
                XCTAssertNotNil(lists)
            case .failure(let error):
                XCTAssertNil(error)
                XCTFail("Unexpected failure: \(error)")
            }
        }
        
        // WHEN
        planetsRepository.getPlanets(for: URL(string: "PlanetsListEmpty")!) { result in
            // THEN
            switch result {
            case .success(let lists):
                XCTAssertEqual(lists.count, 10)
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.dataNotFound)
            }
            expectation.fulfill()
        }
        
        // Wait for the asynchronous request to finish
        wait(for: [expectation], timeout: 2.0)
    }
   
   
}
