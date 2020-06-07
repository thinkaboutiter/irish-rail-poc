//
//  StationViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol StationViewModelConsumer: AnyObject {
    func didFinishFetchngStationData(on viewModel: StationViewModel)
    func didFailFetchingStationData(on viewModel: StationViewModel,
                                    error: Swift.Error)
}

/// APIs for `ViewModel` to expose to `View`
protocol StationViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: StationViewModelConsumer)
    func fetchStationData()
    func cancelStationDataFetching()
    func stationData() -> [StationData]
    func stationCode() -> String
}

class StationViewModelImpl: StationViewModel, StationModelConsumer {
    
    // MARK: - Properties
    private let model: StationModel
    private weak var viewModelConsumer: StationViewModelConsumer!
    private let repository: StationDataRepository
    
    // MARK: - Initialization
    init(model: StationModel,
         repository: StationDataRepository)
    {
        self.model = model
        self.repository = repository
        self.model.setModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationViewModel protocol
    func setViewModelConsumer(_ newValue: StationViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchStationData() {
        self.repository.reset()
        self.repository.fetchStationData(for: self.stationCode(),
                                         usingCache: true)
    }
    
    func cancelStationDataFetching() {
        self.repository.reset()
    }
    
    func stationData() -> [StationData] {
        self.model.stationData()
    }
    
    func stationCode() -> String {
        self.model.stationCode()
    }
    
    // MARK: - StationModelConsumer protocol
}
