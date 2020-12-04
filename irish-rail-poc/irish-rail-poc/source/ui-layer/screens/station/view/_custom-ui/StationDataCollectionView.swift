//
//  StationDataCollectionView.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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
