//
//  StationDataCalloutAccessoryViewModel.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
                                   with error: Swift.Error)
    {
        self.viewModelConsumer.didFailFetchingStationData(on: self, error: error)
    }
}
