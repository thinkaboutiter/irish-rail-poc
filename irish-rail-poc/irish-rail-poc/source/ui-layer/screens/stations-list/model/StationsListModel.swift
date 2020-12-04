//
//  StationsModel.swift
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

/// APIs for `ViewModel` to expose to `Model`
protocol StationsListModelConsumer: AnyObject {
    func didUpdateStations(on model: StationsListModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol StationsListModel: AnyObject {
    func setModelConsumer(_ newValue: StationsListModelConsumer)
    func stations() -> [Station]
    func setStations(_ newValue: [Station])
    func reset()
}

class StationsListModelImpl: StationsListModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationsListModelConsumer!
    private var stationsCache: NSMutableOrderedSet = []
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationsModel protocol
    func setModelConsumer(_ newValue: StationsListModelConsumer) {
        self.modelConsumer = newValue
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
