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
protocol StationModelConsumer: AnyObject {}

/// APIs for `Model` to expose to `ViewModel`
protocol StationModel: AnyObject {
    func setModelConsumer(_ newValue: StationModelConsumer)
}

class StationModelImpl: StationModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationModelConsumer!
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationModel protocol
    func setModelConsumer(_ newValue: StationModelConsumer) {
        self.modelConsumer = newValue
    }
}
