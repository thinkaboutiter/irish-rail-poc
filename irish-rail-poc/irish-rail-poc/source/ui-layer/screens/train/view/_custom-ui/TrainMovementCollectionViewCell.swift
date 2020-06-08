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
    static var identifier: String {
        return String(describing: TrainMovementCollectionViewCell.self)
    }
    @IBOutlet private weak var trainMovementView: TrainMovementView!
    private(set) var trainMovement: TrainMovement?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trainMovementView.resetUi()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(with: 4)
    }
    
    // MARK: - Configurations
    func configure(with trainMovement: TrainMovement) {
        self.trainMovement = trainMovement
        let vm: TrainMovementViewModel = TrainMovementViewModelImpl(trainMovement: trainMovement)
        self.trainMovementView.configure(with: vm)
    }
}
