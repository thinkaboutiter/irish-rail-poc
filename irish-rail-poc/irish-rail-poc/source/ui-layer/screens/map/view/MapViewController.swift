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
            let identifier: String = String(describing: MKPinAnnotationView.self)
            self.mapView.register(MKPinAnnotationView.self,
                                  forAnnotationViewWithReuseIdentifier: identifier)
        }
    }
    @IBOutlet private weak var reloadButton: UIButton!
    
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
        let stations: [Station] = viewModel.stations()
        let annotations: [StationAnnotation] = stations.map() { StationAnnotation(station: $0) }
        self.updateAnnotations(annotations, on: self.mapView)
    }
    
    func didReceiveError(on viewModel: MapViewModel, error: Error) {
        self.showAlert(for: error as NSError)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStations()
    }
    
    // MARK: - Fetching
    private func loadStations() {
        self.viewModel.fetchStations()
    }
    
    // MARK: - Actions
    @IBAction func rouloadButtonTouchUpInside(_ sender: UIButton) {
        Logger.debug.message()
        self.loadStations()
    }
    
    // MARK: - Annotations
    private func updateAnnotations(_ annotations: [MKAnnotation], on mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}

// MARK: - MKMapViewDelegate protocol
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let stationAnnotation: StationAnnotation = annotation as? StationAnnotation else {
            return nil
        }
        let identifier: String = String(describing: MKPinAnnotationView.self)
        let annotationView: MKPinAnnotationView
        if let cachedView: MKPinAnnotationView = mapView
            .dequeueReusableAnnotationView(withIdentifier: identifier,
                                           for: stationAnnotation) as? MKPinAnnotationView {
            annotationView = cachedView
        }
        else {
            annotationView = MKPinAnnotationView(annotation: stationAnnotation,
                                                 reuseIdentifier: identifier)
        }
        annotationView.pinTintColor = .red
        annotationView.animatesDrop = false
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = self.rightCalloutAccessoryView(for: stationAnnotation)
        return annotationView
    }
    
    private func rightCalloutAccessoryView(for annotation: StationAnnotation) -> StationDataCalloutAccessoryView {
        let stationCode: String = annotation.station.code
        let webService: GetStationDataByCodeWebService = GetStationDataByCodeWebService()
        let repository: StationDataRepository = StationDataRepositoryImpl(webService: webService)
        let viewModel: StationDataCalloutAccessoryViewModel = StationDataCalloutAccessoryViewModelImpl(
            stationCode: stationCode,
            repository: repository)
        let frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 80, height: 40))
        let view: StationDataCalloutAccessoryView = StationDataCalloutAccessoryView(
            frame: frame,
            viewModel: viewModel,
            actionsConsumer: self)
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        Logger.debug.message()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        Logger.debug.message()
    }
}

extension MapViewController: StationDataCalloutAccessoryViewActionsConsumer {
    
    func didTap(on view: StationDataCalloutAccessoryView) {
        let _: String = view.viewModel.stationCode()
        
        // TODO: navigate to station data screen
    }
}
