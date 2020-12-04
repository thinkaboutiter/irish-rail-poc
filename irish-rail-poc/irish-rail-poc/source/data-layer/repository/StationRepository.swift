//
//  StationRepository.swift
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

protocol StationRepositoryConsumer: AnyObject {
    func didFetchStations(on repository: StationRepository)
    func didFailToFetchStations(on repository: StationRepository,
                                with error: Swift.Error)
}

protocol StationRepository: AnyObject {
    
    /// Set `StationRepositoryConsumer` object
    /// - Parameter newValue: the new `StationRepositoryConsumer` object
    func setRepositoryConsumer(_ newValue: StationRepositoryConsumer)
    
    /// Obtain `Station` objects.
    func fetchStations(usingCache: Bool)
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Reset local cache and cancel request if any.
    func reset()
    
    /// Provide fetched data from the cache.
    func stations() throws -> [Station]
    
    /// Search for `Station` object.
    /// - Parameter term: term to search for.
    func filteredStations(by term: String) throws -> [Station]
}

class StationRepositoryImpl: BaseRepository<Station>, StationRepository {
    
    // MARK: - Properties
    private weak var consumer: StationRepositoryConsumer!
    private var stationsCache: StationsCache {
        return AppCache.stationsCache
    }
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationRepository protocol
    func setRepositoryConsumer(_ newValue: StationRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func fetchStations(usingCache: Bool) {
        let isCacheValid: Bool = self.stationsCache.isStationsCacheValid()
        let shouldUseCache: Bool = usingCache && isCacheValid
        guard !shouldUseCache else {
            self.consumer.didFetchStations(on: self)
            return
        }
        self.stationsCache.invalidateStationsCache()
        self.fetchResources(
            success: {
                self.consumer.didFetchStations(on: self)
        },
            failure: { (error: Error) in
                self.consumer.didFailToFetchStations(on: self,
                                                     with: error)
        })
    }
    
    override func refresh() {
        super.refresh()
        self.fetchStations(usingCache: false)
    }
    
    func stations() throws -> [Station] {
        let result: [Station]
        let consumed: [Station] = self.consumeObjects()
        if !consumed.isEmpty {
            self.stationsCache.add(consumed,
                                   shouldInvalidateExistingCache: true)
            result = consumed
        }
        else {
            result = try self.stationsCache.stations()
        }
        return result
    }
    
    func filteredStations(by term: String) throws -> [Station] {
        let lowercasedTerm: String = term.lowercased()
        let result: [Station] = try self.stations().filter { (station: Station) -> Bool in
            return (station.desc.lowercased().contains(lowercasedTerm)
                || station.code.lowercased().contains(lowercasedTerm))
        }
        return result
    }
}
