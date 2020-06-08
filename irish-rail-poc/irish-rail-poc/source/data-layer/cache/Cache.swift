//
//  GenericCache.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// Generic cache for app model types
protocol Cache: AnyObject {
    associatedtype ValueType
    associatedtype KeyType
    func objects(for key: KeyType) throws -> [ValueType]
    func add(_ objects: [ValueType],
             for key: KeyType,
             shouldInvalidateExistingCache: Bool)
    func isCacheValid(for key: KeyType) -> Bool
    func invalidateCache(for key: KeyType)
}

class CacheImpl<K: Hashable, V>: Cache {
    typealias KeyType = K
    typealias ValueType = V
    
    // MARK: - Properties
    private let validityInterval: TimeInterval
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
    
    // MARK: - Intialization
    init(validityInterval: TimeInterval) {
        self.validityInterval = validityInterval
    }
    
    // MARK: - ResponseObjectsCache protocol
    func objects(for key: K) throws -> [V] {
        guard self.isCacheValid(for: key) else {
            self.invalidateCache(for: key)
            let message: String = Error.Message.cacheExpired
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.cacheExpired,
                                                     localizedMessage: message).error()
            throw error
        }
        var result: [V]!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let validSelf = self else {
                return
            }
            let keyHash: NSNumber = NSNumber(value: key.hashValue)
            guard let collection: NSMutableOrderedSet = validSelf.objectsCache.object(forKey: keyHash) else {
                let message: String = "unable to obtain object for key=\(keyHash)"
                Logger.error.message(message)
                return
            }
            result = collection.compactMap({ (element: Any) -> V? in
                guard let object: V = element as? V else {
                    return nil
                }
                return object
            })
        }
        return result ?? []
    }
    
    func add(_ objects: [V],
             for key: K,
             shouldInvalidateExistingCache: Bool)
    {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let keyHash: NSNumber = NSNumber(value: key.hashValue)
            let collectionToAdd: NSMutableOrderedSet
            if let existingCollection: NSMutableOrderedSet = validSelf.objectsCache.object(forKey: keyHash),
                !shouldInvalidateExistingCache
            {
                collectionToAdd = existingCollection
            }
            else {
                collectionToAdd = NSMutableOrderedSet()
            }
            collectionToAdd.addObjects(from: objects)
            validSelf.objectsCache.setObject(collectionToAdd, forKey: keyHash)
            
            let message: String = "added object for key=\(keyHash)"
            Logger.error.message(message)

            
            // update time stamp
            let timeStamp: NSDate = NSDate()
            validSelf.timeStampsCache.setObject(timeStamp, forKey: keyHash)
        }
    }
    
    func isCacheValid(for key: K) -> Bool {
        var result: Bool = false
        guard let cachedTimeStamp: NSDate = self.timeStamp(for: key) else {
            return result
        }
        let now: NSDate = NSDate()
        let div: TimeInterval = abs(now.timeIntervalSince1970 - cachedTimeStamp.timeIntervalSince1970)
        if div < self.validityInterval {
            result = true
        }
        return result
    }
    
    private func timeStamp(for key: K) -> NSDate? {
        var result: NSDate!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: key.hashValue)
            guard let object: NSDate = validSelf.timeStampsCache.object(forKey: key) else {
                let message: String = "unable to obtain object for key=\(key)"
                Logger.error.message(message)
                return
            }
            result = object
        }
        return result
    }
    
    func invalidateCache(for key: K) {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let validSelf = self else {
                return
            }
            let key: NSNumber = NSNumber(value: key.hashValue)
            if let _ = validSelf.objectsCache.object(forKey: key) {
                validSelf.objectsCache.setObject(nil, forKey: key)
                
                // invalidate time stamp
                validSelf.timeStampsCache.setObject(nil, forKey: key)
            }
        }
    }
}

// MARK: - Constants
private extension CacheImpl {
    
    private enum Constants {
        static var concurrentQueueLabel: String {
            return "\(AppConstants.projectName)-\(String(describing: CacheImpl.self))-\(String(describing: V.self))-concurrent-queue"
        }
    }
}

// MARK: - Errors
private extension CacheImpl {
    
    enum Error {
        static var domain: String {
            return "\(AppConstants.projectName)\(String(describing: CacheImpl.Error.self))"
        }
        
        enum Code {
            static var cacheExpired: Int {
                return 9000
            }
        }
        enum Message {
            static var cacheExpired: String {
                return "cache is expired"
            }
        }
    }
}