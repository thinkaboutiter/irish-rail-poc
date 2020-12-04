//
//  StationDependencyContainer.swift
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
