//
//  StationDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol StationDependencyContainer: AnyObject {
    func getTrainMovementsRepository() -> TrainMovementRepository
}

class StationDependencyContainerImpl: StationDependencyContainer, StationViewControllerFactory {
    
    // MARK: - Properties
    private let parent: MapDependencyContainer
    private let station: Station
    
    // MARK: - Initialization
    init(parent: MapDependencyContainer,
         station: Station)
    {
        self.parent = parent
        self.station = station
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationDependencyContainer protocol
    func getTrainMovementsRepository() -> TrainMovementRepository {
        return self.parent.getTrainMovementsRepository()
    }
    
    // MARK: - StationViewControllerFactory protocol
    func makeStationViewController() -> StationViewController {
        let vm: StationViewModel = self.makeStationViewModel()
        let vc: StationViewController = StationViewController(viewModel: vm)
        { (stationData: StationData) -> TrainViewController in
            let factory: TrainViewControllerFactory = TrainDependencyContainerImpl(
                parent: self,
                stationData: stationData)
            let vc: TrainViewController = factory.makeTrainViewController()
            return vc
        }
        return vc
    }
    
    private func makeStationViewModel() -> StationViewModel {
        let model: StationModel = self.makeStationModel()
        let repository: StationDataRepository = self.parent.getStationDataRepository()
        let vm: StationViewModel = StationViewModelImpl(model: model,
                                                            repository: repository)
        return vm
    }
    
    private func makeStationModel() -> StationModel {
        let model: StationModel = StationModelImpl(station: self.station)
        return model
    }
}
