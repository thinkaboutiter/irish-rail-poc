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
protocol MapViewModelConsumer: AnyObject {
    func didUpdateStations(on viewModel: MapViewModel)
    func didReceiveError(on viewModel: MapViewModel, error: Swift.Error)
}

/// APIs for `ViewModel` to expose to `View`
protocol MapViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: MapViewModelConsumer)
    
    /// In degrees
    func initialLatitude() -> Double
    
    /// In degrees
    func initialLongitude() -> Double
    
    /// In meters
    func initialRadius() -> Double
    
    /// Initiate `Station`-s fetching
    func fetchStations()
    
    /// Obtain fetched `Station`-s
    func stations() -> [Station]
    
    /// Reset all data
    func reset()
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
    
    func fetchStations() {
        self.repository.fetchStations()
    }
    
    func stations() -> [Station] {
        return self.model.stations()
    }
    
    func reset() {
        self.model.reset()
    }
    
    // MARK: - MapModelConsumer protocol
    func didUpdateStationsCache(on model: MapModel) {
        self.viewModelConsumer.didUpdateStations(on: self)
    }
    
    // MARK: - StationRepositoryConsumer protocol
    func didFetchStations(on repository: StationRepository) {
        let stations: [Station] = repository.stations()
        self.model.setStations(stations)
    }
    
    func didFailToFetchStations(on repository: StationRepository, with error: Error) {
        self.viewModelConsumer.didReceiveError(on: self, error: error)
    }
}
