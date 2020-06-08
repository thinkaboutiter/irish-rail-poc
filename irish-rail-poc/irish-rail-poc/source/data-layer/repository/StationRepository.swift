//
//  StationRepository.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-05-Jun-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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
        let result: [Station] = try self.stations().filter { (station: Station) -> Bool in
            return ((station.alias?.contains(term) ?? false)
                || station.desc.contains(term)
                || station.code.contains(term))
        }
        return result
    }
}