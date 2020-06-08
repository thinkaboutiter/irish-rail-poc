//
//  StationDataRepository.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-05-Jun-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol StationDataRepositoryConsumer: AnyObject {
    func didFetchStationData(on repository: StationDataRepository)
    func didFailToFetchStationData(on repository: StationDataRepository,
                                with error: Swift.Error)
}

protocol StationDataRepository: AnyObject {
    
    /// Set `StationDataRepositoryConsumer` object
    /// - Parameter newValue: the new `StationDataRepositoryConsumer` object
    func setRepositoryConsumer(_ newValue: StationDataRepositoryConsumer)
    
    
    /// Obtain `StationData` objects for given station code
    /// - Parameters:
    ///   - stationCode: the code of the station
    ///   - usingCache: flag indicating cache usage
    func fetchStationData(for stationCode: String,
                          usingCache: Bool)
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Reset local cache and cancel request if any.
    func reset()
    
    /// Provide fetched data from the cache.
    func stationData() throws -> [StationData]
    
    /// Search for `StationData` object.
    /// - Parameter term: term to search for.
    func filteredStationData(by term: String) throws -> [StationData]
}

class StationDataRepositoryImpl: BaseRepository<StationData>, StationDataRepository {
    
    // MARK: - Properties
    private weak var consumer: StationDataRepositoryConsumer!
    private var stationCode: String?
    private lazy var stationDataCache: StationDataCache = {
        return StationDataCacheImpl.shared
    }()
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataRepository protocol
    func setRepositoryConsumer(_ newValue: StationDataRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func fetchStationData(for stationCode: String,
                          usingCache: Bool)
    {
        self.stationCode = stationCode
        let isCacheValid: Bool = self.stationDataCache.isCacheValid(for: stationCode)
        let shouldUseCache: Bool = usingCache && isCacheValid
        guard !shouldUseCache else {
            self.consumer.didFetchStationData(on: self)
            return
        }
        self.stationDataCache.invalidateCache(for: stationCode)
        self.webService.requestParameters = [
            WebServiceConstants.RequestParameterKey.stationCode: stationCode
        ]
        self.fetchResources(
            success: {
                self.consumer.didFetchStationData(on: self)
        },
            failure: { (error: Swift.Error) in
                self.consumer.didFailToFetchStationData(on: self,
                                                        with: error)
        })
    }
    
    override func refresh() {
        super.refresh()
        guard let stationCode: String = self.stationCode else {
            let message: String = Error.Message.invalidStationCodeParameter
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidStationCodeParameter,
                                                     localizedMessage: message).error()
            self.consumer.didFailToFetchStationData(on: self,
                                                    with: error)
            return
        }
        self.fetchStationData(for: stationCode,
                              usingCache: false)
    }
    
    func stationData() throws -> [StationData] {
        guard let stationCode: String = self.stationCode else {
            let message: String = Error.Message.invalidStationCodeParameter
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidStationCodeParameter,
                                                     localizedMessage: message).error()
            throw error
        }
        let result: [StationData]
        let consumed: [StationData] = self.consumeObjects()
        if !consumed.isEmpty {
            self.stationDataCache.add(consumed,
                                      for: stationCode,
                                      shouldInvalidateExistingCache: true)
            result = consumed
        }
        else {
            result = try self.stationDataCache.stationData(for: stationCode)
        }
        return result
    }
    
    func filteredStationData(by term: String) throws -> [StationData] {
        let result: [StationData] = try self.stationData().filter { (stationData: StationData) -> Bool in
            return (stationData.stationFullName.contains(term)
                || stationData.stationCode.contains(term)
                || stationData.origin.contains(term)
                || stationData.destination.contains(term)
                || stationData.lastLocation.contains(term))
        }
        return result
    }
}

private extension StationDataRepositoryImpl {
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: StationDataRepositoryImpl.Error.self))"
        
        enum Code {
            static let invalidStationCodeParameter: Int = 9000
            static let invalidCache: Int = 9001
        }
        enum Message {
            static let invalidStationCodeParameter: String = "invalid station_code parameter!"
            static let invalidCache: String = "cache is no longer valid!"
        }
    }
}
