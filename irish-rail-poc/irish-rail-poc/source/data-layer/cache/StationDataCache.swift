//
//  StationDataCache.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// Cache object

/// Cache for `StationData` objects for given `stationCode`
protocol StationDataCache: AnyObject {
    func stationData(for stationCode: String) -> [StationData]
    func add(_ stationData: [StationData], for stationCode: String)
    func isCacheValid(for stationCode: String) -> Bool
    func invalidateCache(for stationCode: String)
}

class StationDataCacheImpl: StationDataCache {
    
    // MARK: - Properties
    static let shared: StationDataCache = StationDataCacheImpl()
    
    // MARK: - Caching
    private let concurrentCacheQueue = DispatchQueue(label: Constants.concurrentQueueLabel,
                                                     qos: .default,
                                                     attributes: .concurrent)
    private lazy var cache: NSMapTable<NSString, NSMutableOrderedSet> = {
        let result: NSMapTable<NSString, NSMutableOrderedSet> = NSMapTable.strongToWeakObjects()
        return result
    }()
    private func clearCache() {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            validSelf.cache.removeAllObjects()
        }
    }
    
    // MARK: - Initialization
    private init() {
        Logger.general.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataCache protocol
    func stationData(for stationCode: String) -> [StationData] {
        var result: [StationData]!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSString = stationCode as NSString
            guard let collection: NSMutableOrderedSet = validSelf.cache.object(forKey: key) else {
                return
            }
            result = collection.compactMap() { $0 as? StationData }
        }
        return result ?? []
    }
    
    func add(_ stationData: [StationData], for stationCode: String) {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSString = stationCode as NSString
            let collectionToAdd: NSMutableOrderedSet
            if let existingCollection: NSMutableOrderedSet = validSelf.cache.object(forKey: key) {
                collectionToAdd = existingCollection
            }
            else {
                collectionToAdd = NSMutableOrderedSet()
            }
            collectionToAdd.addObjects(from: stationData)
            validSelf.cache.setObject(collectionToAdd, forKey: key)
        }
    }
    
    func isCacheValid(for stationCode: String) -> Bool {
        let result: Bool = false
        
        // TODO: implement me
        
        return result
    }
    
    func invalidateCache(for stationCode: String) {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSString = stationCode as NSString
            if let _ = validSelf.cache.object(forKey: key) {
                validSelf.cache.setObject(nil, forKey: key)
            }
        }
    }
}

// MARK: - Constants
private extension StationDataCacheImpl {
    
    private enum Constants {
        static var concurrentQueueLabel: String {
            return "\(AppConstants.projectName)-\(String(describing: StationDataCacheImpl.self))-concurrent-queue"
        }
    }
}


