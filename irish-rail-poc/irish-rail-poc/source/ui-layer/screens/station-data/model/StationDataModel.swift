//
//  StationDataModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol StationDataModelConsumer: AnyObject {}

/// APIs for `Model` to expose to `ViewModel`
protocol StationDataModel: AnyObject {
    func setModelConsumer(_ newValue: StationDataModelConsumer)
    func stationCode() -> String
    func stationData() -> [StationData]
}

class StationDataModelImpl: StationDataModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationDataModelConsumer!
    private let stationCodeStorage: String
    private var stationDataStorage: [StationData] = []
    
    // MARK: - Initialization
    init(stationCode: String) {
        self.stationCodeStorage = stationCode
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataModel protocol
    func setModelConsumer(_ newValue: StationDataModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func stationCode() -> String {
        return self.stationCodeStorage
    }
    
    func stationData() -> [StationData] {
        return self.stationDataStorage
    }
}
