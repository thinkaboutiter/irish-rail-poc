//
//  StationDataViewModel.swift
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

/// APIs for `ViewModel` to expose to `View`
protocol StationDataViewModel {
    var trainCode: String { get }
    var trainDate: String { get }
    var origin: String { get }
    var originTime: String { get }
    var destination: String { get }
    var destinationTime: String { get }
    var dueIn: Int { get }
    var late: Int { get }
    var expectedArrival: String { get }
}

struct StationDataViewModelImpl: StationDataViewModel {
    
    // MARK: - Properties
    private let stationData: StationData
    
    // MARK: - Initialization
    init(stationData: StationData) {
        self.stationData = stationData
    }
    
    // MARK: - StationDataViewModel protocol
    var trainCode: String {
        return self.stationData.trainCode
    }
    var trainDate: String {
        return self.stationData.trainDate
    }
    var origin: String {
        return self.stationData.origin
    }
    var originTime: String {
        return self.stationData.originTime
    }
    var destination: String {
        return self.stationData.destination
    }
    var destinationTime: String {
        return self.stationData.destinationTime
    }
    var dueIn: Int {
        return self.stationData.dueIn
    }
    var late: Int {
        return self.stationData.late
    }
    var expectedArrival: String {
        return self.stationData.expectedArrival
    }
}
