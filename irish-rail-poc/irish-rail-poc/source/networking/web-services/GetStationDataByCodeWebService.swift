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

class GetStationDataByCodeWebService: BaseWebService<StationData> {
    
    // MARK: - Properties
    private var stationCode: String?

    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getStationDataByCode)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - WebService protocol
    override func requestParameters() -> Parameters? {
        guard let stationCode: String = self.stationCode else {
            let message: String = "Invlaid station_code parameter!"
            Logger.error.message(message)
            return nil
        }
        return [WebServiceConstants.RequestParameterKey.stationCode: stationCode]
    }
    
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        guard let _ = self.stationCode else {
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
