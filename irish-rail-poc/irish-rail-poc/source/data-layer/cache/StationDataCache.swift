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
    func add(_ stationData: [StationData], for stationCode: String) -> Bool
    func isCacheValid(for stationCode: String) -> Bool
    func invalidateCache(for stationCode: String) -> Bool
}

class StationDataCacheImpl: StationDataCache {
    
    // MARK: - Properties
    static let shared: StationDataCache = StationDataCacheImpl()
    
    // MARK: - Initialization
    private init() {
        Logger.general.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDataCache protocol
    func stationData(for stationCode: String) -> [StationData] {
        let result: [StationData] = []
        
        // TODO: implement me
        
        return result
    }
    
    func add(_ stationData: [StationData], for stationCode: String) -> Bool {
        let result: Bool = false
        
        // TODO: implement me
        
        return result
    }
    
    func isCacheValid(for stationCode: String) -> Bool {
        let result: Bool = false
        
        // TODO: implement me
        
        return result
    }
    
    func invalidateCache(for stationCode: String) -> Bool {
        let result: Bool = false
        
        // TODO: implement me
        
        return result
    }
}


