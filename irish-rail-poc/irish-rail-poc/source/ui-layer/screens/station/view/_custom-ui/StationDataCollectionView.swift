//
//  StationDataCollectionView.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class StationDataCollectionView: UICollectionView {}

extension StationDataCollectionView: CollectionViewDimensionsProvider {
    
    var paddingLeft: CGFloat {
        return Dimensions.paddingLeft
    }
    
    var paddingRight: CGFloat {
        return Dimensions.paddingRight
    }
    
    var minimumInteritemSpacing: CGFloat {
        return Dimensions.minimumInteritemSpacing
    }
    
    var minimumLineSpacing: CGFloat {
        return Dimensions.minimumLineSpacing
    }
    
    var itemsPerRow: UInt {
        return Dimensions.itemsPerRow
    }
    
    var itemWidthToHeightRatio: CGFloat {
        return Dimensions.itemWidthToHeightRatio
    }
    
    var sectionEdgeInsets: UIEdgeInsets {
        return Dimensions.sectionEdgeInsets
    }
}

// MARK: - Dimensions
private extension StationDataCollectionView {
    
    enum Dimensions {
        static let paddingLeft: CGFloat = 8
        static let paddingRight: CGFloat = 8
        static let minimumInteritemSpacing: CGFloat = 8
        static let minimumLineSpacing: CGFloat = 8
        static var itemsPerRow: UInt {
            let result: UInt
            let width: CGFloat = UIScreen.main.bounds.width
            let height: CGFloat = UIScreen.main.bounds.height
            if UIDevice.current.userInterfaceIdiom == .phone {
                if height > width {
                    result = 2
                }
                else {
                    result = 4
                }
            }
            else {
                result = 3
            }
            return result
        }
        static var itemWidthToHeightRatio: CGFloat {
            let result: CGFloat
            if UIDevice.current.userInterfaceIdiom == .phone {
                result = 240.0 / 220.0
            }
            else {
                result = 240.0 / 180.0
            }
            return result
        }
        static var sectionEdgeInsets: UIEdgeInsets {
            return UIEdgeInsets(top: self.minimumLineSpacing,
                                left: self.paddingLeft,
                                bottom: self.minimumLineSpacing,
                                right: self.paddingRight)
        }
    }
}