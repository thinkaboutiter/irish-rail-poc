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
class BaseWebService<ApiResponseType>: WebService {
    
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
    
    final func instanceEndpoint() -> String {
        return self.endpoint
    }
    
    final func serviceEndpoint() -> String {
        let baseEndpoint: String = type(of: self).baseEndpoint()
        let instanceEndpoint: String = self.instanceEndpoint()
        let result: String = "\(baseEndpoint)\(instanceEndpoint)"
        return result
    }
    
    func httpVerb() -> HTTPMethod {
        return .get
    }
    
    func requestHeaders() -> Alamofire.HTTPHeaders? {
        return nil
    }
    
    func requestParameters() -> Parameters? {
        return nil
    }
    
    func requestParametersEncoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    // MARK: - Fetching
    func fetch(success: @escaping (_ resources: [ApiResponseType]) -> Void,
               failure: @escaping (_ error: Swift.Error) -> Void)
    {
        self.fetchXml(
            success: { (xmlString: String) in
                do {
                    let parsedResources: [ApiResponseType] = try self.parse(xmlString)
                    success(parsedResources)
                }
                catch {
                    failure(error)
                }
        },
            failure: { (error) in
                failure(error)
        })
    }
    
    private func fetchXml(success: @escaping (_ xmlString: String) -> Void,
                          failure: @escaping (_ error: Swift.Error) -> Void)
    {
        self.request?.cancel()
        self.request = AF
            .request(
                self.serviceEndpoint(),
                method: self.httpVerb(),
                parameters: self.requestParameters(),
                encoding: self.requestParametersEncoding(),
                headers: self.requestHeaders())
            .responseData(completionHandler: { (response: AFDataResponse<Data>) in
                Logger.network.message("request:").object(response.request)
                Logger.network.message("request.allHTTPHeaderFields:").object(response.request?.allHTTPHeaderFields)
                Logger.network.message("response:").object(response.response)
                do {
                    try self.validateResponse(response)
                    
                    guard let data: Data = response.data else {
                        let message: String = "Unable to obtain response object!"
                        let error: NSError = ErrorCreator
                            .custom(domain: WebServiceConstants.Error.domain,
                                    code: WebServiceConstants.Error.Code.unableToObtainResponseObject,
                                    localizedMessage: message)
                            .error()
                        failure(error)
                        return
                    }
                    guard let xmlString: String = String(data: data, encoding: .utf8) else {
                        let message: String = "Unable to parse received data as \(String(describing: String.self)) object!"
                        Logger.error.message(message)
                        return
                    }
                    success(xmlString)
                }
                catch {
                    failure(error as NSError)
                }
            })
    }
    
    // MARK: - Parsing
    func parse(_ xmlString: String) throws -> [ApiResponseType] {
        assert(false, "subclass should override!")
        return []
    }
    
    // MARK: - Validation
    private func validateResponse(_ response: AFDataResponse<Data>) throws {
        // check error
        guard response.error == nil else {
            throw response.error! as NSError
        }
        
        // check response object
        guard let httpUrlResponse: HTTPURLResponse = response.response else {
            let message: String = "Invalid response object"
            let error: NSError = ErrorCreator
                .custom(domain: WebServiceConstants.Error.domain,
                        code: WebServiceConstants.Error.Code.invalidResponseObject,
                        localizedMessage: message)
                .error()
            throw error
        }
        
        // check status code
        guard 200...299 ~= httpUrlResponse.statusCode else {
            let message: String = "Invalid status code=\(httpUrlResponse.statusCode)"
            let error: NSError = ErrorCreator
                .custom(domain: WebServiceConstants.Error.domain,
                        code: WebServiceConstants.Error.Code.invalidStatusCode,
                        localizedMessage: message)
                .error()
            throw error
        }
    }
}
