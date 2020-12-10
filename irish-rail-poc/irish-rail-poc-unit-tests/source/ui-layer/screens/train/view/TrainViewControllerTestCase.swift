//
//  TrainViewControllerTestCase.swift
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

extension TrainViewController: ValueProvidable {}

extension TrainViewControllerTestCase {
    
    private enum Constants {
        enum Label {
            static let searchController = "$__lazy_storage_$_searchController"
            static let collectionView = "trainMovementsCollectionView"
        }
        enum Title {
            static let close = "Close"
        }
    }
}

class TrainViewControllerTestCase: XCTestCase {
    
    // MARK: - properties
    private var sut: TrainViewController!
    private var viewModel: MockTrainViewModel!

    // MARK: - Life cycle
    override func setUpWithError() throws {
        viewModel = MockTrainViewModel()
        sut = TrainViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
    }
    
    // MARK: - Tests
    func test_whenSUTIsInitialized_callsSetViewModelConsumerAPIOnViewModel_andSetItslefAsViewModelConsumer() {
        // given
        /// resetting `sut` since we are interested in its initalization sequence
        sut = nil
        var expectedConsumer: TrainViewModelConsumer?
        let exp = expectation(description: "TrainViewModel.setViewModelConsumer(_:) API is called")
        viewModel.on_setViewModelConsumer = { consumer in
            expectedConsumer = consumer
            exp.fulfill()
        }
        
        // when
        sut = TrainViewController(viewModel: viewModel)
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertTrue(sut === expectedConsumer)
    }
    
    func test_viewDidLoad_createsSearchController_andSetsAsItsSearchResultUpdater() {
        // given
        sut.loadViewIfNeeded()
        
        // when
        sut.viewDidLoad()
        
        // then
        let searchController: UISearchController? = sut.value(forLabel: Constants.Label.searchController)
        XCTAssertNotNil(searchController)
        XCTAssertTrue(sut === searchController?.searchResultsUpdater)
    }
    
