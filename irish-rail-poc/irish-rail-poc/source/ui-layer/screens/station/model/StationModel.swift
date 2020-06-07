//
//  StationModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol StationModelConsumer: AnyObject {
    func didUpdateStationData(on viewModel: StationModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol StationModel: AnyObject {
    func setModelConsumer(_ newValue: StationModelConsumer)
    func station() -> Station
    func stationData() -> [StationData]
    func setStationData(_ newValue: [StationData])
}

class StationModelImpl: StationModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationModelConsumer!
    private let stationStorage: Station
    private var stationDataStorage: [StationData] = []
    
    // MARK: - Initialization
    init(station: Station) {
        self.stationStorage = station
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationModel protocol
    func setModelConsumer(_ newValue: StationModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func station() -> Station {
        return self.stationStorage
    }
    
    func stationData() -> [StationData] {
        return self.stationDataStorage
    }
    
    func setStationData(_ newValue: [StationData]) {
        self.stationDataStorage = newValue
        self.modelConsumer.didUpdateStationData(on: self)
    }
}
