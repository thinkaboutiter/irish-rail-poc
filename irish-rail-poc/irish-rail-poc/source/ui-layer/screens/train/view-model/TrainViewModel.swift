//
//  TrainViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol TrainViewModelConsumer: AnyObject {
    func didFinishFetchingTrainMovements(on viewModel: TrainViewModel)
    func didFailFetchingTrainMovements(on viewModel: TrainViewModel,
                                       error: Swift.Error)
}

/// APIs for `ViewModel` to expose to `View`
protocol TrainViewModel: AnyObject {
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
        self.repository.fetchTrainMovement(for: self.stationData().trainCode,
                                           trainDate: self.stationData().trainDate,
                                           usingCache: true)
    }
    
    func cancelTrainMovementsFetching() {
        self.repository.reset()
    }
    
    func items() -> [TrainMovement] {
        return self.model.trainMovements()
    }
    
    func item(at indexPath: IndexPath) -> TrainMovement? {
        let range: Range<Int> = 0..<self.items().count
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
    
    // MARK: - TrainModelConsumer protocol
    func didUpdateTrainMovements(on viewModel: TrainModel) {
        self.viewModelConsumer.didFinishFetchingTrainMovements(on: self)
    }
}

// MARK: - TrainMovementRepositoryConsumer protocol
extension TrainViewModelImpl: TrainMovementRepositoryConsumer {
    
    func didFetchTrainMovement(on repository: TrainMovementRepository) {
        do {
            let trainMovements: [TrainMovement] = try repository.trainMovements().sorted() { $0.locationOrder < $1.locationOrder}
            self.model.setTrainMovements(trainMovements)
        }
        catch {
            self.didFailToFetchTrainMovement(on: repository, with: error)
        }
    }
    
    func didFailToFetchTrainMovement(on repository: TrainMovementRepository, with error: Error) {
        self.viewModelConsumer.didFailFetchingTrainMovements(on: self, error: error)
    }
}
