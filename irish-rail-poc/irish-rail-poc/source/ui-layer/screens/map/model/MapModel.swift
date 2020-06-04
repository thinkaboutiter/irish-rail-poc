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
    
    /// In degrees
    func initialLatitude() -> Double
    
    /// In degrees
    func initialLongitude() -> Double
    
    /// In meters
    func initialRadius() -> Double
}

class MapModelImpl: MapModel {
    
    // MARK: - Properties
    private weak var modelConsumer: MapModelConsumer!
    private let latitude: Double
    private let longitude: Double
    private let radius: Double
    
    // MARK: - Initialization
    init(latitude: Double, longitude: Double, radius: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapModel protocol
    func setModelConsumer(_ newValue: MapModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func initialLatitude() -> Double {
        return self.latitude
    }
    
    func initialLongitude() -> Double {
        return self.longitude
    }
    
    func initialRadius() -> Double {
        return self.radius
    }
}
