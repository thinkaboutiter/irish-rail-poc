//
//  TrainViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol TrainViewControllerFactory {
    func makeTrainViewController() -> TrainViewController
}

class TrainViewController: BaseViewController, TrainViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: TrainViewModel
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: TrainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TrainViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - TrainViewModelConsumer protocol
    func didFinishFetchingTrainMovements(on viewModel: TrainViewModel) {
        // TODO: reload data
    }
    
    func didFailFetchingTrainMovements(on viewModel: TrainViewModel, error: Error) {
        self.showAlert(for: error)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.viewModel.fetchTrainMovements()
    }
    
    // MARK: - Configuration
    private func configureUi() {
        self.title = "train \(self.viewModel.stationData().trainCode)".uppercased()
        self.configureNavigationBar()
    }
    
    // MARK: - Navigation
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.closeButtonTapped(_:)))
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
