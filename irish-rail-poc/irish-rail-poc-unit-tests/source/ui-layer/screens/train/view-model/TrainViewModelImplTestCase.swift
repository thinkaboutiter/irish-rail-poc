//
//  TrainViewModelImplTestCase.swift
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

class TrainViewModelImplTestCase: XCTestCase {
    
    // MARK: - Properties
    private var sut: TrainViewModelImpl!
    private var model: MockTrainModel!
    private var repository: MockTrainMovementRepository!
    private var consumer: MockTrainViewModelConsumer!
    
    // MARK: - Life cycle
    override func setUpWithError() throws {
        repository = MockTrainMovementRepository()
        model = MockTrainModel()
        consumer = MockTrainViewModelConsumer()
        sut = TrainViewModelImpl(model: model,
                                 repository: repository)
        sut.setViewModelConsumer(consumer)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        consumer = nil
        model = nil
        repository = nil
    }
    
    // MARK: - Tests
    func test_onInitialization_sutSetsItselfAsConsumerOnBothModelAndRepository() {
        // given
        // resetting `sut` since we are interested in its initalization sequence
        sut = nil
        
        let exp_model = expectation(
            description: "TrainModel.setModelConsumer(_:) API called")
        model.on_setModelConsumer = {
            exp_model.fulfill()
        }
        
        let exp_repository = expectation(
            description: "TrainMovementRepository.setRepositoryConsumer(_:) API called")
        repository.on_setRepositoryConsumer = {
            exp_repository.fulfill()
        }
        
        // when
        sut = TrainViewModelImpl(model: model,
                                 repository: repository)
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertTrue(sut === model.consumer)
        XCTAssertTrue(sut === repository.consumer)
    }
    
