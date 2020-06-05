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
    
    /// Obtain `StationData` objects.
    func fetchStationData()
    
    /// Reset local cache and initiate fetch again.
    func refresh()
    
    /// Provide fetched data from the cache.
    func stationData() -> [StationData]
    
    /// Search for `StationData` object.
    /// - Parameter term: term to search for.
    func filteredStationData(by term: String) -> [StationData]
}

class StationDataRepositoryImpl: BaseRepository<StationData>, StationDataRepository {
    
    // MARK: - Properties
    private weak var consumer: StationDataRepositoryConsumer!
    
    // MARK: - Initialization
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataRepository protocol
    
    func setRepositoryConsumer(_ newValue: StationDataRepositoryConsumer) {
        self.consumer = newValue
    }
    
    func fetchStationData() {
        self.fetchResources(
            success: {
                self.consumer.didFetchStationData(on: self)
        },
            failure: { (error: Error) in
                self.consumer.didFailToFetchStationData(on: self,
                                                        with: error)
        })
    }
    
    override func refresh() {
        super.refresh()
        self.fetchStationData()
    }
    
    func stationData() -> [StationData] {
        let result: [StationData] = self.objects()
        return result
    }
    
    func filteredStationData(by term: String) -> [StationData] {
        let result: [StationData] = self.stationData().filter { (stationData: StationData) -> Bool in
            return (stationData.stationFullName.contains(term)
                || stationData.stationCode.contains(term)
                || stationData.origin.contains(term)
                || stationData.destination.contains(term)
                || stationData.lastLocation.contains(term))
        }
        return result
    }
}
