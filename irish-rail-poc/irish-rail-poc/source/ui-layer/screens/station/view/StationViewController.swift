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
//    @IBAction private func pushButton_touchUpInside(_ sender: UIButton) {
//        let vc = self.testViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction private func presentButton_touchUpInside(_ sender: UIButton) {
//        let vc = self.testViewController()
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    private func testViewController() -> UIViewController {
//        let viewController: UIViewController = UIViewController()
//        let view: UIView = UIView()
//        view.backgroundColor = .green
//        viewController.view = view
//        return viewController
//    }
    
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
