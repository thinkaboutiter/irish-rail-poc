//
//  LocationManager.swift
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
import CoreLocation
import SimpleLogger

protocol LocationManagerUpdatesConsumer: AnyObject {
    func didFailToUpdateLocation(from manager: LocationManager,
                                 error: Swift.Error)
    func didUpdateLocation(form manager: LocationManager,
                           location: CLLocationCoordinate2D)
}

protocol LocationManager: AnyObject {
    func setUpdatesConsumer(_ newValue: LocationManagerUpdatesConsumer)
    func getUserLocation()
}

class CLLocationManagerWrapper: NSObject {
    
    // MARK: - Properties
    private weak var updatesConsumer: LocationManagerUpdatesConsumer?
    private let locationManager: CLLocationManager
    
    // MARK: - Initialization
    @available(*, unavailable, message: "init() is unavailable!")
    override init() {
        fatalError("init() is unavailable")
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
}

// MARK: - LocationManager protocol
extension CLLocationManagerWrapper: LocationManager {
    
    func setUpdatesConsumer(_ newValue: LocationManagerUpdatesConsumer) {
        updatesConsumer = newValue
    }
    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
    }
    
    private func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            let error = Self.Error.error(from: Self.Error.locationServicesNotEnabled)
            updatesConsumer?.didFailToUpdateLocation(from: self, error: error)
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    private func failToObtainLocation(with error: Swift.Error) {
        updatesConsumer?.didFailToUpdateLocation(from: self, error: error)
    }
}

// MARK: - CLLocationManagerDelegate protocol
extension CLLocationManagerWrapper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
        handleLocationManagerDidChangeAuthorizationSatus(status)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        handleLocationManagerDidChangeAuthorizationSatus(status)
    }
    
    private func handleLocationManagerDidChangeAuthorizationSatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            startUpdatingLocation()
        case .notDetermined:
            getUserLocation()
        default:
            let error = Self.Error.error(from: Self.Error.locationUnauthorized)
            failToObtainLocation(with: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let mUserLocation: CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude,
                                            longitude: mUserLocation.coordinate.longitude)
        updatesConsumer?.didUpdateLocation(form: self, location: center)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Swift.Error)
    {
        failToObtainLocation(with: error)
    }
}

// MARK: - Errors
extension CLLocationManagerWrapper {
    
    private enum Error {
        
        typealias Parameters = (code: Int, message: String)
        
        static let domain: String = {
            return "\(AppConstants.projectName)-\(String(describing: CLLocationManagerWrapper.Error.self))"
        }()
        
        static func error(from parameters: Error.Parameters) -> NSError {
            let error = ErrorCreator
                .custom(domain: Self.domain,
                        code: parameters.code,
                        localizedMessage: parameters.message)
                .error()
            return error
        }
        
        static let notImplemented: Error.Parameters = {
            let code: Int = 9000
            let message: String = NSLocalizedString("Not implemented.", comment: "Not implemented.")
            return (code, message)
        }()
        
        static let locationUnauthorized: Error.Parameters = {
            let code: Int = 9001
            let message: String = NSLocalizedString("Location usage unauthorized.", comment: "Location usage unauthorized.")
            return (code, message)
        }()
        
        static let locationServicesNotEnabled: Error.Parameters = {
            let code: Int = 9002
            let message: String = NSLocalizedString("Location Services are not enabled.", comment: "Location Services are not enabled.")
            return (code, message)
        }()
    }
}
