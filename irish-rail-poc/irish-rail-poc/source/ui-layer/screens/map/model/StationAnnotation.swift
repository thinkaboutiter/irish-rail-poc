//
//  StationAnnotation.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-06-Jun-Sat.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import MapKit
import SimpleLogger

class StationAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    private let station: Station
    
    // MARK: - Initialization
    init(station: Station) {
        self.station = station
        super.init()
    }
    
    // MARK: - MKAnnotation protocol
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.station.latitude,
                                      longitude: self.station.longitude)
    }
    var title: String? {
        return self.station.desc
    }
    var subtitle: String? {
        return self.station.code
    }
}
