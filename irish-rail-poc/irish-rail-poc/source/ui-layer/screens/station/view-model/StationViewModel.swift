//
//  StationViewModel.swift
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
protocol StationViewModelConsumer: AnyObject {
    func didFinishFetchingStationData(on viewModel: StationViewModel)
    func didFailFetchingStationData(on viewModel: StationViewModel,
                                    error: Swift.Error)
}

protocol SearchStationDataViewModel: AnyObject {
    func isDisplayingSearchResults() -> Bool
    func setDisplayingSearchResults(_ newValue: Bool)
    func getSearchTerm() -> String
    func setSearchTerm(_ newValue: String)
    func filteredItems(by term: String) -> [StationData]
}

/// APIs for `ViewModel` to expose to `View`
protocol StationViewModel: SearchStationDataViewModel {
    func setViewModelConsumer(_ newValue: StationViewModelConsumer)
    func fetchStationData()
    func cancelStationDataFetching()
    func items() -> [StationData]
    func item(at indexPath: IndexPath) -> StationData?
    func station() -> Station
}

class StationViewModelImpl: StationViewModel, StationModelConsumer {
    
    // MARK: - Properties
    private let model: StationModel
    private weak var viewModelConsumer: StationViewModelConsumer!
    private let repository: StationDataRepository
    private var displayingSearchResults: Bool = false
    private var searchTerm: String = ""
    
    // MARK: - Initialization
    init(model: StationModel,
         repository: StationDataRepository)
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
    
    // MARK: - StationViewModel protocol
    func setViewModelConsumer(_ newValue: StationViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchStationData() {
        self.repository.reset()
        self.repository.fetchStationData(for: self.station().code,
                                         usingCache: true)
    }
    
    func cancelStationDataFetching() {
        self.repository.reset()
    }
    
    func items() -> [StationData] {
        let result: [StationData]
        if self.isDisplayingSearchResults() {
            let term: String = self.getSearchTerm()
            result = self.filteredItems(by: term)
        }
        else {
            result = self.model.stationData()
        }
        return result
    }
    
    func item(at indexPath: IndexPath) -> StationData? {
        let range: Range<Int> = 0..<self.items().count
        let index: Int = indexPath.item
        guard range ~= index else {
            let message: String = "index=\(index) out of range=\(range)!"
            Logger.error.message(message)
            return nil
        }
        let result: StationData = self.items()[index]
        return result
    }
    
    func station() -> Station {
        self.model.station()
    }
    
    // MARK: - SearchStationDataViewModel protocol
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
    
    func filteredItems(by term: String) -> [StationData] {
        var result: [StationData] = []
        do {
            result = try self.repository.filteredStationData(by: term)
        }
        catch {
            Logger.error.message().object(error)
        }
        return result
    }
    
    // MARK: - StationModelConsumer protocol
    func didUpdateStationData(on viewModel: StationModel) {
        self.viewModelConsumer.didFinishFetchingStationData(on: self)
    }
}

// MARK: - StationDataRepositoryConsumer
extension StationViewModelImpl: StationDataRepositoryConsumer {
    
    func didFetchStationData(on repository: StationDataRepository) {
        do {
            let stationData: [StationData] = try repository.stationData().sorted() { $0.scheduleArrival < $1.scheduleArrival }
            self.model.setStationData(stationData)
        }
        catch {
            self.didFailToFetchStationData(on: repository, with: error)
        }
    }
    
    func didFailToFetchStationData(on repository: StationDataRepository, with error: Error) {
        self.viewModelConsumer.didFailFetchingStationData(on: self, error: error)
    }
}
