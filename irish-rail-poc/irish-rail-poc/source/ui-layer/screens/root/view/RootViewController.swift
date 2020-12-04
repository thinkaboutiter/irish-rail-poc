//
//  RootViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger
import SWXMLHash

/// APIs for `DependecyContainer` to expose.
protocol RootViewControllerFactory {
    func makeRootViewController() -> RootViewController
}

class RootViewController: BaseViewController {
    
    // MARK: - Properties
    private let mapViewControllerFactory: MapViewControllerFactory
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(mapViewControllerFactory: MapViewControllerFactory) {
        self.mapViewControllerFactory = mapViewControllerFactory
        super.init(nibName: String(describing: RootViewController.self), bundle: nil)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedMapViewController()
    }
}

// MARK: - Embedding
private extension RootViewController {
    
    func embedMapViewController() {
        let vc: MapViewController = self.mapViewControllerFactory.makeMapViewController()
        let nc: UINavigationController = UINavigationController()
        nc.pushViewController(vc, animated: false)
        do {
            try self.embed(nc,
                           containerView: self.view,
                           positionChildViewIntoContainerView: nil)
        }
        catch {
            Logger.error.message().object(error as NSError)
        }
    }
}
