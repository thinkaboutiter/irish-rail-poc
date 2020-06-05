//
//  AppDelegate.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private lazy var rootViewControllerFactory: RootViewControllerFactory = {
        let stationRepository: StationRepository = StationRepositoryImpl()
        let stationDataRepository: StationDataRepository = StationDataRepositoryImpl()
        let trainMovementRepository: TrainMovementRepository = TrainMovementRepositoryImpl()
        let result: RootViewControllerFactory = RootDependencyContainerImpl(
            stationRepository: stationRepository,
            stationDataRepository: stationDataRepository,
            trainMovementRepository: trainMovementRepository)
        return result
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        self.configureSimpleLogger()
        let vc: RootViewController = self.rootViewControllerFactory.makeRootViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }
}

// MARK: - Configurations
private extension AppDelegate {
    
    func configureSimpleLogger() {
        #if DEBUG
        SimpleLogger.setVerbosityLevel(SimpleLogger.Verbosity.all.rawValue)
        #else
        SimpleLogger.setVerbosityLevel(SimpleLogger.Verbosity.none.rawValue)
        #endif
    }
}
