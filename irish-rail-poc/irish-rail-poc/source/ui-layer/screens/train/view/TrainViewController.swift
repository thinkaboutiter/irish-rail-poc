//
//  TrainViewController.swift
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
protocol TrainViewControllerFactory {
    func makeTrainViewController() -> TrainViewController
}

class TrainViewController: BaseViewController, TrainViewModelConsumer {
    
    // MARK: - Properties
    private let viewModel: TrainViewModel
    private lazy var searchController: UISearchController = {
        let result: UISearchController = UISearchController(searchResultsController: nil)
        result.searchResultsUpdater = self
        result.obscuresBackgroundDuringPresentation = false
        result.searchBar.placeholder = NSLocalizedString("Search for a train stop", comment: "Search for a train stop")
        result.delegate = self
        return result
    }()
    @IBOutlet weak var trainMovementsCollectionView: TrainMovementsCollectionView! {
        didSet {
            let identifier: String = TrainMovementCollectionViewCell.identifier
            self.trainMovementsCollectionView.register(UINib(nibName: identifier, bundle: nil),
                                                       forCellWithReuseIdentifier: identifier)
            self.trainMovementsCollectionView.delegate = self
            self.trainMovementsCollectionView.dataSource = self
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
        self.trainMovementsCollectionView.reloadData()
    }
    
    func didFailFetchingTrainMovements(on viewModel: TrainViewModel, error: Swift.Error) {
        self.updateNoContentViewVisibility()
        self.showAlert(for: error)
    }
    
    private func updateNoContentViewVisibility() {
        if self.viewModel.items().count == 0 {
            let text: String = NSLocalizedString("No train data available.", comment: "No train data available.")
            self.showNoContentView(with: text)
        }
        else {
            self.hideNoContentView()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUi()
        self.viewModel.fetchTrainMovements()
    }
    
    // MARK: - Configuration
    private func configureUi() {
        self.title = "\(NSLocalizedString("train", comment: "train")) \(self.viewModel.stationData().trainCode)".uppercased()
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
extension TrainViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(true)
        self.trainMovementsCollectionView.reloadData()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.setDisplayingSearchResults(false)
        self.trainMovementsCollectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension TrainViewController: UISearchResultsUpdating {
    
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
        self.trainMovementsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource protocol
extension TrainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.items().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier: String = TrainMovementCollectionViewCell.identifier
        guard let validCell: TrainMovementCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TrainMovementCollectionViewCell else {
            let message: String = "Unable to dequeue valid \(identifier)!"
            fatalError(message)
        }
        guard let trainMovement: TrainMovement = self.viewModel.item(at: indexPath) else {
            let message: String = "Unable to find item for indexPath=\(indexPath)!"
            Logger.error.message(message)
            return validCell
        }
        validCell.configure(with: trainMovement)
        return validCell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension TrainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol
extension TrainViewController: UICollectionViewDelegateFlowLayout {
    
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
private extension TrainViewController {
    
    enum Error {
        static let domainName: String = "\(AppConstants.projectName).\(String(describing: TrainViewController.self)).\(String(describing: Error.self))"
        
        enum Code {
            static let invalidSearchText: Int = 9000
        }
    }
}

