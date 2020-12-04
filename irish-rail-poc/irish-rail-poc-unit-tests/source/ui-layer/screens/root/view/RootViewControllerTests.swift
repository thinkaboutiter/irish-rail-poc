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
    
    // MARK: - Properties
    private var sut: RootViewController!
    private var factory: MockMapViewControllerFactory!

    // MARK: - Life cycle
    override func setUpWithError() throws {
        factory = MockMapViewControllerFactory()
        sut = RootViewController(mapViewControllerFactory: factory)
    }

    override func tearDownWithError() throws {
        sut = nil
        factory = nil
    }

    // MARK: - Tests
    func test_whenViewIsLoaded_embedsNavigationController() {
        // when
        sut.viewDidLoad()
        
        // then
        let child = sut.children.first
        XCTAssertNotNil(child)
        XCTAssertTrue(child! is UINavigationController)
    }
    
    func test_whenViewIsLoaded_callsMakeMapViewControllerAPI_onMapViewControllerFactory() {
        // when
        sut.viewDidLoad()
        
        // then
        let apiDidCall = factory.didCall_makeMapViewController
        XCTAssertTrue(apiDidCall)
    }
    
    func test_whenViewIsLoaded_embeddedNavigationController_hasMapViewController_asRootViewController() {
        // when
        sut.viewDidLoad()
        
        // then
        let child = sut.children.first
        let root = (child as? UINavigationController)?.viewControllers.first
        XCTAssertNotNil(root)
        XCTAssertTrue(root! is MapViewController)
    }
}

// MARK: - Subtypes
extension RootViewControllerTests {
    
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
            let viewModel = DummyMapViewModel()
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
    
    private class DummyMapViewModel: AbstractMockMapViewModel {
        
        override func setViewModelConsumer(_ newValue: MapViewModelConsumer) {
            // NOOP
        }
    }
    
    // MARK: - Station
    private class DummyStationViewController: StationViewController {
        
        init() {
            let viewModel = DummyStationViewModel()
            super.init(
                viewModel: viewModel,
                makeTrainViewControllerWith: { _ in
                    return DummyTrainViewController()
                })
        }
    }
    
    private class DummyStationViewModel: AbstractMockStationViewModel {
                
        override func setViewModelConsumer(_ newValue: StationViewModelConsumer) {
            // NOOP
        }
    }
    
    // MARK: - Train
    private class DummyTrainViewController: TrainViewController {
        
        init() {
            let viewModel = DummyTrainViewModel()
            super.init(viewModel: viewModel)
        }
    }
    
    private class DummyTrainViewModel: AbstractMockTrainViewModel {
                
        override func setViewModelConsumer(_ newValue: TrainViewModelConsumer) {
            // NOOP
        }
    }
    
    // MARK: - StationsList
    private class DummyStationsListViewController: StationsListViewController {
        
        init() {
            let viewModel = DummyStationsListViewModel()
            super.init(
                viewModel: viewModel,
                makeStationViewControllerWith: { _ in
                    return DummyStationViewController()
                })
        }
    }
    
    private class DummyStationsListViewModel: AbstractMockStationsListViewModel {
                
        override func setViewModelConsumer(_ newValue: StationsListViewModelConsumer) {
            // NOOP
        }
    }
}