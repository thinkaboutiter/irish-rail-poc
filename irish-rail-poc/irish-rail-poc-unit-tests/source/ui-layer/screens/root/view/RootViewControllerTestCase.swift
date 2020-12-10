//
//  RootViewControllerTestCase.swift
//  irish-rail-poc-unit-tests
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
@testable import irish_rail_poc

class RootViewControllerTestCase: XCTestCase {
    
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
        sut.loadViewIfNeeded()
        
        // then
        let child = sut.children.first
        XCTAssertNotNil(child)
        XCTAssertTrue(child! is UINavigationController)
    }
    
    func test_whenViewIsLoaded_callsMakeMapViewControllerAPI_onMapViewControllerFactory() {
        // given
        let exp = expectation(description: "MapViewControllerFactory.makeMapViewController() called")
        factory.on_makeMapViewController = {
            exp.fulfill()
        }
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_whenViewIsLoaded_embeddedNavigationController_hasMapViewController_asRootViewController() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        let child = sut.children.first
        let root = (child as? UINavigationController)?.viewControllers.first
        XCTAssertNotNil(root)
        XCTAssertTrue(root! is MapViewController)
    }
}

// MARK: - Subtypes
extension RootViewControllerTestCase {
    
    // MARK: - Map
    private class MockMapViewControllerFactory: AbstractMockMapViewControllerFactory {
        
        var on_makeMapViewController: (() -> Void)?
        override func makeMapViewController() -> MapViewController {
            defer {
                on_makeMapViewController?()
            }
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
