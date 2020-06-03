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

class RootViewController: BaseViewController, RootViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: RootViewModel
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RootViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootViewModelConsumer protocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
    }
    
    private func configureUi() {
        self.titleLabel.text = "\(String(describing: RootViewController.self))"
    }
}

// MARK: - XML Utils
private extension RootViewController {
    
    func parseXmlString(_ xmlString: String) {
        do {
            let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
                options.shouldProcessLazily = true
            }.parse(xmlString)
            let stations: [Station] = try xmlIndexer["ArrayOfObjStation"]["objStation"].value().filter() { $0.latitude != 0.0 && $0.longitude != 0.0}
            Logger.debug.message().object(stations)
        }
        catch {
            Logger.error.message().object(error as NSError)
        }
    }
}
