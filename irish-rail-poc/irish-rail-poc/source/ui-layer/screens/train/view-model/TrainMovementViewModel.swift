//
//  TrainMovementViewModel.swift
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

/// APIs for `ViewModel` to expose to `View`
protocol TrainMovementViewModel {
    var trainDate: String { get }
    var locationCode: String { get }
    var locationFullName: String { get }
    var locationOrder: Int { get }
    var trainOrigin: String { get }
    var trainDestination: String { get }
    var scheduledArrival: String { get }
    var scheduledDeparture: String { get }
}

struct TrainMovementViewModelImpl: TrainMovementViewModel {
    
    // MARK: - Properties
    private let trainMovement: TrainMovement
    
    // MARK: - Initialization
    init(trainMovement: TrainMovement) {
        self.trainMovement = trainMovement
    }
    
    // MARK: - TrainMovementViewModel protocol
    var trainDate: String {
        return self.trainMovement.trainDate
    }
    var locationCode: String {
        return self.trainMovement.locationCode
    }
    var locationFullName: String {
        return self.trainMovement.locationFullName
    }
    var locationOrder: Int {
        return self.trainMovement.locationOrder
    }
    var trainOrigin: String {
        return self.trainMovement.trainOrigin
    }
    var trainDestination: String {
        return self.trainMovement.trainDestination
    }
    var scheduledArrival: String {
        return self.trainMovement.scheduledArrival
    }
    var scheduledDeparture: String {
        return self.trainMovement.scheduledDeparture
    }
}
