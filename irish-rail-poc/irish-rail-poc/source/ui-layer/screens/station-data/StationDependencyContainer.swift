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
    private let stationCode: String
    
    // MARK: - Initialization
    init(parent: MapDependencyContainer,
         stationCode: String) {
        self.parent = parent
        self.stationCode = stationCode
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
        let model: StationDataModel = StationDataModelImpl(stationCode: self.stationCode)
        let result: StationViewModel = StationViewModelImpl(model: model)
        return result
    }
}
