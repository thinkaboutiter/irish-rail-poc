//
//  TrainModelImplTestCase.swift
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

class TrainModelImplTestCase: XCTestCase {
    
    // MARK: - Properties
    private var sut: TrainModelImpl!
    private var consumer: MockTrainModelConsumer!

    // MARK: - Life cycle
    override func setUpWithError() throws {
        let stationData = StaticStationData.singleValue
        sut = TrainModelImpl(stationData: stationData)
        consumer = MockTrainModelConsumer()
        sut.setModelConsumer(consumer)
    }

    override func tearDownWithError() throws {
        consumer = nil
        sut = nil
    }
    
    // MARK: - Tests    
    func test_returnsCorrectTrainMovements() {
        // given
        let expectedMovements = StaticTrainMovement.responseCollectionValue
        
        // when
        sut.setTrainMovements(expectedMovements)
        
        // then
        let actualMovements = sut.trainMovements()
        let zipped = zip(expectedMovements, actualMovements)
        zipped.forEach { XCTAssertEqual($0, $1) }
    }
    
    func test_whenTrainMovementsAreSet_callsDidUpdateTrainMovementsAPIOnConsumer() {
        // given
        let givenMovements = StaticTrainMovement.responseCollectionValue
        let exp = expectation(
            description: "TrainModelConsumer.didUpdateTrainMovements(on:) API called")
        consumer.on_didUpdateTrainMovements = {
            exp.fulfill()
        }
        
        // when
        sut.setTrainMovements(givenMovements)
        
        // then
        waitForExpectations(timeout: 0.0)
    }
}

// MARK: - Subtypes
extension TrainModelImplTestCase {
    
    private class MockTrainModelConsumer: AbstractMockTrainModelConsumer {
        
        var on_didUpdateTrainMovements: (() -> Void)?
        override func didUpdateTrainMovements(on model: TrainModel) {
            on_didUpdateTrainMovements?()
        }
    }
}
