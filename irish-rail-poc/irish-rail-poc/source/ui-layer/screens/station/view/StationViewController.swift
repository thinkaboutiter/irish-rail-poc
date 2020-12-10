//
//  StationViewController.swift
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
        result.searchBar.placeholder = NSLocalizedString("Search for a train", comment: "Search for a train")
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
        if self.viewModel.items().count == 0 {
            let text: String = NSLocalizedString("No station data available.", comment: "No station data available.")
            self.showNoContentView(with: text)
        }
        else {
            self.hideNoContentView()
        }
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
        /// need to setup `close_button` only for modal presentations
        if self.navigationController?.presentingViewController != nil
            || self.presentingViewController != nil
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "Close"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.closeButtonTapped(_:)))
        }
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchControllerDelegate protocol
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

// MARK: - UISearchResultsUpdating protocol
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