    func test_viewDidLoad_callsFetchTrainMovementsOnViewModel() {
        // given
        let exp = expectation(description: "TrainViewModel.fetchTrainMovements() API is called")
        viewModel.on_fetchTrainMovements = {
            exp.fulfill()
        }
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_viewDidLoad_configureNavigationBarRightBarButtonItem() {
        // given
        let rootViewController = UIViewController()
        UIApplication.shared.windows.first?.rootViewController = rootViewController
        
        // when
        /// right bar button item should be configured only if sut or its
        /// navigation controller have been presented modally
        rootViewController.present(sut, animated: false, completion: nil)
        
        // then
        let barButtonItem = sut.navigationItem.rightBarButtonItem
        XCTAssertNotNil(barButtonItem)
        XCTAssertEqual(barButtonItem?.title, Constants.Title.close)
    }
    
    func test_didFinishFetchingTrainMovements_reloadsCollectionView() {
        // given
        sut.loadViewIfNeeded()
        let mock = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        let exp = expectation(description: "MockCollectionView.reloadData() API is called")
        mock.on_reloadData = {
            exp.fulfill()
        }
        sut.trainMovementsCollectionView = mock

        // when
        sut.didFinishFetchingTrainMovements(on: viewModel)

        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_didFailFetchingTrainMovements_showsNoContentView_whenThereAreNoItemsToBeDisplayed() {
        // given
        viewModel.shouldFailFetching = true
        viewModel.shouldReturnEmptyItemsCollection = true
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        let noContentView = sut.view.subviews.last
        XCTAssertTrue(noContentView is NoContentView)
        XCTAssertTrue(noContentView?.superview === sut.view)
    }
    
    func test_didFailFetchingTrainMovements_showsAlertWithCorrectError() {
        // given
        let error = viewModel.failureError
        let expectedMessage = error.localizedDescription
        
        // when
        UIApplication.shared.windows.first?.rootViewController = sut        
        sut.didFailFetchingTrainMovements(on: viewModel, error: error)
        
        // then
        let presentedViewController = sut.presentedViewController
        XCTAssertTrue(presentedViewController is UIAlertController)
        let actualMessage = (presentedViewController as? UIAlertController)?.message
        XCTAssertEqual(expectedMessage, actualMessage)
    }
    
    func test_willPresentSearchController_raisesFlagForDisplayingSearchResultsOnViewModel_andReloadsCollectionView() {
        // given
        sut.loadViewIfNeeded()
        
        let mockCollectioView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        let exp_collectionView = expectation(description: "MockCollectionView.reloadData() API is called")
        mockCollectioView.on_reloadData = {
            exp_collectionView.fulfill()
        }
        sut.trainMovementsCollectionView = mockCollectioView
        
        var displayingSearchResults: Bool?
        let exp_viewModel = expectation(description: "TrainViewModel.setDisplayingSearchResults(_:) API called")
        viewModel.on_setDisplayingSearchResults = { value in
            displayingSearchResults = value
            exp_viewModel.fulfill()
        }
        
        // when
        sut.willPresentSearchController(MockSearchController())
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertTrue(displayingSearchResults ?? false)
    }
    
    func test_willDismissSearchController_dropsFlagForDisplayingSearchResultsOnViewModel_andReloadsCollectionView() {
        // given
        sut.loadViewIfNeeded()
        
        let mockCollectioView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        let exp_collectionView = expectation(description: "MockCollectionView.reloadData() API is called")
        mockCollectioView.on_reloadData = {
            exp_collectionView.fulfill()
        }
        sut.trainMovementsCollectionView = mockCollectioView
        
        var displayingSearchResults: Bool?
        let exp_viewModel = expectation(description: "TrainViewModel.setDisplayingSearchResults(_:) API called")
        viewModel.on_setDisplayingSearchResults = { value in
            displayingSearchResults = value
            exp_viewModel.fulfill()
        }
        
        // when
        sut.willDismissSearchController(MockSearchController())
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertFalse(displayingSearchResults ?? true)
    }
    
    func test_updateSearchResults_setsSearchTermOnViewModel_andReloadsCollectionView() {
        // given
        sut.loadViewIfNeeded()
        
        let mockCollectioView = MockCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        let exp_collectionView = expectation(description: "MockCollectionView.reloadData() API is called")
        mockCollectioView.on_reloadData = {
            exp_collectionView.fulfill()
        }
        sut.trainMovementsCollectionView = mockCollectioView
        
        let mockSearchController = MockSearchController()
        let expectedSearchTerm = "hello"
        mockSearchController.searchTerm = expectedSearchTerm
        
        var actualSearchTerm: String?
        let exp_viewModel = expectation(description: "TrainViewModel.setSearchTerm(_:) API called")
        viewModel.on_setSearchTerm = { value in
            actualSearchTerm = value
            exp_viewModel.fulfill()
        }
        
        // when
        sut.updateSearchResults(for: mockSearchController)
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertEqual(expectedSearchTerm, actualSearchTerm)
    }
    
    func test_collectionViewRegistersTrainMovementCollectionViewCell() {
        // when
        sut.loadViewIfNeeded()
        let identifier = TrainMovementCollectionViewCell.identifier
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.trainMovementsCollectionView
            .dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        // then
        XCTAssertTrue(cell is TrainMovementCollectionViewCell)
    }
    
    func test_whenCollectionViewReturnsCells_theyAreConfiguredWithProperData() {
        // when
        sut.loadViewIfNeeded()
        let items = viewModel.items()
        let count = items.count
        let cells = (0 ..< count).compactMap
        { (index: Int) -> TrainMovementCollectionViewCell? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = sut.collectionView(sut.trainMovementsCollectionView,
                                          cellForItemAt: indexPath) as? TrainMovementCollectionViewCell
            return cell
        }
        
        // then
        let zipped = zip(cells, items)
        zipped.forEach() { XCTAssertEqual($0.trainMovement, $1)}
    }
}

// MARK: - Subtypes
extension TrainViewControllerTestCase {
    
    private class MockTrainViewModel: AbstractMockTrainViewModel {
        private weak var consumer: TrainViewModelConsumer?
        private var displayingSearchResults = false
        private var searchTerm = ""
        var shouldReturnEmptyItemsCollection = false
        var shouldFailFetching = false
        var failureError = ErrorCreator.generic.error()
        
        var on_setViewModelConsumer: ((TrainViewModelConsumer) -> Void)?
        override func setViewModelConsumer(_ newValue: TrainViewModelConsumer) {
            consumer = newValue
            on_setViewModelConsumer?(consumer!)
        }
        
        var on_fetchTrainMovements: (() -> Void)?
        override func fetchTrainMovements() {
            if shouldFailFetching {
                consumer?.didFailFetchingTrainMovements(on: self, error: failureError)
            }
            else {
                consumer?.didFinishFetchingTrainMovements(on: self)
            }
            on_fetchTrainMovements?()
        }
        
        var on_cancelTrainMovementsFetching: (() -> Void)?
        override func cancelTrainMovementsFetching() {
            on_cancelTrainMovementsFetching?()
        }
        
        var on_items: (() -> Void)?
        override func items() -> [TrainMovement] {
            defer {
                on_items?()
            }
            let result = shouldReturnEmptyItemsCollection
                ? []
                : StaticTrainMovement.responseCollectionValue
            return result
        }
        
        var on_item: ((IndexPath) -> Void)?
        override func item(at indexPath: IndexPath) -> TrainMovement? {
            defer {
                on_item?(indexPath)
            }
            let index = indexPath.item
            let trainMovements = items()
            let result = trainMovements[safeAt: index]
            return result
        }
        
        var on_stationData: (() -> Void)?
        override func stationData() -> StationData {
            defer {
                on_stationData?()
            }
            let result = StaticStationData.singleValue
            return result
        }
        
        var on_isDisplayingSearchResults: (() -> Void)?
        override func isDisplayingSearchResults() -> Bool {
            defer {
                on_isDisplayingSearchResults?()
            }
            return displayingSearchResults
        }
        
        var on_setDisplayingSearchResults: ((Bool) -> Void)?
        override func setDisplayingSearchResults(_ newValue: Bool) {
            displayingSearchResults = newValue
            on_setDisplayingSearchResults?(displayingSearchResults)
        }
        
        var on_getSearchTerm: (() -> Void)?
        override func getSearchTerm() -> String {
            defer {
                on_getSearchTerm?()
            }
            return searchTerm
        }
        
        var on_setSearchTerm: ((String) -> Void)?
        override func setSearchTerm(_ newValue: String) {
            searchTerm = newValue
            on_setSearchTerm?(searchTerm)
        }
    }
    
    private class MockCollectionView: TrainMovementsCollectionView {
        var on_reloadData: (() -> Void)?
        override func reloadData() {
            on_reloadData?()
        }
    }
    
    private class MockSearchController: UISearchController {
        var searchTerm = ""
        
        override var searchBar: UISearchBar {
            let result = UISearchBar()
            result.text = searchTerm
            return result
        }
    }
}
