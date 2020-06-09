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
    private let makeTrainViewControllerWith: ((_ stationData: StationData) -> TrainViewController)
    private lazy var searchController: UISearchController = {
        let result: UISearchController = UISearchController(searchResultsController: nil)
        result.searchResultsUpdater = self
        result.obscuresBackgroundDuringPresentation = false
        result.searchBar.placeholder = "Search for train"
        result.delegate = self
        return result
    }()
    @IBOutlet private weak var stationDataCollectionView: StationDataCollectionView! {
        didSet {
            let identifier: String = StationDataCollectionViewCell.identifier
            self.stationDataCollectionView.register(UINib(nibName: identifier, bundle: nil),
                                                    forCellWithReuseIdentifier: identifier)
            self.stationDataCollectionView.delegate = self
            self.stationDataCollectionView.dataSource = self
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
    
    init(viewModel: StationViewModel,
         makeTrainViewControllerWith: @escaping ((_ stationData: StationData) -> TrainViewController)) {
        self.viewModel = viewModel
        self.makeTrainViewControllerWith = makeTrainViewControllerWith
        super.init(nibName: String(describing: StationViewController.self), bundle: nil)
        self.viewModel.setViewModelConsumer(self)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - StationViewModelConsumer protocol
    func didFinishFetchingStationData(on viewModel: StationViewModel) {
        self.stationDataCollectionView.reloadData()
    }
    
    func didFailFetchingStationData(on viewModel: StationViewModel, error: Swift.Error) {
        self.showAlert(for: error)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.viewModel.fetchStationData()
    }
    
    // MARK: - Configuration
    private func configureUi() {
        self.title = self.viewModel.station().desc
        self.configureNavigationBar()
        self.configureSearchBar()
    }
    
    private func configureSearchBar() {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureNavigationBar() {
        if self.navigationController?.presentingViewController != nil
            || self.presentingViewController != nil
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.closeButtonTapped(_:)))
        }
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchControllerDelegate
extension StationViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(true)
        self.stationDataCollectionView.reloadData()
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(false)
        self.stationDataCollectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension StationViewController: UISearchResultsUpdating {

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
        self.stationDataCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource protocol
extension StationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.items().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier: String = StationDataCollectionViewCell.identifier
        guard let validCell: StationDataCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? StationDataCollectionViewCell else {
            let message: String = "Unable to dequeue valid \(identifier)!"
            fatalError(message)
        }
        guard let stationData: StationData = self.viewModel.item(at: indexPath) else {
            let message: String = "Unable to find item for indexPath=\(indexPath)!"
            Logger.error.message(message)
            return validCell
        }
        validCell.configure(with: stationData)
        return validCell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension StationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let stationData: StationData = self.viewModel.item(at: indexPath) else {
            let message: String = "unable to obtain \(String(describing: StationData.self)) object for index_path=\(indexPath)"
            Logger.error.message(message)
            return
        }
        self.showTrainViewController(for: stationData)
    }
    
    private func showTrainViewController(for stationData: StationData) {
        let vc: TrainViewController = self.makeTrainViewControllerWith(stationData)
        if self.navigationController?.presentingViewController != nil
            || self.presentingViewController != nil
        {
            let nc: UINavigationController = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }
        else if let nc = self.navigationController {
            nc.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension StationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return self.itemSize(for: collectionView, at: indexPath)
    }
    
    private func itemSize(for collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        guard let provider: CollectionViewDimensionsProvider = collectionView as? CollectionViewDimensionsProvider else {
            let message: String = "Unable to obtain valid \(String(describing: CollectionViewDimensionsProvider.self)) object!"
            debugPrint("❌ \(#file) » \(#function) » \(#line)", message, separator: "\n")
            return CGSize.zero
        }
        let result: CGSize = self.itemSize(for: provider,
                                           totalWidth: collectionView.bounds.width)
        return result
    }
    
    private func itemSize(for provider: CollectionViewDimensionsProvider,
                          totalWidth: CGFloat) -> CGSize
    {
        let item_width: CGFloat = (
            totalWidth
                - provider.paddingLeft
                - provider.paddingRight
                - CGFloat(provider.itemsPerRow - 1) * provider.minimumInteritemSpacing
            ) / CGFloat(provider.itemsPerRow)
        
        let item_height: CGFloat = item_width / provider.itemWidthToHeightRatio
        return CGSize(width: item_width, height: item_height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        guard let valid_dimensionsProvider: CollectionViewDimensionsProvider = collectionView as? CollectionViewDimensionsProvider else {
            let message: String = "Unable to obtain valid \(String(describing: CollectionViewDimensionsProvider.self)) object!"
            debugPrint("❌ \(#file) » \(#function) » \(#line)", message, separator: "\n")
            return UIEdgeInsets.zero
        }
        return valid_dimensionsProvider.sectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        guard let valid_dimensionsProvider: CollectionViewDimensionsProvider = collectionView as? CollectionViewDimensionsProvider else {
            let message: String = "Unable to obtain valid \(String(describing: CollectionViewDimensionsProvider.self)) object!"
            debugPrint("❌ \(#file) » \(#function) » \(#line)", message, separator: "\n")
            return 0
        }
        return valid_dimensionsProvider.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        guard let valid_dimensionsProvider: CollectionViewDimensionsProvider = collectionView as? CollectionViewDimensionsProvider else {
            let message: String = "Unable to obtain valid \(String(describing: CollectionViewDimensionsProvider.self)) object!"
            debugPrint("❌ \(#file) » \(#function) » \(#line)", message, separator: "\n")
            return 0
        }
        return valid_dimensionsProvider.minimumLineSpacing
    }
}

// MARK: - Internal Errors
private extension StationViewController {
    
    enum Error {
        static let domainName: String = "\(AppConstants.projectName).\(String(describing: StationViewController.self)).\(String(describing: Error.self))"
        
        enum Code {
            static let invalidSearchText: Int = 9000
        }
    }
}
