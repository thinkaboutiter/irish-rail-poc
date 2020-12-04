//
//  StationsDependencyContainer.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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
        let vc: StationsListViewController = StationsListViewController(viewModel: vm) { (station: Station) -> StationViewController in
                let factory: StationViewControllerFactory = StationDependencyContainerImpl(
                    parent: self.parent,
                    station: station)
                let vc: StationViewController = factory.makeStationViewController()
                return vc
        }
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
