//
//  TrainModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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
