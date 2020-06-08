//
//  StationDataCache.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// Cache for `StationData` objects for given `stationCode`
protocol StationDataCache: AnyObject {
    func stationData(for stationCode: String) throws -> [StationData]
    func add(_ stationData: [StationData],
             for stationCode: String,
             shouldInvalidateExistingCache: Bool)
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
    private lazy var objectsCache: NSMapTable<NSNumber, NSMutableOrderedSet> = {
        let result: NSMapTable<NSNumber, NSMutableOrderedSet> = NSMapTable.strongToStrongObjects()
        return result
    }()
    private func clearCache() {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            validSelf.objectsCache.removeAllObjects()
        }
    }
    private lazy var timeStampsCache: NSMapTable<NSNumber, NSDate> = {
        let result: NSMapTable<NSNumber, NSDate> = NSMapTable.strongToStrongObjects()
        return result
    }()
    
    // MARK: - Initialization
    private init() {
        Logger.general.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataCache protocol
    func stationData(for stationCode: String) throws -> [StationData] {
        guard self.isCacheValid(for: stationCode) else {
            self.invalidateCache(for: stationCode)
            let message: String = Error.Message.cacheExpired
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.cacheExpired,
                                                     localizedMessage: message).error()
            throw error
        }
        var result: [StationData]!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: stationCode.hashValue)
            guard let collection: NSMutableOrderedSet = validSelf.objectsCache.object(forKey: key) else {
                let message: String = "unable to obtain object for key=\(key)"
                Logger.error.message(message)
                return
            }
            result = collection.compactMap({ (element: Any) -> StationData? in
                guard let object: StationData = element as? StationData else {
                    return nil
                }
                return object
            })
        }
        return result ?? []
    }
    
    func add(_ stationData: [StationData],
             for stationCode: String,
             shouldInvalidateExistingCache: Bool)
    {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: stationCode.hashValue)
            let collectionToAdd: NSMutableOrderedSet
            if let existingCollection: NSMutableOrderedSet = validSelf.objectsCache.object(forKey: key),
                !shouldInvalidateExistingCache
            {
                collectionToAdd = existingCollection
            }
            else {
                collectionToAdd = NSMutableOrderedSet()
            }
            collectionToAdd.addObjects(from: stationData)
            validSelf.objectsCache.setObject(collectionToAdd, forKey: key)
            
            let message: String = "added object for key=\(key)"
            Logger.error.message(message)

            
            // update time stamp
            let timeStamp: NSDate = NSDate()
            validSelf.timeStampsCache.setObject(timeStamp, forKey: key)
        }
    }
    
    func isCacheValid(for stationCode: String) -> Bool {
        var result: Bool = false
        guard let cachedTimeStamp: NSDate = self.timeStamp(for: stationCode) else {
            return result
        }
        let now: NSDate = NSDate()
        let div: TimeInterval = abs(now.timeIntervalSince1970 - cachedTimeStamp.timeIntervalSince1970)
        if div < Constants.cacheValidityInterval {
            result = true
        }
        return result
    }
    
    private func timeStamp(for stationCode: String) -> NSDate? {
        var result: NSDate!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: stationCode.hashValue)
            guard let object: NSDate = validSelf.timeStampsCache.object(forKey: key) else {
                let message: String = "unable to obtain object for key=\(key)"
                Logger.error.message(message)
                return
            }
            result = object
        }
        return result
    }
    
    func invalidateCache(for stationCode: String) {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: stationCode.hashValue)
            if let _ = validSelf.objectsCache.object(forKey: key) {
                validSelf.objectsCache.setObject(nil, forKey: key)
                
                // invalidate time stamp
                validSelf.timeStampsCache.setObject(nil, forKey: key)
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
        static var cacheValidityInterval: TimeInterval = 5 * 60
    }
}

// MARK: - Errors
private extension StationDataCacheImpl {
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName)\(String(describing: StationDataCacheImpl.Error.self))"
        
        enum Code {
            static let cacheExpired: Int = 9000
        }
        enum Message {
            static let cacheExpired: String = "cache is expired"
        }
    }
}
