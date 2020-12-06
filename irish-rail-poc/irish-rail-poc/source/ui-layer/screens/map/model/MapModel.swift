//
//  MapModel.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
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

/// APIs for `ViewModel` to expose to `Model`
protocol MapModelConsumer: AnyObject {
    func didUpdateStations(on model: MapModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol MapModel: AnyObject {
    func setModelConsumer(_ newValue: MapModelConsumer)
    
    /// In degrees
    func initialLatitude() -> Double
    
    /// In degrees
    func initialLongitude() -> Double
    
    /// In meters
    func initialRadius() -> Double
    
    func stations() -> [Station]
    func setStations(_ newValue: [Station])
    func reset()
}

class MapModelImpl: MapModel {
    
    // MARK: - Properties
    private weak var modelConsumer: MapModelConsumer!
    private let latitude: Double
    private let longitude: Double
    private let radius: Double
    private var stationsCache: NSMutableOrderedSet = []
    
    // MARK: - Initialization
    init(latitude: Double, longitude: Double, radius: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapModel protocol
    func setModelConsumer(_ newValue: MapModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func initialLatitude() -> Double {
        return self.latitude
    }
    
    func initialLongitude() -> Double {
        return self.longitude
    }
    
    func initialRadius() -> Double {
        return self.radius
    }
    
    func stations() -> [Station] {
        let result: [Station] = (self.stationsCache.array as? [Station]) ?? []
        return result
    }
    
    func setStations(_ newValue: [Station]) {
        self.stationsCache.addObjects(from: newValue)
        self.modelConsumer.didUpdateStations(on: self)
    }
    
    func reset() {
        self.stationsCache.removeAllObjects()
        self.modelConsumer.didUpdateStations(on: self)
    }
}
