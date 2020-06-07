//
//  CollectionViewDimensionsProvider.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

protocol CollectionViewDimensionsProvider {
    var paddingLeft: CGFloat { get }
    var paddingRight: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    var minimumLineSpacing: CGFloat { get }
    var itemsPerRow: UInt { get }
    var itemWidthToHeightRatio: CGFloat { get }
    var sectionEdgeInsets: UIEdgeInsets { get }
}
