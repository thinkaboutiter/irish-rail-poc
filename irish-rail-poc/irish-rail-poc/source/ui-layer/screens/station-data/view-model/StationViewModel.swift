//
//  StationViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `View` to expose to `ViewModel`
protocol StationDataViewModelConsumer: AnyObject {}

/// APIs for `ViewModel` to expose to `View`
protocol StationViewModel: AnyObject {
    func setViewModelConsumer(_ newValue: StationDataViewModelConsumer)
}

class StationViewModelImpl: StationViewModel, StationDataModelConsumer {
    
    // MARK: - Properties
    private let model: StationDataModel
    private weak var viewModelConsumer: StationDataViewModelConsumer!
    
    // MARK: - Initialization
    init(model: StationDataModel) {
        self.model = model
        self.model.setModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationViewModel protocol
    func setViewModelConsumer(_ newValue: StationDataViewModelConsumer) {
        self.viewModelConsumer = newValue
    }
    
    // MARK: - StationModelConsumer protocol
}
