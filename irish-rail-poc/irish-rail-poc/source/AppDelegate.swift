//
//  AppDelegate.swift
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?
    private lazy var rootViewControllerFactory: RootViewControllerFactory = {
        let stationsWs: GetAllStationsWebService = GetAllStationsWebService()
        let stationRepository: StationRepository = StationRepositoryImpl(webService: stationsWs)
        
        let stationDataWs: GetStationDataByCodeWebService = GetStationDataByCodeWebService()
        let stationDataRepository: StationDataRepository = StationDataRepositoryImpl(webService: stationDataWs)
        
        let trainMovementWs: GetTrainMovementsWebService = GetTrainMovementsWebService()
        let trainMovementRepository: TrainMovementRepository = TrainMovementRepositoryImpl(webService: trainMovementWs)
        
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
