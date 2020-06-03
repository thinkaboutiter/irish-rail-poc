//
//  BaseWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import Alamofire
import SimpleLogger


/// Abstract.
/// Base class for all web service objects
class BaseWebService<T>: WebService {
    
    // MARK: - Properties
    let endpoint: String
    private var request: Alamofire.Request?
    
    // MARK: - Initialization
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    // MARK: - WebService protocol
    static func baseEndpoint() -> String {
        let result: String = (
            WebServiceConstants.HttpPrefix.plain
                + WebServiceConstants.domain
                + WebServiceConstants.realtimePath
        )
        return result
    }
    
    func instanceEndpoint() -> String {
        return self.endpoint
    }
    
    func serviceEndpoint() -> String {
        let baseEndpoint: String = type(of: self).baseEndpoint()
        let instanceEndpoint: String = self.instanceEndpoint()
        let result: String = "\(baseEndpoint)\(instanceEndpoint)"
        return result
    }
    
    func httpVerb() -> HTTPMethod {
        return .get
    }
    
    func requestHeaders() -> [String : String]? {
        return nil
    }
    
    func requestParameters() -> Parameters? {
        return nil
    }
    
    func requestParametersEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
