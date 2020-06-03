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
        self.poc_getAllStations()
    }
    
    private func configureUi() {
        self.titleLabel.text = "\(String(describing: RootViewController.self))"
    }
}

// MARK: - get all stations
private extension RootViewController {
    
    func poc_getAllStations() {
        let urlString: String = Constants.ApiUrlString.getAllStations
        guard let url: URL = URL(string: urlString) else {
            let message: String = "Unable to create valid \(String(describing: URL.self)) object from url_string=\(urlString)!"
            Logger.error.message(message)
            return
        }
        var request: URLRequest = URLRequest(url: url,
                                             cachePolicy: .reloadIgnoringCacheData,
                                             timeoutInterval: Constants.requestTimeoutInterval)
        request.httpMethod = "GET"
        let task: URLSessionDataTask = Constants.session
            .dataTask(with: request)
            { (data: Data?, response: URLResponse?, error: Error?) in
                self.handle(data, response: response, error: error)
        }
        task.resume()
    }
}

// MARK: - XML Utils
private extension RootViewController {
    
    enum Constants {
        static let requestTimeoutInterval: TimeInterval = 30.0
        static var session: URLSession {
            return URLSession.shared
        }
        
        enum ApiUrlString {
            private static let base: String = "http://api.irishrail.ie/realtime/realtime.asmx"
            
            static var getAllStations: String {
                return ApiUrlString.base + Endpoint.getAllStations
            }
            static var getStationDataByCode: String {
                return ApiUrlString.base + Endpoint.getStationDataByCode
            }
            
            private enum Endpoint {
                static let getAllStations: String = "/getAllStationsXML"
                static let getStationDataByCode: String = "/getStationDataByCodeXML"
            }
        }
        
        enum RequestParameters {
            enum Key {
                static let stationCode: String = "StationCode"
            }
            enum Value {
                static let malahideCode: String = "mhide"
            }
        }        
    }
    
    func handle(_ data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            let message: String = "Error receiving response!"
            Logger.error.message(message).object(error! as NSError)
            return
        }
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
            let message: String = "Unable to obtain \(String(describing: HTTPURLResponse.self)) object!"
            Logger.error.message(message)
            return
        }
        let statusCode: Int = httpResponse.statusCode
        let successRange: Range<Int> = 200..<300
        guard successRange ~= statusCode else {
            let message: String = "Wrong status_code=\(statusCode)!"
            Logger.error.message(message)
            return
        }
        guard let data: Data = data else {
            let message: String = "Unable to obtain response \(String(describing: Data.self)) object!"
            Logger.error.message(message)
            return
        }
        guard let xmlString: String = String(data: data, encoding: .utf8) else {
            let message: String = "Unable to parse received data as \(String(describing: String.self)) object!"
            Logger.error.message(message)
            return
        }
        self.parseXmlString(xmlString)
    }
    
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
