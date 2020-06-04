//
//  GetAllStationsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

class GetAllStationsWebService: BaseWebService<Station> {
    
    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getAllStations)
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [Station] {
        return try StationParser.parse(xmlString)
    }
}
