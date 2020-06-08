//
//  TrainMovementViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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
