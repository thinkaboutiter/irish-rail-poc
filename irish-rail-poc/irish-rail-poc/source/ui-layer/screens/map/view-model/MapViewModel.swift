//
//  MapViewModel.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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
    func items() -> [Station]
    
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
        self.repository.fetchStations(usingCache: true)
    }
    
    func items() -> [Station] {
        return self.model.stations()
    }
    
    func reset() {
        self.model.reset()
    }
    
    // MARK: - MapModelConsumer protocol
    func didUpdateStations(on model: MapModel) {
        self.viewModelConsumer.didUpdateStations(on: self)
    }
    
    // MARK: - StationRepositoryConsumer protocol
    func didFetchStations(on repository: StationRepository) {
        do {
            let stations: [Station] = try repository.stations().sorted() { $0.desc < $1.desc }
            self.model.setStations(stations)
        }
        catch {
            self.viewModelConsumer.didReceiveError(on: self, error: error)
        }
    }
    
    func didFailToFetchStations(on repository: StationRepository, with error: Error) {
        self.viewModelConsumer.didReceiveError(on: self, error: error)
    }
}
