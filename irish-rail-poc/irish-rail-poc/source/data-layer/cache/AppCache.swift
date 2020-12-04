//
//  AppCache.swift
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

/// Cache for `Station` objects for given `stationCode`
protocol StationsCache: AnyObject {
    func stations() throws -> [Station]
    func add(_ stations: [Station],
             shouldInvalidateExistingCache: Bool)
    func isStationsCacheValid() -> Bool
    func invalidateStationsCache()
}

/// Cache for `StationData` objects for given `stationCode`
protocol StationDataCache: AnyObject {
    func stationData(for stationCode: String) throws -> [StationData]
    func add(_ stationData: [StationData],
             for stationCode: String,
             shouldInvalidateExistingCache: Bool)
    func isStationDataCacheValid(for stationCode: String) -> Bool
    func invalidateStationDataCache(for stationCode: String)
}

/// Cache for `TrainMovements` objects for given `trainCode`
protocol TrainMovementsCache: AnyObject {
    func trainMovement(for trainCode: String) throws -> [TrainMovement]
    func add(_ trainMovements: [TrainMovement],
             for trainCode: String,
             shouldInvalidateExistingCache: Bool)
    func isTrainMovementsCacheValid(for trainCode: String) -> Bool
    func invalidateTrainMovementsCache(for trainCode: String)
}


/// AppCache object.
/// Singletone.
/// Manages `Station`-s, `StationData`, `TrainMovement`-s caches.
class AppCache {
    
    // MARK: - Properties
    private static let shared: AppCache = AppCache()
    static var stationsCache: StationsCache {
        return AppCache.shared
    }
    static var stationDataCache: StationDataCache {
        return AppCache.shared
    }
    static var trainMovementsCache: TrainMovementsCache {
        return AppCache.shared
    }
    private lazy var stationsCache: CacheImpl<String, Station> = {
        return CacheImpl<String, Station>(validityInterval: Constants.CacheValidityInterval.stations)
    }()
    private lazy var stationDataCache: CacheImpl<String, StationData> = {
        return CacheImpl<String, StationData>(validityInterval: Constants.CacheValidityInterval.stationData)
    }()
    private lazy var trainMovementsCache: CacheImpl<String, TrainMovement> = {
        return CacheImpl<String, TrainMovement>(validityInterval: Constants.CacheValidityInterval.trainMovements)
    }()
    
    // MARK: - Initialization
    private init() {
        Logger.general.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
}

// MARK: - Constants
private extension AppCache {
    
    enum Constants {
        enum CacheValidityInterval {
            static let stations: TimeInterval = 60 * 60
            static let stationData: TimeInterval = 5 * 60
            static let trainMovements: TimeInterval = 5 * 60
        }
        enum ReservedKey {
            static let stations: String = "\(String(describing: Constants.ReservedKey.self))-\(String(describing: Station.self))"
        }
    }
}

// MARK: - StationsCache protocol
extension AppCache: StationsCache {
    
    func stations() throws -> [Station] {
        return try self.stationsCache.objects(for: Constants.ReservedKey.stations)
    }
    
    func add(_ stations: [Station], shouldInvalidateExistingCache: Bool) {
        self.stationsCache.add(stations,
                               for: Constants.ReservedKey.stations,
                               shouldInvalidateExistingCache: shouldInvalidateExistingCache)
    }
    
    func isStationsCacheValid() -> Bool {
        return self.stationsCache.isCacheValid(for: Constants.ReservedKey.stations)
    }
    
    func invalidateStationsCache() {
        self.stationsCache.invalidateCache(for: Constants.ReservedKey.stations)
    }
}

// MARK: - StationDataCache protocol
extension AppCache: StationDataCache {
    
    func stationData(for stationCode: String) throws -> [StationData] {
        return try self.stationDataCache.objects(for: stationCode)
    }
    
    func add(_ stationData: [StationData], for stationCode: String, shouldInvalidateExistingCache: Bool) {
        self.stationDataCache.add(stationData,
                                  for: stationCode,
                                  shouldInvalidateExistingCache: shouldInvalidateExistingCache)
    }
    
    func isStationDataCacheValid(for stationCode: String) -> Bool {
        return self.stationDataCache.isCacheValid(for: stationCode)
    }
    
    func invalidateStationDataCache(for stationCode: String) {
        self.stationDataCache.invalidateCache(for: stationCode)
    }
}

// MARK: - TrainMovementsCache protocol
extension AppCache: TrainMovementsCache {
    
    func trainMovement(for trainCode: String) throws -> [TrainMovement] {
        return try self.trainMovementsCache.objects(for: trainCode)
    }
    
    func add(_ trainMovements: [TrainMovement], for trainCode: String, shouldInvalidateExistingCache: Bool) {
        self.trainMovementsCache.add(trainMovements,
                                     for: trainCode,
                                     shouldInvalidateExistingCache: shouldInvalidateExistingCache)
    }
    
    func isTrainMovementsCacheValid(for trainCode: String) -> Bool {
        return self.trainMovementsCache.isCacheValid(for: trainCode)
    }
    
    func invalidateTrainMovementsCache(for trainCode: String) {
        self.trainMovementsCache.invalidateCache(for: trainCode)
    }
}

