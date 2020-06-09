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
protocol StationsListViewModelConsumer: AnyObject {
    func didUpdateStations(on viewModel: StationsListViewModel)
    func didReceiveError(on viewModel: StationsListViewModel, error: Swift.Error)
}

protocol SearchStationViewModel: AnyObject {
    func isDisplayingSearchResults() -> Bool
    func setDisplayingSearchResults(_ newValue: Bool)
    func getSearchTerm() -> String
    func setSearchTerm(_ newValue: String)
    func filteredItems(by term: String) -> [Station]
}

/// APIs for `ViewModel` to expose to `View`
protocol StationsListViewModel: SearchStationViewModel {
    func setViewModelConsumer(_ newValue: StationsListViewModelConsumer)
    
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

class StationsListViewModelImpl: StationsListViewModel, StationsListModelConsumer, StationRepositoryConsumer {
    
    // MARK: - Properties
    private let model: StationsListModel
    private let repository: StationRepository
    private weak var viewModelConsumer: StationsListViewModelConsumer!
    private var displayingSearchResults: Bool = false
    private var searchTerm: String = ""
    
    // MARK: - Initialization
    init(model: StationsListModel,
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
    func setViewModelConsumer(_ newValue: StationsListViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchStations() {
        self.repository.fetchStations(usingCache: true)
    }
    
    func items() -> [Station] {
        let result: [Station]
        if self.isDisplayingSearchResults() {
            let term: String = self.getSearchTerm()
            result = self.filteredItems(by: term)
        }
        else {
            result = self.model.stations()
        }
        return result
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
    
    // MARK: - SearchStationViewModel protocol
    func isDisplayingSearchResults() -> Bool {
        return self.displayingSearchResults
    }
    
    func setDisplayingSearchResults(_ newValue: Bool) {
        self.displayingSearchResults = newValue
    }
    
    func getSearchTerm() -> String {
        return self.searchTerm
    }
    
    func setSearchTerm(_ newValue: String) {
        self.searchTerm = newValue
    }
    
    func filteredItems(by term: String) -> [Station] {
        var result: [Station] = []
        do {
            result = try self.repository.filteredStations(by: term)
        }
        catch {
            Logger.error.message().object(error)
        }
        return result
    }
    
    // MARK: - StationsModelConsumer protocol
    func didUpdateStations(on model: StationsListModel) {
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
