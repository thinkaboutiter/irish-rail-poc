//
//  StationDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol StationDependencyContainer: AnyObject {}

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
    
    // MARK: - StationViewControllerFactory protocol
    func makeStationViewController() -> StationViewController {
        let vm: StationViewModel = self.makeStationViewModel()
        let vc: StationViewController = StationViewController(viewModel: vm)
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
