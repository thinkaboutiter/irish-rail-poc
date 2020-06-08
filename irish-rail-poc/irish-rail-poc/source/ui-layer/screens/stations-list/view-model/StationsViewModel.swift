//
//  StationsViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol StationsViewModelConsumer: AnyObject {
    func didUpdateStations(on viewModel: StationsViewModel)
    func didReceiveError(on viewModel: StationsViewModel, error: Swift.Error)
}

/// APIs for `ViewModel` to expose to `View`
protocol StationsViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: StationsViewModelConsumer)
    
    /// Initiate `Station`-s fetching
    func fetchStations()
    
    /// Obtain fetched `Station`-s
    func items() -> [Station]
    
    /// Obtan `Station` for given `IndexPath`
    /// - Parameter indexPath: indexPath we want the object for
    func item(at indexPath: IndexPath) -> Station?
    
    /// Reset all data
    func reset()
}

class StationsViewModelImpl: StationsViewModel, StationsModelConsumer, StationRepositoryConsumer {
    
    // MARK: - Properties
    private let model: StationsModel
    private let repository: StationRepository
    private weak var viewModelConsumer: StationsViewModelConsumer!
    
    // MARK: - Initialization
    init(model: StationsModel,
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
    
    // MARK: - StationsViewModel protocol
    func setViewModelConsumer(_ newValue: StationsViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchStations() {
        self.repository.fetchStations(usingCache: true)
    }
    
    func items() -> [Station] {
        return self.model.stations()
    }
    
    func item(at indexPath: IndexPath) -> Station? {
        let range: Range<Int> = 0..<self.items().count
        let index: Int = indexPath.item
        guard range ~= index else {
            let message: String = "index=\(index) out of range=\(range)!"
            Logger.error.message(message)
            return nil
        }
        let result: Station = self.items()[index]
        return result
    }
    
    func reset() {
        self.model.reset()
    }
    
    // MARK: - StationsModelConsumer protocol
    func didUpdateStations(on model: StationsModel) {
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
