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
    
    /// Obtains `Station` objects.
    func fetchStations()
    
    /// Resets local cache and initiate fetch again.
    func refresh()
    
    /// Provides fetched data from the cache.
    func stations() -> [Station]
    
    /// Sets `StationRepositoryConsumer` object
    /// - Parameter newValue: the new `StationRepositoryConsumer` object
    func setRepositoryConsumer(_ newValue: StationRepositoryConsumer)
    
    /// Search for `Station` object.
    /// - Parameter term: term to search for.
    func filteredStations(by term: String) -> [Station]
}

class StationRepositoryImpl: StationRepository {
    
    // MARK: - Properties
    private let webService: GetAllStationsWebService
    private weak var consumer: StationRepositoryConsumer!
    private let concurrentCacheQueue = DispatchQueue(label: Constants.concurrentQueueLabel,
                                                     qos: .default,
                                                     attributes: .concurrent)
    private var cache: NSMutableOrderedSet = []
    private func clearCache() {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let valid_self = self else {
                return
            }
            valid_self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Initialization
    init(webService: GetAllStationsWebService) {
        self.webService = webService
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationRepository protocol
    func fetchStations() {
        self.webService.fetch(
            success: { (stations: [Station]) in
                self.consume(stations)
        },
            failure: { (error: Error) in
                self.consumer.didFailToFetchStations(on: self, with: error)
        })
    }
    
    private func consume(_ stations: [Station]) {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let valid_self = self else {
                return
            }
            valid_self.cache.addObjects(from: stations)
            DispatchQueue.main.async { [weak self] in
                guard let valid_self = self else {
                    return
                }
                valid_self.consumer.didFetchStations(on: valid_self)
            }
        }
    }
    
    func refresh() {
        self.clearCache()
        self.fetchStations()
    }
    
    func stations() -> [Station] {
        var result: [Station]!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let valid_self = self else {
                return
            }
            result = valid_self.cache.compactMap { (element: Any) -> Station? in
                guard let valid_entity: Station = element as? Station else {
                    return nil
                }
                return valid_entity
            }
        }
        return result ?? []
    }
    
    func setRepositoryConsumer(_ newValue: StationRepositoryConsumer) {
        self.consumer = newValue
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

// MARK: - Constants
private extension StationRepositoryImpl {
    enum Constants {
        static let concurrentQueueLabel: String = "\(AppConstants.projectName)-\(String(describing: StationRepositoryImpl.self))-concurrent-queue"
    }
}
