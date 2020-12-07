//
//  MapViewController.swift
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
    private let locationManager: LocationManager
    private let makeStationViewControllerWith: ((_ station: Station) -> StationViewController)
    private let makeStationsListViewController: (() -> StationsListViewController)
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
    
    init(viewModel: MapViewModel,
         locationManager: LocationManager,
         makeStationViewControllerWith: @escaping ((_ station: Station) -> StationViewController),
         makeStationsListViewController: @escaping (() -> StationsListViewController))
    {
        self.viewModel = viewModel
        self.locationManager = locationManager
        self.makeStationViewControllerWith = makeStationViewControllerWith
        self.makeStationsListViewController = makeStationsListViewController
        super.init(nibName: String(describing: MapViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        self.locationManager.setUpdatesConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewModelConsumer protocol
    func didUpdateStations(on viewModel: MapViewModel) {
        let stations: [Station] = viewModel.items()
        let annotations: [StationAnnotation] = stations.map() { StationAnnotation(station: $0) }
        self.updateAnnotations(annotations, on: self.mapView)
    }
    
    func didReceiveError(on viewModel: MapViewModel, error: Error) {
        self.showAlert(for: error as NSError)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.loadStations()
    }
    
    // MARK: - UI configs
    private func configureUi() {
        // used only for development
        self.reloadButton.isHidden = true
        self.title = NSLocalizedString("Stations map", comment: "Stations map")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(self.showList))
    }
    
    @objc private func showList() {
        let vc = self.makeStationsListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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

// MARK: - LocationManagerUpdatesConsumer protocol
extension MapViewController: LocationManagerUpdatesConsumer {
    
    func didFailToUpdateLocation(from manager: LocationManager,
                                 error: Error)
    {
        showAlert(for: error)
    }
    
    func didUpdateLocation(form manager: LocationManager,
                           location: CLLocationCoordinate2D)
    {
        let annotation = UserAnnotation(coordinate: location)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: location,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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
        let station: Station = annotation.station
        let webService: GetStationDataByCodeWebService = GetStationDataByCodeWebService()
        let repository: StationDataRepository = StationDataRepositoryImpl(webService: webService)
        let viewModel: StationDataCalloutAccessoryViewModel = StationDataCalloutAccessoryViewModelImpl(
            station: station,
            repository: repository)
        let frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 80, height: 40))
        let view: StationDataCalloutAccessoryView = StationDataCalloutAccessoryView(
            frame: frame,
            viewModel: viewModel,
            actionsConsumer: self)
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let accessoryView: StationDataCalloutAccessoryView = view.rightCalloutAccessoryView as? StationDataCalloutAccessoryView else {
            return
        }
        accessoryView.fetchStationData()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let accessoryView: StationDataCalloutAccessoryView = view.rightCalloutAccessoryView as? StationDataCalloutAccessoryView else {
            return
        }
        accessoryView.cancelStationDataFetching()
    }
}

// MARK: - StationDataCalloutAccessoryViewActionsConsumer protocol
extension MapViewController: StationDataCalloutAccessoryViewActionsConsumer {
    
    func didTap(on view: StationDataCalloutAccessoryView) {
        guard view.viewModel.trainsCount() > 0 else {
            return
        }
        let station: Station = view.viewModel.station()
        let vc: StationViewController = self.makeStationViewControllerWith(station)
        let nc: UINavigationController = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
}
