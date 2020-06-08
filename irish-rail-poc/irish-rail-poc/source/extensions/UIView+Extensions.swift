//
//  UIView+Extensions.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(with radius: CGFloat,
                      borderWidth: CGFloat = 0,
                      borderColor: UIColor = UIColor.clear)
    {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
