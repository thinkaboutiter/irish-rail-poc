//
//  MapDependencyContainer.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
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
import MapKit
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
        let lm: LocationManager = self.makeLocationManager()
        let vc: MapViewController = MapViewController(
            viewModel: vm,
            locationManager: lm,
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
    
    private func makeLocationManager() -> LocationManager {
        let locationManager = CLLocationManager()
        let result = CLLocationManagerWrapper(locationManager: locationManager)
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
