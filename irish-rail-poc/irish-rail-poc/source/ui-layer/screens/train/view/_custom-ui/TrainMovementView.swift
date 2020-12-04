//
//  TrainMovementView.swift
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