    func test_whenFetchTrainMovementsAPIIsCalled_callsResetAPIOnRepository() {
        // given
        let exp = expectation(description: "TrainMovementRepository.reset() API called")
        repository.on_reset = {
            exp.fulfill()
        }
        
        // when
        sut.fetchTrainMovements()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_whenFetchTrainMovementsAPIIsCalled_callsStationDataAPIOnModel() {
        // given
        let exp = expectation(description: "TrainModel.stationData() API called")
        model.on_stationData = {
            exp.fulfill()
        }
        
        // when
        sut.fetchTrainMovements()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_whenFetchTrainMovementsAPIIsCalled_callsFetchTrainMovementAPIOnRepository() {
        // given
        let exp = expectation(description: "TrainMovementRepository.fetchTrainMovement(for:trainDate:usingCache:) API called")
        repository.on_fetchTrainMovement = {
            exp.fulfill()
        }
        
        // when
        sut.fetchTrainMovements()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_whenCancelTrainMovementsFetchingAPIIsCalled_callsResetAPIOnRepository() {
        // given
        let exp = expectation(description: "TrainMovementRepository.reset() API called")
        repository.on_reset = {
            exp.fulfill()
        }
        
        // when
        sut.cancelTrainMovementsFetching()
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_stationDataThatSUTsProvides_isEqualToTheOneThatItsModelHas() {
        // given
        let expectedStationData = model.stationData()
        
        let exp = expectation(description: "TrainModel.stationData() API called")
        model.on_stationData = {
            exp.fulfill()
        }
        
        // when
        let actualStationData = sut.stationData()
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertEqual(expectedStationData, actualStationData)
    }
    
    func test_trainMovementsThatSUTProvides_correspodToTrainMovementsThatSUTHasFetched() throws {
        // given
        let expectedTrainMovements = try repository.trainMovements()
        
        let exp_repository_trainMovements = expectation(description: "TrainMovementRepository.trainMovements() API called")
        repository.on_trainMovements = {
            exp_repository_trainMovements.fulfill()
        }
        
        let exp_model_setTrainMovements = expectation(description: "TrainModel.setTrainMovements(_:) API called")
        model.on_setTrainMovements = {
            exp_model_setTrainMovements.fulfill()
        }
        
        let exp_model_trainMovements = expectation(description: "TrainModel.trainMovements() API called")
        model.on_trainMovements = {
            exp_model_trainMovements.fulfill()
        }
        
        // when
        sut.fetchTrainMovements()
        let actualTrainMovements = sut.items()
        
        // then
        waitForExpectations(timeout: 0.0)
        let zipped = zip(expectedTrainMovements, actualTrainMovements)
        zipped.forEach() { XCTAssertEqual($0, $1) }
    }
    
    func test_whenSUTIsDisplayingSearchResults_trainMovementsThatSUTProvidesForGivenSearchTerm_correspondToFilteredTrainMovementsFromRepositoryForTheSameSearchTerm() throws {
        // given
        sut.setDisplayingSearchResults(true)
        let expectedSearchTerm = "hello"
        let expectedTrainMovements = try repository.filteredTrainMovements(by: expectedSearchTerm)
        
        var actualSearchTerm: String = ""
        let exp = expectation(description: "TrainMovementRepository.filteredTrainMovements(by:) API called")
        repository.on_filteredTrainMovements = { term in
            actualSearchTerm = term
            exp.fulfill()
        }
        
        // when
        sut.setSearchTerm(expectedSearchTerm)
        let actualTrainMovements = sut.items()
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertEqual(expectedSearchTerm, actualSearchTerm)
        let zipped = zip(expectedTrainMovements, actualTrainMovements)
        zipped.forEach() { XCTAssertEqual($0, $1) }
    }
    
    func test_tainMovementForIndexPathReturnsCorrectValue() throws {
        // given
        let trainMovements = try repository.trainMovements()
        let index = (0..<trainMovements.count).randomElement() ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        let expectedElement = trainMovements[index]
        
        // when
        sut.fetchTrainMovements()
        let actualElement = sut.item(at: indexPath)
        
        // then
        XCTAssertEqual(expectedElement, actualElement)
    }
    
    func test_whenIndexPathIsOutOfBounds_tainMovementForIndexPathReturnsNilValue() throws {
        // given
        let trainMovements = try repository.trainMovements()
        let index = trainMovements.count
        let indexPath = IndexPath(row: index, section: 0)
        
        // when
        sut.fetchTrainMovements()
        let actualElement = sut.item(at: indexPath)
        
        // then
        XCTAssertNil(actualElement)
    }
    
    func test_whenDidUpdateTrainMovementsAPIIsCalled_callsDidFinishFetchingTrainMovementsAPIOnConsumer() {
        // given
        let exp = expectation(description: "TrainViewModelConsumer.didFinishFetchingTrainMovements(on:) API called")
        consumer.on_didFinishFetchingTrainMovements = {
            exp.fulfill()
        }
        
        // when
        sut.didUpdateTrainMovements(on: model)
        
        // then
        waitForExpectations(timeout: 0.0)
    }
    
    func test_whenDidFailToFetchTrainMovementsAPIIsCalled_callsDidFailFetchingTrainMovementsAPIOnConsumer_withCorrecError() {
        // given
        let expectedError = ErrorCreator.generic.error()
        let exp = expectation(description: "TrainViewModelConsumer.didFailFetchingTrainMovements(on:error:) API called")
        var actualError: NSError?
        consumer.on_didFailFetchingTrainMovements = { error in
            actualError = error as NSError
            exp.fulfill()
        }
        
        // when
        sut.didFailToFetchTrainMovements(on: repository, with: expectedError)
        
        // then
        waitForExpectations(timeout: 0.0)
        XCTAssertEqual(expectedError, actualError)
    }
}

// MARK: - Subtypes
extension TrainViewModelImplTestCase {
    
    private class MockTrainModel: AbstractMockTrainModel {
        
        private(set) weak var consumer: TrainModelConsumer?
        private var trainMovements_storage: [TrainMovement] = []
        
        var on_setModelConsumer: (() -> Void)?
        override func setModelConsumer(_ newValue: TrainModelConsumer) {
            consumer = newValue
            on_setModelConsumer?()
        }
        
        var on_stationData: (() -> Void)?
        override func stationData() -> StationData {
            defer {
                on_stationData?()
            }
            return StaticStationData.singleValue
        }
        
        var on_setTrainMovements: (() -> Void)?
        override func setTrainMovements(_ newValue: [TrainMovement]) {
            trainMovements_storage = newValue
            consumer?.didUpdateTrainMovements(on: self)
            on_setTrainMovements?()
        }
        
        var on_trainMovements: (() -> Void)?
        override func trainMovements() -> [TrainMovement] {
            defer {
                on_trainMovements?()
            }
            return trainMovements_storage
        }
    }
    
    private class MockTrainMovementRepository: AbstactMockTrainMovementRepository {
        
        private(set) weak var consumer: TrainMovementRepositoryConsumer?
        
        var on_setRepositoryConsumer: (() -> Void)?
        override func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer) {
            consumer = newValue
            on_setRepositoryConsumer?()
        }
        
        var on_reset: (() -> Void)?
        override func reset() {
            on_reset?()
        }
        
        var on_fetchTrainMovement: (() -> Void)?
        override func fetchTrainMovements(for trainCode: String,
                                          trainDate: String,
                                          usingCache: Bool)
        {
            consumer?.didFetchTrainMovements(on: self)
            on_fetchTrainMovement?()
        }
        
        var on_trainMovements: (() -> Void)?
        override func trainMovements() throws -> [TrainMovement] {
            defer {
                on_trainMovements?()
            }
            let result = StaticTrainMovement.responseCollectionValue
            return result
        }
        
        var on_filteredTrainMovements: ((String) -> Void)?
        override func filteredTrainMovements(by term: String) throws -> [TrainMovement] {
            defer {
                on_filteredTrainMovements?(term)
            }
            let result = [StaticTrainMovement.singleValue]
            return result
        }
    }
    
    private class MockTrainViewModelConsumer: AbstractMockTrainViewModelConsumer {
        
        var on_didFinishFetchingTrainMovements: (() -> Void)?
        override func didFinishFetchingTrainMovements(on viewModel: TrainViewModel) {
            on_didFinishFetchingTrainMovements?()
        }
        
        var on_didFailFetchingTrainMovements: ((Error) -> Void)?
        override func didFailFetchingTrainMovements(on viewModel: TrainViewModel,
                                                    error: Error)
        {
            on_didFailFetchingTrainMovements?(error)
        }
    }
}
