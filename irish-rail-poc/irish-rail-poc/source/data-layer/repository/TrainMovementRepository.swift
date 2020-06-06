//
//  TrainMovementRepository.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-05-Jun-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol TrainMovementRepositoryConsumer: AnyObject {
    func didFetchTrainMovement(on repository: TrainMovementRepository)
    func didFailToFetchTrainMovement(on repository: TrainMovementRepository,
                                     with error: Swift.Error)
}

protocol TrainMovementRepository: AnyObject {
    
    /// Set `TrainMovementRepositoryConsumer` object
    /// - Parameter newValue: the new `TrainMovementRepositoryConsumer` object
    func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer)
    
    /// Update `WebService` object
    /// - Parameter newValue: new `WebService` object
    func updateWebService(_ newValue: GetTrainMovementsWebService)
    
    /// Obtain `TrainMovement` objects.
    func fetchTrainMovement()
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Provide fetched data from the cache.
    func trainMovements() -> [TrainMovement]
    
    /// Search for `TrainMovement` object.
    /// - Parameter term: term to search for.
    func filteredTrainMovements(by term: String) -> [TrainMovement]
}

class TrainMovementRepositoryImpl: BaseRepository<TrainMovement>, TrainMovementRepository {
    
    // MARK: - Properties
    private weak var consumer: TrainMovementRepositoryConsumer!
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - TrainMovementRepository protocol
    func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func updateWebService(_ newValue: GetTrainMovementsWebService) {
        self.setWebService(newValue)
    }
    
    func fetchTrainMovement() {
        self.fetchResources(
            success: {
                self.consumer.didFetchTrainMovement(on: self)
        },
            failure: { (error: Error) in
                self.consumer.didFailToFetchTrainMovement(on: self,
                                                          with: error)
        })
    }
    
    override func refresh() {
        super.refresh()
        self.fetchTrainMovement()
    }
    
    func trainMovements() -> [TrainMovement] {
        let result: [TrainMovement] = self.objects()
        return result
    }
    
    func filteredTrainMovements(by term: String) -> [TrainMovement] {
        let result: [TrainMovement] = self.trainMovements().filter { (trainMovement: TrainMovement) -> Bool in
            return (trainMovement.locationFullName.contains(term)
                || trainMovement.trainOrigin.contains(term)
                || trainMovement.trainDestination.contains(term))
        }
        return result
    }
}

