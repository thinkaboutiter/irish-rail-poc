//
//  AbstactMockTrainMovementRepository.swift
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

import Foundation
@testable import irish_rail_poc

class AbstactMockTrainMovementRepository: TrainMovementRepository {
    
    func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer) {
        fatalError("not implemented!")
    }
    
    func fetchTrainMovements(for trainCode: String,
                             trainDate: String,
                             usingCache: Bool)
    {
        fatalError("not implemented!")
    }
    
    func refresh() {
        fatalError("not implemented!")
    }
    
    func reset() {
        fatalError("not implemented!")
    }
    
    func trainMovements() throws -> [TrainMovement] {
        fatalError("not implemented!")
    }
    
    func filteredTrainMovements(by term: String) throws -> [TrainMovement] {
        fatalError("not implemented!")
    }
}
