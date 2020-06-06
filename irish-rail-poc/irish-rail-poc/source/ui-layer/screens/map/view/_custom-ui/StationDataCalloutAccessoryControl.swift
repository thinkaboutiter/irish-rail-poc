//
//  StationDataCalloutAccessoryControl.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

class StationDataCalloutAccessoryControl: UIControl, StationDataCalloutAccessoryViewModelConsumer {
    
    // MARK: - Properties
    // source: https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
    private let viewModel: StationDataCalloutAccessoryViewModel
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var trainsNumberLabel: UILabel!
    @IBOutlet private weak var trainIconImageView: UIImageView!
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    }
    
    @available(*, unavailable, message: "Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    override init(frame: CGRect) {
        fatalError("Creating this control with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    }
    
    init(frame: CGRect,
         viewModel: StationDataCalloutAccessoryViewModel)
    {
        self.viewModel = viewModel
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
        Bundle.main.loadNibNamed(String(describing: StationDataCalloutAccessoryControl.self),
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
    
    // MARK: - StationDataCalloutAccessoryViewModelConsumer protocol
    func didFinishFetchngStationData(on viewModel: StationDataCalloutAccessoryViewModel) {
        // TODO: implement me
    }
    
    func didFailFetchingStationData(on viewModel: StationDataCalloutAccessoryViewModel, error: Error) {
        // TODO: implement me
    }
}
