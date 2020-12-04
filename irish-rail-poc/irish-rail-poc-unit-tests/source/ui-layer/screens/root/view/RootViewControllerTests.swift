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

// MARK: - Subtypes
extension RootViewControllerTests {
    
    private class MockRootViewModel: AbstractMockRootViewModel {
        
        private(set) var didCall_setViewModelConsumer = false
        
        override func setViewModelConsumer(_ newValue: RootViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
    }
    
    // MARK: - Map
    private class MockMapViewControllerFactory: AbstractMockMapViewControllerFactory {
        
        private(set) var didCall_makeMapViewController = false
        
        override func makeMapViewController() -> MapViewController {
            didCall_makeMapViewController = true
            let result = DummyMapViewController()
            return result
        }
    }
    
    private class DummyMapViewController: MapViewController {
        
        init() {
            let viewModel = MockMapViewModel()
            super.init(
                viewModel: viewModel,
                makeStationViewControllerWith: { _ in
                    return DummyStationViewController()
                },
                makeStationsListViewController: {
                    return DummyStationsListViewController()
                })
        }
    }
    
    private class MockMapViewModel: AbstractMockMapViewModel {
        private(set) var didCall_setViewModelConsumer = false
        
        override func setViewModelConsumer(_ newValue: MapViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
    }
    
    // MARK: - Station
    private class DummyStationViewController: StationViewController {
        
        init() {
            let viewModel = MockStationViewModel()
            super.init(
                viewModel: viewModel,
                makeTrainViewControllerWith: { _ in
                    return DummyTrainViewController()
                })
        }
    }
    
    private class MockStationViewModel: AbstractMockStationViewModel {
        
        private(set) var didCall_setViewModelConsumer = false
        
        override func setViewModelConsumer(_ newValue: StationViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
    }
    
    // MARK: - Train
    private class DummyTrainViewController: TrainViewController {
        
        init() {
            let viewModel = MockTrainViewModel()
            super.init(viewModel: viewModel)
        }
    }
    
    private class MockTrainViewModel: AbstractMockTrainViewModel {
        
        private(set) var didCall_setViewModelConsumer = false
        
        override func setViewModelConsumer(_ newValue: TrainViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
    }
    
    // MARK: - StationsList
    private class DummyStationsListViewController: StationsListViewController {
        
        init() {
            let viewModel = MockStationsListViewModel()
            super.init(
                viewModel: viewModel,
                makeStationViewControllerWith: { _ in
                    return DummyStationViewController()
                })
        }
    }
    
    private class MockStationsListViewModel: AbstractMockStationsListViewModel {
        
        private(set) var didCall_setViewModelConsumer = false
        
        override func setViewModelConsumer(_ newValue: StationsListViewModelConsumer) {
            didCall_setViewModelConsumer = true
        }
    }
}
