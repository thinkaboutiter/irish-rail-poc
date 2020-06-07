//
//  GetStationDataByCodeWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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
