//
//  RootViewControllerTests.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-03-Dec-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import XCTest
@testable import irish_rail_poc

class RootViewControllerTests: XCTestCase {
    
    private var sut: RootViewController!
    private var viewModel: MockRootViewModel!
    private var mapViewControllerFactory: MockMapViewControllerFactory!

    override func setUpWithError() throws {
        viewModel = MockRootViewModel()
        mapViewControllerFactory = MockMapViewControllerFactory()
        sut = RootViewController(viewModel: viewModel,
                                 mapViewControllerFactory: mapViewControllerFactory)
    }

    override func tearDownWithError() throws {
        sut = nil
        mapViewControllerFactory = nil
        viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

// MARK: - Mocks

extension RootViewControllerTests {
    
    private class MockRootViewModel: AbstractMockRootViewModel {
        
        private(set) var didCall_setViewModelConsumer: Bool = false
        
        override func setViewModelConsumer(_ newValue: RootViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
        
    }
    
    private class MockMapViewControllerFactory: AbstractMockMapViewControllerFactory {
        
        private(set) var didCall_makeMapViewController: Bool = false
        
        override func makeMapViewController() -> MapViewController {
            didCall_makeMapViewController = true
            return MapViewController()
        }
    }
}
