//
//  StationsDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol StationsListDependencyContainer: AnyObject {}

class StationsListDependencyContainerImpl: StationsListDependencyContainer, StationsListViewControllerFactory {
    
    // MARK: - Properties
    private let parent: MapDependencyContainer
    
    // MARK: - Initialization
    init(parent: MapDependencyContainer) {
        self.parent = parent
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationsDependencyContainer protocol
    
    // MARK: - StationsListViewControllerFactory protocol
    func makeStationsListViewController() -> StationsListViewController {
        let vm: StationsListViewModel = self.makeStationsListViewModel()
        let vc: StationsListViewController = StationsListViewController(viewModel: vm)
        return vc
    }
    
    private func makeStationsListViewModel() -> StationsListViewModel {
        let model: StationsListModel = self.makeStationsListModel()
        let repository: StationRepository = self.parent.getStationRepository()
        let vm: StationsListViewModel = StationsListViewModelImpl(model: model,
                                                                  repository: repository)
        return vm
    }
    
    private func makeStationsListModel() -> StationsListModel {
        let model: StationsListModel = StationsListModelImpl()
        return model
    }
}
