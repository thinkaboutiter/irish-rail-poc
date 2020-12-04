//
//  MapDependencyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol MapDependencyContainer: AnyObject {
    func getStationRepository() -> StationRepository
    func getStationDataRepository() -> StationDataRepository
    func getTrainMovementsRepository() -> TrainMovementRepository
}

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
    
    // MARK: - MapDependencyContainer protocol
    func getStationRepository() -> StationRepository {
        return self.parent.getStationRepository()
    }
    
    func getStationDataRepository() -> StationDataRepository {
        return self.parent.getStationDataRepository()
    }
    
    func getTrainMovementsRepository() -> TrainMovementRepository {
        return self.parent.getTrainMovementRepository()
    }
    
    // MARK: - MapViewControllerFactory protocol
    func makeMapViewController() -> MapViewController {
        let vm: MapViewModel = self.makeMapViewModel()
        let vc: MapViewController = MapViewController(
            viewModel: vm,
            makeStationViewControllerWith: { (station: Station) -> StationViewController in
                let factory: StationViewControllerFactory = StationDependencyContainerImpl(
                    parent: self,
                    station: station)
                let vc: StationViewController = factory.makeStationViewController()
                return vc
        }) { () -> StationsListViewController in
            let factory: StationsListViewControllerFactory = StationsListDependencyContainerImpl(parent: self)
            let vc: StationsListViewController = factory.makeStationsListViewController()
            return vc
        }

        return vc
    }
    
    private func makeMapViewModel() -> MapViewModel {
        let model: MapModel = self.makeMapModel()
        let repository: StationRepository = self.parent.getStationRepository()
        let result: MapViewModel = MapViewModelImpl(model: model,
                                                    repository: repository)
        return result
    }
    
    private func makeMapModel() -> MapModel {
        let result: MapModel = MapModelImpl(latitude: Location.Ireland.latitude,
                                            longitude: Location.Ireland.longitude,
                                            radius: Location.Ireland.radius)
        return result
    }
}

// MARK: - Location
private extension MapDependencyContainerImpl {
    
    enum Location {
        enum Ireland {
            static let latitude: Double = 53.344276
            static let longitude: Double = -8.001062
            static let radius: Double = 400_000
        }
    }
}
