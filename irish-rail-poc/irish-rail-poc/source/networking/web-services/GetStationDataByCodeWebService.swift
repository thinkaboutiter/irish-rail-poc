//
//  GetStationDataByCodeWebService.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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

/// Get Station Data by StationCode usage
///
///     http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=mhide
///
/// returns all trains due to serve the named station in the next 90 minutes
final class GetStationDataByCodeWebService: BaseWebService<StationData> {
    
    // MARK: - Properties

    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getStationDataByCode)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
        
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        guard let _ = self.requestParameters?[WebServiceConstants.RequestParameterKey.stationCode] else {
            let message: String = "Invalid station_code parameter!"
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidStationCodeParameter,
                                                     localizedMessage: message).error()
            throw error
        }
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [StationData] {
        return try StationDataParser.parse(xmlString)
    }
}

// MARK: - Errors
private extension GetStationDataByCodeWebService {
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: GetStationDataByCodeWebService.Error.self))"
        
        enum Code {
            static let invalidStationCodeParameter: Int = 9000
        }
    }
}
