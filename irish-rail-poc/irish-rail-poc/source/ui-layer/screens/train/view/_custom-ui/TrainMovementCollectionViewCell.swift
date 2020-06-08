//
//  TrainMovementCollectionViewCell.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class TrainMovementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet private weak var trainMovementView: TrainMovementView!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
