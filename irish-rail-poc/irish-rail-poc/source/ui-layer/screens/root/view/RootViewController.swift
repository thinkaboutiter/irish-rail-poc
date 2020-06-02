//
//  RootViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

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
        self.poc_fetchStations()
    }
    
    private func configureUi() {
        self.titleLabel.text = "\(String(describing: RootViewController.self))"
    }
}

// MARK: - XML Parsing Poc
private extension RootViewController {
    
    enum Constants {
        enum APIEndpointUrlString {
            static let getAllStations: String = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        }
        static let timeoutInterval: TimeInterval = 30.0
    }
    
    func poc_fetchStations() {
        let session: URLSession = URLSession(configuration: .default)
        let urlString: String = Constants.APIEndpointUrlString.getAllStations
        guard let url: URL = URL(string: urlString) else {
            let message: String = "Unable to create valid \(String(describing: URL.self)) object from url_string=\(urlString)!"
            Logger.error.message(message)
            return
        }
        var request: URLRequest = URLRequest(url: url,
                                             cachePolicy: .reloadIgnoringCacheData,
                                             timeoutInterval: Constants.timeoutInterval)
        request.httpMethod = "GET"
        let task: URLSessionDataTask = session
            .dataTask(with: request)
            { (data: Data?, response: URLResponse?, error: Error?) in
                self.handle(data, response: response, error: error)
        }
        task.resume()
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
            Logger.error.message("\(error as NSError)")
        }
    }
}

import SWXMLHash

struct Station: XMLIndexerDeserializable {
    let desc: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
    
    static func deserialize(_ element: XMLIndexer) throws -> Station {
        return try Station(
            desc: element["StationDesc"].value(),
            alias: element["StationAlias"].value(),
            latitude: element["StationLatitude"].value(),
            longitude: element["StationLongitude"].value(),
            code: element["StationCode"].value(),
            id: element["StationId"].value())
    }
}
