//
//  TrainDependencyContainer.swift
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
