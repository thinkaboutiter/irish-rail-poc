//
//  TargetConstants.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W50-09-Dec-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

enum TargetConstants {
    static let trainMovements_xml_filename = "TrainMovements.xml"
    static let bundle: Bundle = {
        class BundleClass {}
        let result = Bundle(for: BundleClass.self)
        return result
    }()
}
