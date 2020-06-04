//
//  GetAllStationsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

class GetAllStationsWebService: BaseWebService<Station> {
    
    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getAllStations)
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [Station] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stations: [StationImpl] = try xmlIndexer["ArrayOfObjStation"]["objStation"].value().filter() { $0.latitude != 0.0 && $0.longitude != 0.0}
        return stations
    }
}
