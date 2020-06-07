//
//  StationDataCalloutAccessoryViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol StationDataCalloutAccessoryViewModelConsumer: AnyObject {
    func didFinishFetchngStationData(on viewModel: StationDataCalloutAccessoryViewModel)
    func didFailFetchingStationData(on viewModel: StationDataCalloutAccessoryViewModel,
                                    error: Swift.Error)
}

/// APIs for `ViewModel` to expose to `View`
protocol StationDataCalloutAccessoryViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: StationDataCalloutAccessoryViewModelConsumer)
    func fetchStationData()
    func cancelStationDataFetching()
    func trainsCount() -> Int
    func station() -> Station
}

class StationDataCalloutAccessoryViewModelImpl: StationDataCalloutAccessoryViewModel {
    
    // MARK: - Properties
    private let stationStorage: Station
    private var trainsCountStorage: Int
    private let repository: StationDataRepository
    private weak var viewModelConsumer: StationDataCalloutAccessoryViewModelConsumer!
    
    // MARK: - Initialization
    init(station: Station,
         repository: StationDataRepository)
    {
        self.trainsCountStorage = 0
        self.stationStorage = station
        self.repository = repository
        self.repository.setRepositoryConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        self.cancelStationDataFetching()
        Logger.fatal.message()
    }
    
    // MARK: - StationCalloutAccessoryViewModel protocol
    func setViewModelConsumer(_ newValue: StationDataCalloutAccessoryViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchStationData() {
        self.repository.reset()
        self.repository.fetchStationData(for: self.stationStorage.code,
                                         usingCache: true)
    }
    
    func cancelStationDataFetching() {
        self.repository.reset()
    }
    
    func trainsCount() -> Int {
        return self.trainsCountStorage
    }
    
    func station() -> Station {
        return self.stationStorage
    }
}

 // MARK: - StationDataRepositoryConsumer
extension StationDataCalloutAccessoryViewModelImpl: StationDataRepositoryConsumer {
    
    func didFetchStationData(on repository: StationDataRepository) {
        do {
            let stationData: [StationData] = try repository.stationData()
            self.trainsCountStorage = stationData.count
            self.viewModelConsumer.didFinishFetchngStationData(on: self)
        }
        catch {
            self.didFailToFetchStationData(on: repository,
                                           with: error)
        }
    }
    
    func didFailToFetchStationData(on repository: StationDataRepository,
                                   with error: Error)
    {
        self.viewModelConsumer.didFailFetchingStationData(on: self, error: error)
    }
}
