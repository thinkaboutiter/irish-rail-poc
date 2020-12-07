//
//  UserAnnotationView.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W50-07-Dec-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import MapKit
import SimpleLogger

class UserAnnotationView: MKAnnotationView {
    
    // MARK: - Properties
    static let identifier: String = String(describing: UserAnnotationView.self)
    
    // MARK: - Initialization
    @available(*, unavailable, message: "init(coder:) is not available")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not available")
    }
    
    init(annotation: UserAnnotation) {
        super.init(annotation: annotation, reuseIdentifier: Self.identifier)
        image = UIImage(named: AppConstants.AssetName.userLocationPin)?.withRenderingMode(.alwaysTemplate).withTintColor(.red)
    }
}
