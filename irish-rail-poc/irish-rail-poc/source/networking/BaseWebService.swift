//
//  BaseWebService.swift
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
    
    deinit {
        self.request?.cancel()
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
    
    var httpVerb: HTTPMethod = .get
    var requestHeaders: Alamofire.HTTPHeaders?
    var requestParameters: Parameters?
    
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
    
    func performPreFetchParametersCheck() throws {
        fatalError("subclasses should override")
    }
    
    private func fetchXml(success: @escaping (_ xmlString: String) -> Void,
                          failure: @escaping (_ error: Swift.Error) -> Void)
    {
        self.request?.cancel()
        do {
            try self.performPreFetchParametersCheck()
            self.request = AF
            .request(
                self.serviceEndpoint(),
                method: self.httpVerb,
                parameters: self.requestParameters,
                encoding: self.requestParametersEncoding(),
                headers: self.requestHeaders)
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
        catch {
            failure(error)
        }
    }
    
    final func cancelRequest() {
        self.request?.cancel()
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
