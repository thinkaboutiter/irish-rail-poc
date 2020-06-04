//
//  GetStationDataByCodeWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import Alamofire

class GetStationDataByCodeWebService: BaseWebService<StationData> {
    
    // MARK: - Properties
    private let stationCode: String

    // MARK: - Initialization
    init(stationCode: String) {
        self.stationCode = stationCode
        super.init(endpoint: WebServiceConstants.Endpoint.getStationDataByCode)
    }
    
    // MARK: - WebService protocol
    override func requestParameters() -> Parameters? {
        return [WebServiceConstants.RequestParameterKey.stationCode: self.stationCode]
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [StationData] {
        return try StationDataParser.parse(xmlString)
    }
}
