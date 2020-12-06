//
//  StationDataView.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
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
        self.resetUi()
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
        self.trainCodeLabel.text = "\(NSLocalizedString("train", comment: "train")) \(viewModel.trainCode)".uppercased()
        self.trainDateLabel.text = viewModel.trainDate.uppercased()
        self.originLabel.text = viewModel.origin.uppercased()
        self.originTimeLabel.text = viewModel.originTime
        self.destinationLabel.text = viewModel.destination.uppercased()
        self.destinationTimeLabel.text = viewModel.destinationTime
        self.dueInTitleLabel.text = NSLocalizedString("due in", comment: "due in").uppercased()
        self.dueInTimeLabel.text = "\(viewModel.dueIn)"
        self.lateTitleLabel.text = NSLocalizedString("late", comment: "late").uppercased()
        self.lateTimeLabel.text = "\(viewModel.late)"
        self.expArrivalTitleLabel.text = NSLocalizedString("exp arrival", comment: "exp arrival").uppercased()
        self.expArrivalTimeLabel.text = viewModel.expectedArrival
    }
    
    func resetUi() {
        self.trainCodeLabel.text = NSLocalizedString("train N/A", comment: "train N/A").uppercased()
        self.trainDateLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.originLabel.text = NSLocalizedString("origin", comment: "origin").uppercased()
        self.originTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.destinationLabel.text = NSLocalizedString("destination", comment: "destination").uppercased()
        self.destinationTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.dueInTitleLabel.text = NSLocalizedString("due in", comment: "due in").uppercased()
        self.dueInTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.lateTitleLabel.text = NSLocalizedString("late", comment: "late").uppercased()
        self.lateTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
        self.expArrivalTitleLabel.text = NSLocalizedString("exp arrival", comment: "exp arrival").uppercased()
        self.expArrivalTimeLabel.text = NSLocalizedString("N/A", comment: "N/A")
    }
}
