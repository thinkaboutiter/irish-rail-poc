//
//  TrainModel.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol TrainModelConsumer: AnyObject {
    func didUpdateTrainMovements(on viewModel: TrainModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol TrainModel: AnyObject {
    func setModelConsumer(_ newValue: TrainModelConsumer)
    func stationData() -> StationData
    func trainMovements() -> [TrainMovement]
    func setTrainMovements(_ newValue: [TrainMovement])
}

class TrainModelImpl: TrainModel {
    
    // MARK: - Properties
    private weak var modelConsumer: TrainModelConsumer!
    private let stationDataStorage: StationData
    private var trainMovementsStorage: [TrainMovement] = []
    
    // MARK: - Initialization
    init(stationData: StationData) {
        self.stationDataStorage = stationData
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - TrainModel protocol
    func setModelConsumer(_ newValue: TrainModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func stationData() -> StationData {
        return self.stationDataStorage
    }
    
    func trainMovements() -> [TrainMovement] {
        if self.isUsingStubData {
            return self.stubData()
        }
        else {
            return self.trainMovementsStorage
        }
    }
    
    func setTrainMovements(_ newValue: [TrainMovement]) {
        self.trainMovementsStorage = newValue
        self.modelConsumer.didUpdateTrainMovements(on: self)
    }
}

// MARK: - Stub data
private extension TrainModelImpl {
    private var isUsingStubData: Bool {
        return false
    }
    
    func stubData() -> [TrainMovement] {
        let data: TrainMovement = TrainMovement(trainCode: "E109",
                                                trainDate: "08 Jun 2020",
                                                locationCode: "SUTTN",
                                                locationFullName: "Sutton",
                                                locationOrder: 2,
                                                locationType: "S",
                                                trainOrigin: "Howth",
                                                trainDestination: "Greystones",
                                                scheduledArrival: "10:03:30",
                                                scheduledDeparture: "10:04:00",
                                                expectedArrival: "10:04:18",
                                                expectedDeparture: "10:03:24",
                                                stopType: "-")
        let result: [TrainMovement] = Array<TrainMovement>.init(repeating: data, count: 20)
        return result
    }
}
