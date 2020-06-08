//
//  StationsViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol StationsListViewControllerFactory {
    func makeStationsViewController() -> StationsViewController
}

class StationsViewController: BaseViewController, StationsViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: StationsViewModel
    @IBOutlet private weak var stationsTableView: StationsTableView! {
        didSet {
            let identifier: String = StationTableViewCell.identifier
            self.stationsTableView.register(UINib(nibName: identifier, bundle: nil),
                                            forCellReuseIdentifier: identifier)
            self.stationsTableView.delegate = self
            self.stationsTableView.dataSource = self
            self.stationsTableView.separatorStyle = .none
        }
    }
    
    // MARK: - Initialization
    @available(*, unavailable, message: "Creating this view controller with `init(coder:)` is unsupported in favor of initializer dependency injection.")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Creating this view controller with `init(coder:)` is unsupported in favor of dependency injection initializer.")
    }
    
    @available(*, unavailable, message: "Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of initializer dependency injection.")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Creating this view controller with `init(nibName:bundle:)` is unsupported in favor of dependency injection initializer.")
    }
    
    init(viewModel: StationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: StationsViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewModelConsumer protocol
    func didUpdateStations(on viewModel: StationsViewModel) {
        let _: [Station] = viewModel.items()
    }
    
    func didReceiveError(on viewModel: StationsViewModel, error: Error) {
        self.showAlert(for: error as NSError)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStations()
    }
    
    // MARK: - Fetching
    private func loadStations() {
        self.viewModel.fetchStations()
    }
}

// MARK: - UITableViewDataSource protocol
extension StationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = StationTableViewCell.identifier
        guard let cell: StationTableViewCell = tableView
            .dequeueReusableCell(withIdentifier: identifier,
                                 for: indexPath) as? StationTableViewCell
        else {
            let message: String = "Unable to dequeue valid \(identifier)!"
            fatalError(message)
        }
        guard let station: Station = self.viewModel.item(at: indexPath) else {
            let message: String = "Unable to obtain \(String(describing: Station.self)) object for index_path=\(indexPath)!"
            fatalError(message)
        }
        cell.configure(with: station)
        return cell
    }
}

// MARK: - UITableViewDelegate protocol
extension StationsViewController: UITableViewDelegate {
    
}
