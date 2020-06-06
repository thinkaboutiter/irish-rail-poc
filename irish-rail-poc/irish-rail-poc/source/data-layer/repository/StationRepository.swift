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
    
    /// Update `WebService` object
    /// - Parameter newValue: new `WebService` object
    func updateWebService(_ newValue: GetAllStationsWebService)
    
    /// Obtain `Station` objects.
    func fetchStations()
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Provide fetched data from the cache.
    func stations() -> [Station]
    
    /// Search for `Station` object.
    /// - Parameter term: term to search for.
    func filteredStations(by term: String) -> [Station]
}

class StationRepositoryImpl: BaseRepository<Station>, StationRepository {
    
    // MARK: - Properties
    private weak var consumer: StationRepositoryConsumer!
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationRepository protocol
    func setRepositoryConsumer(_ newValue: StationRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func updateWebService(_ newValue: GetAllStationsWebService) {
        self.setWebService(newValue)
    }
    
    func fetchStations() {
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
        self.fetchStations()
    }
    
    func stations() -> [Station] {
        let result: [Station] = self.objects()
        return result
    }
    
    func filteredStations(by term: String) -> [Station] {
        let result: [Station] = self.stations().filter { (station: Station) -> Bool in
            return ((station.alias?.contains(term) ?? false)
                || station.desc.contains(term)
                || station.code.contains(term))
        }
        return result
    }
}
