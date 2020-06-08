//
//  StationDataView.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class StationDataView: UIView {
    
    // MARK: - Properties
    // source: https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var trainCodeLabel: UILabel!
    @IBOutlet private weak var trainDateLabel: UILabel!
    @IBOutlet private weak var titleContainerView: UIView!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var originTimeLabel: UILabel!
    @IBOutlet private weak var destinationLabel: UILabel!
    @IBOutlet private weak var destinationTimeLabel: UILabel!
    @IBOutlet private weak var dueInTitleLabel: UILabel!
    @IBOutlet private weak var dueInTimeLabel: UILabel!
    @IBOutlet private weak var lateTitleLabel: UILabel!
    @IBOutlet private weak var lateTimeLabel: UILabel!
    @IBOutlet private weak var expArrivalTitleLabel: UILabel!
    @IBOutlet private weak var expArrivalTimeLabel: UILabel!
    private var viewModel: StationDataViewModel!
    
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
        Bundle.main.loadNibNamed(String(describing: StationDataView.self),
                                 owner: self,
                                 options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [
          .flexibleHeight,
          .flexibleWidth
        ]
        self.contentView.backgroundColor = .clear
        self.reset()
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleContainerView.roundCorners(with: 4)
    }
    
    // MARK: - Configuration
    func configure(with viewModel: StationDataViewModel) {
        self.viewModel = viewModel
        self.configureUi(with: viewModel)
    }
    
    private func configureUi(with viewModel: StationDataViewModel) {
        self.trainCodeLabel.text = "train \(viewModel.trainCode)".uppercased()
        self.trainDateLabel.text = viewModel.trainDate.uppercased()
        self.originLabel.text = viewModel.origin.uppercased()
        self.originTimeLabel.text = viewModel.originTime
        self.destinationLabel.text = viewModel.destination.uppercased()
        self.destinationTimeLabel.text = viewModel.destinationTime
        self.dueInTitleLabel.text = "due in".uppercased()
        self.dueInTimeLabel.text = "\(viewModel.dueIn)"
        self.lateTitleLabel.text = "late".uppercased()
        self.lateTimeLabel.text = "\(viewModel.late)"
        self.expArrivalTitleLabel.text = "exp arrival".uppercased()
        self.expArrivalTimeLabel.text = viewModel.expectedArrival
    }
    
    func reset() {
        self.trainCodeLabel.text = "train N/A".uppercased()
        self.trainDateLabel.text = "N/A"
        self.originLabel.text = "origin".uppercased()
        self.originTimeLabel.text = "N/A"
        self.destinationLabel.text = "destination".uppercased()
        self.destinationTimeLabel.text = "N/A"
        self.dueInTitleLabel.text = "due in".uppercased()
        self.dueInTimeLabel.text = "N/A"
        self.lateTitleLabel.text = "late".uppercased()
        self.lateTimeLabel.text = "N/A"
        self.expArrivalTitleLabel.text = "exp arrival".uppercased()
        self.expArrivalTimeLabel.text = "N/A"
    }
}
