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
    @IBOutlet private weak var locationCodeLabel: UILabel!
    @IBOutlet private weak var locationOrderLabel: UILabel!
    @IBOutlet private weak var arrivalTitleLabel: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var departureTitleLabel: UILabel!
    @IBOutlet private weak var departureTImeLabel: UILabel!
    private var viewModel: TrainMovementViewModel!
    
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
        self.resetUi()
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleContainerView.roundCorners(with: 4)
    }
    
    // MARK: - Configurations
    func configure(with viewModel: TrainMovementViewModel) {
        self.viewModel = viewModel
        self.configureUi(with: viewModel)
    }
    
    private func configureUi(with viewModel: TrainMovementViewModel) {
        self.originDestinationLabel.text = "\(viewModel.trainOrigin) - \(viewModel.trainDestination)".uppercased()
        self.dateLabel.text = viewModel.trainDate.uppercased()
        self.locationLabel.text = viewModel.locationFullName.uppercased()
        self.locationCodeLabel.text = viewModel.locationCode.uppercased()
        self.locationOrderLabel.text = "(\(viewModel.locationOrder))"
        self.arrivalTitleLabel.text = NSLocalizedString("arrival", comment: "arrival").uppercased()
        self.arrivalTimeLabel.text = "(\(viewModel.scheduledArrival))"
        self.departureTitleLabel.text = NSLocalizedString("departure", comment: "departure").uppercased()
        self.departureTImeLabel.text = "(\(viewModel.scheduledDeparture))"
    }
    
    func resetUi() {
        self.originDestinationLabel.text = NSLocalizedString("N/A - N/A", comment: "N/A - N/A")
        self.dateLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.locationLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.locationCodeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.locationOrderLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.arrivalTitleLabel.text = NSLocalizedString("arrival", comment: "arrival").uppercased()
        self.arrivalTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.departureTitleLabel.text = NSLocalizedString("departure", comment: "departure").uppercased()
        self.departureTImeLabel.text = NSLocalizedString("N/A", comment: "N/A")
    }
}
