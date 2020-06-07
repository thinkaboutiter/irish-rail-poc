//
//  RootDependecyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol RootDependencyContainer: AnyObject {
    func getStationRepository() -> StationRepository
    func getStationDataRepository() -> StationDataRepository
    func getTrainMovementRepository() -> TrainMovementRepository
}

class RootDependencyContainerImpl: RootDependencyContainer, RootViewControllerFactory {
    
    // MARK: - Properties
    private let stationRepository: StationRepository
    private let stationDataRepository: StationDataRepository
    private let trainMovementRepository: TrainMovementRepository
    
    // MARK: - Initialization
    init(stationRepository: StationRepository,
         stationDataRepository: StationDataRepository,
         trainMovementRepository: TrainMovementRepository)
    {
        self.stationRepository = stationRepository
        self.stationDataRepository = stationDataRepository
        self.trainMovementRepository = trainMovementRepository
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootDependencyContainer protocol
    func getStationRepository() -> StationRepository {
        return self.stationRepository
    }
    
    func getStationDataRepository() -> StationDataRepository {
        return self.stationDataRepository
    }
    
    func getTrainMovementRepository() -> TrainMovementRepository {
        return self.trainMovementRepository
    }
    
    // MARK: - RootViewControllerFactory protocol
    func makeRootViewController() -> RootViewController {
        let vm: RootViewModel = self.makeRootViewModel()
        let factory: MapViewControllerFactory = MapDependencyContainerImpl(parent: self)
        let vc: RootViewController = RootViewController(viewModel: vm,
                                                        mapViewControllerFactory: factory)
        return vc
    }
    
    private func makeRootViewModel() -> RootViewModel {
        let model: RootModel = RootModelImpl()
        let result: RootViewModel = RootViewModelImpl(model: model)
        return result
    }
}
