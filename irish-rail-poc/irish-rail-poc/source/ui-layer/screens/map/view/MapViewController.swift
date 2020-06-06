//
//  MapViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger
import MapKit

/// APIs for `DependecyContainer` to expose.
protocol MapViewControllerFactory {
    func makeMapViewController() -> MapViewController
}

class MapViewController: BaseViewController, MapViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: MapViewModel
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
            let latitude: Double = self.viewModel.initialLatitude()
            let longitude: Double = self.viewModel.initialLongitude()
            let radius: Double = self.viewModel.initialRadius()
            let coordinate2d: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude,
                                                                              longitude: longitude)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate2d,
                                                                latitudinalMeters: radius,
                                                                longitudinalMeters: radius)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: MapViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewModelConsumer protocol
    func didUpdateStations(on viewModel: MapViewModel) {
        // TODO: reload UI
    }
    
    func didReceiveError(on viewModel: MapViewModel, error: Error) {
        self.showAlert(for: error as NSError)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - MKMapViewDelegate protocol
extension MapViewController: MKMapViewDelegate {}
