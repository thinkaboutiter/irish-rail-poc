//
//  TrainViewModel.swift
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
protocol TrainViewModelConsumer: AnyObject {
    func didFinishFetchingTrainMovements(on viewModel: TrainViewModel)
    func didFailFetchingTrainMovements(on viewModel: TrainViewModel,
                                       error: Swift.Error)
}

protocol SearchTainMovementViewModel: AnyObject {
    func isDisplayingSearchResults() -> Bool
    func setDisplayingSearchResults(_ newValue: Bool)
    func getSearchTerm() -> String
    func setSearchTerm(_ newValue: String)
}

/// APIs for `ViewModel` to expose to `View`
protocol TrainViewModel: SearchTainMovementViewModel {
    func setViewModelConsumer(_ newValue: TrainViewModelConsumer)
    func fetchTrainMovements()
    func cancelTrainMovementsFetching()
    func items() -> [TrainMovement]
    func item(at indexPath: IndexPath) -> TrainMovement?
    func stationData() -> StationData
}

class TrainViewModelImpl: TrainViewModel, TrainModelConsumer {
    
    // MARK: - Properties
    private let model: TrainModel
    private weak var viewModelConsumer: TrainViewModelConsumer!
    private let repository: TrainMovementRepository
    private var displayingSearchResults: Bool = false
    private var searchTerm: String = ""
    
    // MARK: - Initialization
    init(model: TrainModel,
         repository: TrainMovementRepository)
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
    
    // MARK: - TrainViewModel protocol
    func setViewModelConsumer(_ newValue: TrainViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    func fetchTrainMovements() {
        self.repository.reset()
        let stationData = self.stationData()
        self.repository.fetchTrainMovements(for: stationData.trainCode,
                                            trainDate: stationData.trainDate,
                                            usingCache: true)
    }
    
    func cancelTrainMovementsFetching() {
        self.repository.reset()
    }
    
    func items() -> [TrainMovement] {
        let result: [TrainMovement]
        if self.isDisplayingSearchResults() {
            let term: String = self.getSearchTerm()
            result = self.filteredItems(by: term)
        }
        else {
            result = self.model.trainMovements()
        }
        return result
    }
    
    private func filteredItems(by term: String) -> [TrainMovement] {
        var result: [TrainMovement] = []
        do {
            result = try self.repository.filteredTrainMovements(by: term)
        }
        catch {
            Logger.error.message().object(error)
        }
        return result
    }
    
    func item(at indexPath: IndexPath) -> TrainMovement? {
        let count: Int = self.items().count
        let range: Range<Int> = 0..<count
        let index: Int = indexPath.item
        guard range ~= index else {
            let message: String = "index=\(index) out of range=\(range)!"
            Logger.error.message(message)
            return nil
        }
        let result: TrainMovement = self.items()[index]
        return result
    }
    
    func stationData() -> StationData {
        return self.model.stationData()
    }
    
    // MARK: - SearchTainMovementViewModel protocol
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
    
    // MARK: - TrainModelConsumer protocol
    func didUpdateTrainMovements(on model: TrainModel) {
        self.viewModelConsumer.didFinishFetchingTrainMovements(on: self)
    }
}

// MARK: - TrainMovementRepositoryConsumer protocol
extension TrainViewModelImpl: TrainMovementRepositoryConsumer {
    
    func didFetchTrainMovements(on repository: TrainMovementRepository) {
        do {
            let trainMovements: [TrainMovement] = try repository.trainMovements().sorted() { $0.locationOrder < $1.locationOrder}
            self.model.setTrainMovements(trainMovements)
        }
        catch {
            self.didFailToFetchTrainMovements(on: repository, with: error)
        }
    }
    
    func didFailToFetchTrainMovements(on repository: TrainMovementRepository, with error: Error) {
        self.viewModelConsumer.didFailFetchingTrainMovements(on: self, error: error)
    }
}
