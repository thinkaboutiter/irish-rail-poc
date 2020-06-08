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
    
    /// Obtain `TrainMovement` objects.
    func fetchTrainMovement(for trainCode: String,
                            usingCache: Bool)
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Reset local cache and cancel request if any.
    func reset()
    
    /// Provide fetched data from the cache.
    func trainMovements() throws -> [TrainMovement]
    
    /// Search for `TrainMovement` object.
    /// - Parameter term: term to search for.
    func filteredTrainMovements(by term: String) throws -> [TrainMovement]
}

class TrainMovementRepositoryImpl: BaseRepository<TrainMovement>, TrainMovementRepository {
    
    // MARK: - Properties
    private weak var consumer: TrainMovementRepositoryConsumer!
    private var trainCode: String?
    private var trainMovementsCache: TrainMovementsCache {
        return AppCache.trainMovementsCache
    }
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - TrainMovementRepository protocol
    func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func fetchTrainMovement(for trainCode: String,
                            usingCache: Bool)
    {
        self.trainCode = trainCode
        let isCacheValid: Bool = self.trainMovementsCache.isTrainMovementsCacheValid(for: trainCode)
        let shouldUseCache: Bool = usingCache && isCacheValid
        guard !shouldUseCache else {
            self.consumer.didFetchTrainMovement(on: self)
            return
        }
        self.trainMovementsCache.invalidateTrainMovementsCache(for: trainCode)
        let dateString: String = Date().asRequestQueryStringValue
        self.webService.requestParameters = [
            WebServiceConstants.RequestParameterKey.trainId: trainCode,
            WebServiceConstants.RequestParameterKey.trainDate: dateString
        ]
        self.fetchResources(
            success: {
                self.consumer.didFetchTrainMovement(on: self)
        },
            failure: { (error: Swift.Error) in
                self.consumer.didFailToFetchTrainMovement(on: self,
                                                          with: error)
        })
    }
    
    override func refresh() {
        super.refresh()
        guard let trainCode: String = self.trainCode else {
            let message: String = Error.Message.invalidTrainCodeParameter
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainCodeParameter,
                                                     localizedMessage: message).error()
            self.consumer.didFailToFetchTrainMovement(on: self,
                                                      with: error)
            return
        }
        self.fetchTrainMovement(for: trainCode,
                                usingCache: false)
    }
    
    func trainMovements() throws -> [TrainMovement] {
        guard let trainCode: String = self.trainCode else {
            let message: String = Error.Message.invalidTrainCodeParameter
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainCodeParameter,
                                                     localizedMessage: message).error()
            throw error
        }
        let result: [TrainMovement]
        let consumed: [TrainMovement] = self.consumeObjects()
        if !consumed.isEmpty {
            self.trainMovementsCache.add(consumed,
                                         for: trainCode,
                                         shouldInvalidateExistingCache: true)
            result = consumed
        }
        else {
            result = try self.trainMovementsCache.trainMovement(for: trainCode)
        }
        return result
    }
    
    func filteredTrainMovements(by term: String) throws -> [TrainMovement] {
        let result: [TrainMovement] = try self.trainMovements().filter { (trainMovement: TrainMovement) -> Bool in
            return (trainMovement.locationFullName.contains(term)
                || trainMovement.trainOrigin.contains(term)
                || trainMovement.trainDestination.contains(term))
        }
        return result
    }
}

private extension TrainMovementRepositoryImpl {
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: TrainMovementRepositoryImpl.Error.self))"
        
        enum Code {
            static let invalidTrainCodeParameter: Int = 9000
        }
        enum Message {
            static let invalidTrainCodeParameter: String = "invalid train_code parameter!"
        }
    }
}
