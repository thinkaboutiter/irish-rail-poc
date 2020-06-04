//
//  MapDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol MapDependencyContainer: AnyObject {}

class MapDependencyContainerImpl: MapDependencyContainer, MapViewControllerFactory {
    
    // MARK: - Properties
    private let parent: RootDependencyContainer
    
    // MARK: - Initialization
    init(parent: RootDependencyContainer) {
        self.parent = parent
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewControllerFactory protocol
    func makeMapViewController() -> MapViewController {
        let vm: MapViewModel = self.makeMapViewModel()
        let vc: MapViewController = MapViewController(viewModel: vm)
        return vc
    }
    
    private func makeMapViewModel() -> MapViewModel {
        let model: MapModel = self.makeMapModel()
        let result: MapViewModel = MapViewModelImpl(model: model)
        return result
    }
    
    private func makeMapModel() -> MapModel {
        let result: MapModel = MapModelImpl(latitude: Location.Ireland.latitude,
                                            longitude: Location.Ireland.longitude,
                                            radius: Location.Ireland.radius)
        return result
    }
}

private extension MapDependencyContainerImpl {
    
    enum Location {
        enum Ireland {
            static let latitude: Double = 53.344276
            static let longitude: Double = -8.001062
            static let radius: Double = 100_000
        }
    }
}
