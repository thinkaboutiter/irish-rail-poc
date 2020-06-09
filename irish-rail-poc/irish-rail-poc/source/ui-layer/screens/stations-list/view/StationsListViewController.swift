//
//  StationsListViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

/// APIs for `DependecyContainer` to expose.
protocol StationsListViewControllerFactory {
    func makeStationsListViewController() -> StationsListViewController
}

class StationsListViewController: BaseViewController, StationsListViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: StationsListViewModel
    private let makeStationViewControllerWith: ((_ station: Station) -> StationViewController)
    private lazy var searchController: UISearchController = {
        let result: UISearchController = UISearchController(searchResultsController: nil)
        result.searchResultsUpdater = self
        result.obscuresBackgroundDuringPresentation = false
        result.searchBar.placeholder = "Search for a station"
        result.delegate = self
        return result
    }()
    @IBOutlet private weak var stationsTableView: StationsTableView! {
        didSet {
            let identifier: String = StationTableViewCell.identifier
            self.stationsTableView.register(UINib(nibName: identifier, bundle: nil),
                                            forCellReuseIdentifier: identifier)
            self.stationsTableView.delegate = self
            self.stationsTableView.dataSource = self
            self.stationsTableView.separatorStyle = .singleLine
            self.stationsTableView.insetsContentViewsToSafeArea = false
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
    
    init(viewModel: StationsListViewModel,
         makeStationViewControllerWith: @escaping ((_ station: Station) -> StationViewController))
    {
        self.viewModel = viewModel
        self.makeStationViewControllerWith = makeStationViewControllerWith
        super.init(nibName: String(describing: StationsListViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - MapViewModelConsumer protocol
    func didUpdateStations(on viewModel: StationsListViewModel) {
        let _: [Station] = viewModel.items()
    }
    
    func didReceiveError(on viewModel: StationsListViewModel, error: Swift.Error) {
        self.showAlert(for: error as NSError)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.loadStations()
    }
    
    // MARK: - ConfigureUI
    private func configureUi() {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Fetching
    private func loadStations() {
        self.viewModel.fetchStations()
    }
}

// MARK: - UISearchControllerDelegate protocol
extension StationsListViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(true)
        self.stationsTableView.reloadData()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(false)
        self.stationsTableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating protocol
extension StationsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let validText: String = searchController.searchBar.text else {
            let message: String = "Invalid searchBar.text object!"
            let error: NSError = ErrorCreator
                .custom(domain: Error.domainName,
                        code: Error.Code.invalidSearchText,
                        localizedMessage: message)
                .error()
            Logger.error.message().object(error)
            return
        }
        self.viewModel.setSearchTerm(validText)
        self.stationsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource protocol
extension StationsListViewController: UITableViewDataSource {
    
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
extension StationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let station: Station = self.viewModel.item(at: indexPath) else {
            let message: String = "unable to obtain \(String(describing: Station.self)) object for index_path=\(indexPath)"
            Logger.error.message(message)
            return
        }
        let vc: StationViewController = self.makeStationViewControllerWith(station)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Constants
private extension StationsListViewController {
    
    enum Constants {
        static let cellHeight: CGFloat = 82.0
    }
}

// MARK: - Internal Errors
private extension StationsListViewController {
    
    enum Error {
        static let domainName: String = "\(AppConstants.projectName).\(String(describing: StationsListViewController.self)).\(String(describing: Error.self))"
        
        enum Code {
            static let invalidSearchText: Int = 9000
        }
    }
}
