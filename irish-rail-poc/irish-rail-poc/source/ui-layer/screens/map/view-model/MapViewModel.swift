//
//  MapViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol MapViewModelConsumer: AnyObject {}

/// APIs for `ViewModel` to expose to `View`
protocol MapViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: MapViewModelConsumer)
    
    /// In degrees
    func initialLatitude() -> Double
    
    /// In degrees
    func initialLongitude() -> Double
    
    /// In meters
    func initialRadius() -> Double
}

class MapViewModelImpl: MapViewModel, MapModelConsumer {
    
    // MARK: - Properties
    private let model: MapModel
    private weak var viewModelConsumer: MapViewModelConsumer!
    
    // MARK: - Initialization
    required init(model: MapModel) {
        self.model = model
        self.model.setModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewModel protocol
    func setViewModelConsumer(_ newValue: MapViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func initialLatitude() -> Double {
        return self.model.initialLatitude()
    }
    
    func initialLongitude() -> Double {
        return self.model.initialLongitude()
    }
    
    func initialRadius() -> Double {
        return self.model.initialRadius()
    }
    
    // MARK: - MapModelConsumer protocol
}
