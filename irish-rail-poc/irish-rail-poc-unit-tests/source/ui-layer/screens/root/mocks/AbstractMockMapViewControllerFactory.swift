//
//  AbstractMockMapViewControllerFactory.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-03-Dec-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockMapViewControllerFactory: MapViewControllerFactory {
    
    func makeMapViewController() -> MapViewController {
        fatalError("not implemented!")
    }
}