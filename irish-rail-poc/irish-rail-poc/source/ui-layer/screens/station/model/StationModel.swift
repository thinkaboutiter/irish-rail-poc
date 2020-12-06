//
//  StationModel.swift
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
protocol StationModelConsumer: AnyObject {
    func didUpdateStationData(on viewModel: StationModel)
}

/// APIs for `Model` to expose to `ViewModel`
protocol StationModel: AnyObject {
    func setModelConsumer(_ newValue: StationModelConsumer)
    func station() -> Station
    func stationData() -> [StationData]
    func setStationData(_ newValue: [StationData])
}

class StationModelImpl: StationModel {
    
    // MARK: - Properties
    private weak var modelConsumer: StationModelConsumer!
    private let stationStorage: Station
    private var stationDataStorage: [StationData] = []
    
    // MARK: - Initialization
    init(station: Station) {
        self.stationStorage = station
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationModel protocol
    func setModelConsumer(_ newValue: StationModelConsumer) {
        self.modelConsumer = newValue
    }
    
    func station() -> Station {
        return self.stationStorage
    }
    
    func stationData() -> [StationData] {
        if self.isUsingStubData {
            return self.stubData()
        }
        else {
            return self.stationDataStorage
        }
    }
    
    func setStationData(_ newValue: [StationData]) {
        self.stationDataStorage = newValue
        self.modelConsumer.didUpdateStationData(on: self)
    }
}

// MARK: - Stub data
private extension StationModelImpl {
    private var isUsingStubData: Bool {
        return false
    }
    
    func stubData() -> [StationData] {
        let data: StationData = StationData(serverTime: "n/a",
                                            trainCode: "E777",
                                            stationFullName: "Malahide",
                                            stationCode: "MHIDE",
                                            queryTime: "n/a",
                                            trainDate: "03 Jun 2020",
                                            origin: "Greystones",
                                            destination: "Malahide",
                                            originTime: "07:20",
                                            destinationTime: "08:38",
                                            status: "En Route",
                                            lastLocation: "Departed Portmarnock",
                                            dueIn: 5,
                                            late: 7,
                                            expectedArrival: "08:40",
                                            expectedDeparture: "00:00",
                                            scheduleArrival: "08:37",
                                            scheduleDeparture: "00:00",
                                            direction: "Northbound",
                                            trainType: "DART",
                                            locationType: "D")
        let result: [StationData] = Array<StationData>.init(repeating: data, count: 20)
        return result
    }
}
