//
//  RootDependecyContainer.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

protocol RootDependencyContainer: AnyObject {}

class RootDependencyContainerImpl: RootDependencyContainer, RootViewControllerFactory {
    
    // MARK: - Properties
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - RootViewControllerFactory protocol
    func makeRootViewController() -> RootViewController {
        let vm: RootViewModel = self.makeRootViewModel()
        let vc: RootViewController = RootViewController(viewModel: vm)
        return vc
    }
    
    private func makeRootViewModel() -> RootViewModel {
        let model: RootModel = RootModelImpl()
        let result: RootViewModel = RootViewModelImpl(model: model)
        return result
    }
}
