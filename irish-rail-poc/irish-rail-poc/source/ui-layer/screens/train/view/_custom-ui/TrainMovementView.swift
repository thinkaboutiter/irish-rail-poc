//
//  TrainMovementView.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class TrainMovementView: UIView {
    
    // MARK: - Properties
    // source: https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var originDestinationLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var locationOrderLabel: UILabel!
    @IBOutlet private weak var arrivalTitleLabel: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var departureTitleLabel: UILabel!
    @IBOutlet private weak var departureTImeLabel: UILabel!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        Bundle.main.loadNibNamed(String(describing: TrainMovementView.self),
                                 owner: self,
                                 options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [
          .flexibleHeight,
          .flexibleWidth
        ]
        self.contentView.backgroundColor = .clear
    }
}
