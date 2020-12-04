//
//  StationDataRepository.swift
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
    private var stationDataCache: StationDataCache {
        return AppCache.stationDataCache
    }
    
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
        let isCacheValid: Bool = self.stationDataCache.isStationDataCacheValid(for: stationCode)
        let shouldUseCache: Bool = usingCache && isCacheValid
        guard !shouldUseCache else {
            self.consumer.didFetchStationData(on: self)
            return
        }
        self.stationDataCache.invalidateStationDataCache(for: stationCode)
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
        let lowercasedTerm: String = term.lowercased()
        let result: [StationData] = try self.stationData().filter { (stationData: StationData) -> Bool in
            return (stationData.stationFullName.lowercased().contains(lowercasedTerm)
                || stationData.stationCode.lowercased().contains(lowercasedTerm)
                || stationData.origin.lowercased().contains(lowercasedTerm)
                || stationData.destination.lowercased().contains(lowercasedTerm)
                || stationData.lastLocation.lowercased().contains(lowercasedTerm))
        }
        return result
    }
}

private extension StationDataRepositoryImpl {
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: StationDataRepositoryImpl.Error.self))"
        
        enum Code {
            static let invalidStationCodeParameter: Int = 9000
        }
        enum Message {
            static let invalidStationCodeParameter: String = "invalid station_code parameter!"
        }
    }
}
