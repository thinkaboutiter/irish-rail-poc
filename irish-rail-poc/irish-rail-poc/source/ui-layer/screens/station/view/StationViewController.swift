//
//  StationViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-07-Jun-Sun.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol StationViewControllerFactory {
    func makeStationViewController() -> StationViewController
}

class StationViewController: BaseViewController, StationViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: StationViewModel
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: StationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: StationViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationViewModelConsumer protocol
    func didFinishFetchingStationData(on viewModel: StationViewModel) {
        // TODO: implement me
    }
    
    func didFailFetchingStationData(on viewModel: StationViewModel, error: Error) {
        // TODO: implement me
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.configureNavigationBar()
    }
    
    // MARK: - Test navigation
    @IBAction private func pushButton_touchUpInside(_ sender: UIButton) {
        let vc = self.testViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func presentButton_touchUpInside(_ sender: UIButton) {
        let vc = self.testViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    private func testViewController() -> UIViewController {
        let viewController: UIViewController = UIViewController()
        let view: UIView = UIView()
        view.backgroundColor = .green
        viewController.view = view
        return viewController
    }
    
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
