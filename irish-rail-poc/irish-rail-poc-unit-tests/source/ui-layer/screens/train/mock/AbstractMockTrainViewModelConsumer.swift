//
//  AbstractMockTrainViewModelConsumer.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W50-09-Dec-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockTrainViewModelConsumer: TrainViewModelConsumer {
    
    func didFinishFetchingTrainMovements(on viewModel: TrainViewModel) {
        fatalError("not implemented!")
    }
    
    func didFailFetchingTrainMovements(on viewModel: TrainViewModel, error: Error) {
        fatalError("not implemented!")
    }
}
