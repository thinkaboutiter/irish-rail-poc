//
//  StationDataCalloutAccessoryView.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

protocol StationDataCalloutAccessoryViewActionsConsumer: AnyObject {
    func didTap(on view: StationDataCalloutAccessoryView)
}

class StationDataCalloutAccessoryView: UIView, StationDataCalloutAccessoryViewModelConsumer {
    
    // MARK: - Properties
    // source: https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
    let viewModel: StationDataCalloutAccessoryViewModel
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var trainsCountLabel: UILabel!
    @IBOutlet private weak var trainIconImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private weak var actionsConsumer: StationDataCalloutAccessoryViewActionsConsumer!
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let result = UITapGestureRecognizer(target: self, action: #selector(self.contentTapped(_:)))
        result.numberOfTouchesRequired = 1
        result.numberOfTapsRequired = 1
        return result
    }()
    
    @objc private func contentTapped(_ sender: UITapGestureRecognizer) {
        self.actionsConsumer.didTap(on: self)
    }
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this control with `init()` is unsupported in favor of initializer dependency injection.")
    init() {
        fatalError("Creating this control with `init()` is unsupported in favor of initializer dependency injection.")
    }
    @available(*, unavailable, message: "Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    }
    
    @available(*, unavailable, message: "Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    override init(frame: CGRect) {
        fatalError("Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    }
    
    init(frame: CGRect,
         viewModel: StationDataCalloutAccessoryViewModel,
         actionsConsumer: StationDataCalloutAccessoryViewActionsConsumer)
    {
        self.viewModel = viewModel
        self.actionsConsumer = actionsConsumer
        super.init(frame: frame)
        self.commonInit()
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
        self.viewModel.cancelStationDataFetching()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        Bundle.main.loadNibNamed(String(describing: StationDataCalloutAccessoryView.self),
                                 owner: self,
                                 options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [
          .flexibleHeight,
          .flexibleWidth
        ]
        self.contentView.backgroundColor = .clear
        self.contentView.addGestureRecognizer(self.tapGestureRecognizer)
        self.contentView.isUserInteractionEnabled = true
        self.enableTrainsCountLabel(self.trainsCountLabel,
                                    with: Constants.notAvailableText,
                                    shouldEnable: false)
        self.enableActivityIndicator(self.activityIndicator,
                                     shouldEnable: true)
    }
    
    // MARK: - Fetching
    func fetchStationData() {
        self.viewModel.fetchStationData()
    }
    
    func cancelStationDataFetching() {
        self.viewModel.cancelStationDataFetching()
    }
    
    // MARK: - StationDataCalloutAccessoryViewModelConsumer protocol
    func didFinishFetchngStationData(on viewModel: StationDataCalloutAccessoryViewModel) {
        self.enableActivityIndicator(self.activityIndicator,
                                     shouldEnable: false)
        let text = "\(viewModel.trainsCount())"
        self.enableTrainsCountLabel(self.trainsCountLabel,
                                    with: text,
                                    shouldEnable: true)
    }
    
    func didFailFetchingStationData(on viewModel: StationDataCalloutAccessoryViewModel, error: Error) {
        self.enableActivityIndicator(self.activityIndicator,
                                     shouldEnable: false)
        self.enableTrainsCountLabel(self.trainsCountLabel,
                                    with: Constants.notAvailableText,
                                    shouldEnable: true)
    }
    
    private func enableActivityIndicator(_ activityIndicator: UIActivityIndicatorView,
                                         shouldEnable: Bool)
    {
        activityIndicator.isHidden = !shouldEnable
        if shouldEnable {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func enableTrainsCountLabel(_ label: UILabel,
                                        with text: String,
                                        shouldEnable: Bool)
    {
        label.isHidden = !shouldEnable
        label.text = text
    }
}

// MARK: - Constatns
private extension StationDataCalloutAccessoryView {
    
    enum Constants {
        static let notAvailableText: String = NSLocalizedString("N/A", comment: "N/A")
    }
}
