//
//  TrainDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol TrainDependencyContainer: AnyObject {}

class TrainDependencyContainerImpl: TrainDependencyContainer, TrainViewControllerFactory {
    
    // MARK: - Properties
    private let parent: StationDependencyContainer
    private let stationData: StationData
    
    // MARK: - Initialization
    init(parent: StationDependencyContainer,
         stationData: StationData)
    {
        self.parent = parent
        self.stationData = stationData
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - TrainDependencyContainer protocol
    
    // MARK: - TrainViewControllerFactory protocol
    func makeTrainViewController() -> TrainViewController {
        let vm: TrainViewModel = self.makeTrainViewModel()
        let vc: TrainViewController = TrainViewController(viewModel: vm)
        return vc
    }
    
    private func makeTrainViewModel() -> TrainViewModel {
        let model: TrainModel = self.makeTrainModel()
        let repository: TrainMovementRepository = self.parent.getTrainMovementsRepository()
        let vm: TrainViewModel = TrainViewModelImpl(model: model,
                                                    repository: repository)
        return vm
    }
    
    private func makeTrainModel() -> TrainModel {
        let model: TrainModel = TrainModelImpl(stationData: self.stationData)
        return model
    }
}
