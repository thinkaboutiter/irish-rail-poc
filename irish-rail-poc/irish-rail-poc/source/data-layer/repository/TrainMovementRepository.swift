//
//  TrainMovementRepository.swift
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

protocol TrainMovementRepositoryConsumer: AnyObject {
    func didFetchTrainMovements(on repository: TrainMovementRepository)
    func didFailToFetchTrainMovements(on repository: TrainMovementRepository,
                                      with error: Swift.Error)
}

protocol TrainMovementRepository: AnyObject {
    
    /// Set `TrainMovementRepositoryConsumer` object
    /// - Parameter newValue: the new `TrainMovementRepositoryConsumer` object
    func setRepositoryConsumer(_ newValue: TrainMovementRepositoryConsumer)
    
    /// Obtain `TrainMovement` objects.
    func fetchTrainMovements(for trainCode: String,
                             trainDate: String,
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
    private var trainDate: String?
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
    
    func fetchTrainMovements(for trainCode: String,
                             trainDate: String,
                             usingCache: Bool)
    {
        self.trainCode = trainCode
        self.trainDate = trainDate
        let isCacheValid: Bool = self.trainMovementsCache.isTrainMovementsCacheValid(for: trainCode)
        let shouldUseCache: Bool = usingCache && isCacheValid
        guard !shouldUseCache else {
            self.consumer.didFetchTrainMovements(on: self)
            return
        }
        self.trainMovementsCache.invalidateTrainMovementsCache(for: trainCode)
        self.webService.requestParameters = [
            WebServiceConstants.RequestParameterKey.trainId: trainCode,
            WebServiceConstants.RequestParameterKey.trainDate: trainDate
        ]
        self.fetchResources(
            success: {
                self.consumer.didFetchTrainMovements(on: self)
            },
            failure: { (error: Swift.Error) in
                self.consumer.didFailToFetchTrainMovements(on: self,
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
            self.consumer.didFailToFetchTrainMovements(on: self,
                                                       with: error)
            return
        }
        guard let trainDate: String = self.trainDate else {
            let message: String = Error.Message.invalidTrainDateParameter
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainDateParameter,
                                                     localizedMessage: message).error()
            self.consumer.didFailToFetchTrainMovements(on: self,
                                                       with: error)
            return
        }
        self.fetchTrainMovements(for: trainCode,
                                 trainDate: trainDate,
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
        }
        result = try self.trainMovementsCache.trainMovements(for: trainCode)
        return result
    }
    
    func filteredTrainMovements(by term: String) throws -> [TrainMovement] {
        let lowercasedTerm: String = term.lowercased()
        let result: [TrainMovement] = try self.trainMovements().filter { (trainMovement: TrainMovement) -> Bool in
            return (trainMovement.locationFullName.lowercased().contains(lowercasedTerm)
                        || trainMovement.trainOrigin.lowercased().contains(lowercasedTerm)
                        || trainMovement.trainDestination.lowercased().contains(lowercasedTerm))
        }
        return result
    }
}

private extension TrainMovementRepositoryImpl {
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: TrainMovementRepositoryImpl.Error.self))"
        
        enum Code {
            static let invalidTrainCodeParameter: Int = 9000
            static let invalidTrainDateParameter: Int = 9001
        }
        enum Message {
            static let invalidTrainCodeParameter: String = "invalid train_code parameter!"
            static let invalidTrainDateParameter: String = "invalid train_date parameter!"
        }
    }
}
