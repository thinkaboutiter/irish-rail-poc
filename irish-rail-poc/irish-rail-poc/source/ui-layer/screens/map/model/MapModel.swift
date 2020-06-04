//
//  MapModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `Model`
protocol MapModelConsumer: AnyObject {}

/// APIs for `Model` to expose to `ViewModel`
protocol MapModel: AnyObject {
    func setModelConsumer(_ newValue: MapModelConsumer)
}

class MapModelImpl: MapModel {
    
    // MARK: - Properties
    private weak var modelConsumer: MapModelConsumer!
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapModel protocol
    func setModelConsumer(_ newValue: MapModelConsumer) {
        self.modelConsumer = newValue
    }
}
