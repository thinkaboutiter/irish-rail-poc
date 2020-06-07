//
//  GetAllStationsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger


/// Get All Stations
///
///     http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML
///
/// returns a list of all stations with StationDesc, StaionCode, StationId, StationAlias, StationLatitude and StationLongitude ordered by Latitude, Longitude
final class GetAllStationsWebService: BaseWebService<Station> {
    
    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getAllStations)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        return
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [Station] {
        return try StationParser.parse(xmlString)
    }
}
