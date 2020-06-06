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

class MapViewModelImpl: MapViewModel, MapModelConsumer, StationRepositoryConsumer {
    
    // MARK: - Properties
    private let model: MapModel
    private let repository: StationRepository
    private weak var viewModelConsumer: MapViewModelConsumer!
    
    // MARK: - Initialization
    required init(model: MapModel,
                  repository: StationRepository)
    {
        self.model = model
        self.repository = repository
        self.model.setModelConsumer(self)
        self.repository.setRepositoryConsumer(self)
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
    
    // MARK: - StationRepositoryConsumer protocol
    func didFetchStations(on repository: StationRepository) {
        let _: [Station] = repository.stations()
        
        // TODO: persist data in the model
    }
    
    func didFailToFetchStations(on repository: StationRepository, with error: Error) {
        
        // TODO: trigger error UI on the view object (viewModelConsumer)
    }
}
