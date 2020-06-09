//
//  StationsModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol StationsListModelConsumer: AnyObject {
    func didUpdateStations(on model: StationsListModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol StationsListModel: AnyObject {
    func setModelConsumer(_ newValue: StationsListModelConsumer)
    func stations() -> [Station]
    func setStations(_ newValue: [Station])
    func reset()
}

class StationsListModelImpl: StationsListModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationsListModelConsumer!
    private var stationsCache: NSMutableOrderedSet = []
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationsModel protocol
    func setModelConsumer(_ newValue: StationsListModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func stations() -> [Station] {
        let result: [Station] = (self.stationsCache.array as? [Station]) ?? []
        return result
    }
    
    func setStations(_ newValue: [Station]) {
        self.stationsCache.addObjects(from: newValue)
        self.modelConsumer.didUpdateStations(on: self)
    }
    
    func reset() {
        self.stationsCache.removeAllObjects()
        self.modelConsumer.didUpdateStations(on: self)
    }
}
