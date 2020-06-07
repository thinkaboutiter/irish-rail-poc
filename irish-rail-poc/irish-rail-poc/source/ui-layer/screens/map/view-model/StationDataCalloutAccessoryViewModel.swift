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
    func stationCode() -> String
}

class StationDataCalloutAccessoryViewModelImpl: StationDataCalloutAccessoryViewModel {
    
    // MARK: - Properties
    private let stationCodeStorage: String
    private var trainsCountStorage: Int
    private let repository: StationDataRepository
    private weak var viewModelConsumer: StationDataCalloutAccessoryViewModelConsumer!
    
    // MARK: - Initialization
    init(stationCode: String,
         repository: StationDataRepository)
    {
        self.trainsCountStorage = 0
        self.stationCodeStorage = stationCode
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
        self.repository.fetchStationData(for: self.stationCodeStorage)
    }
    
    func cancelStationDataFetching() {
        self.repository.reset()
    }
    
    func trainsCount() -> Int {
        return self.trainsCountStorage
    }
    
    func stationCode() -> String {
        return self.stationCodeStorage
    }
}

 // MARK: - StationDataRepositoryConsumer
extension StationDataCalloutAccessoryViewModelImpl: StationDataRepositoryConsumer {
    
    func didFetchStationData(on repository: StationDataRepository) {
        let stationData: [StationData] = repository.stationData()
        self.trainsCountStorage = stationData.count
        self.viewModelConsumer.didFinishFetchngStationData(on: self)
    }
    
    func didFailToFetchStationData(on repository: StationDataRepository,
                                   with error: Error)
    {
        self.viewModelConsumer.didFailFetchingStationData(on: self, error: error)
    }
}
