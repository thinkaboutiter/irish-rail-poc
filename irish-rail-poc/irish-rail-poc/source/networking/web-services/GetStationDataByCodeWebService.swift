//
//  GetStationDataByCodeWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class GetStationDataByCodeWebService: BaseWebService {
    
    // MARK: - Properties
    private let stationCode: String

    // MARK: - Initialization
    init(stationCode: String) {
        self.stationCode = stationCode
        super.init(endpoint: WebServiceConstants.Endpoint.getStationDataByCode)
    }
    
    override func requestParameters() -> Parameters? {
        return [WebServiceConstants.RequestParameterKey.stationCode: self.stationCode]
    }

    // MARK: - Fetching
    func getStationData(success: @escaping (_ allStationData: [StationData]) -> Void,
                        failure: @escaping (_ error: Swift.Error) -> Void)
    {
        super.fetch(
            success: { (xmlString) in
                do {
                    let stationData: [StationData] = try self.stationData(from: xmlString)
                    success(stationData)
                }
                catch {
                    failure(error)
                }
        },
            failure: { (error) in
                failure(error)
        })
    }
    
    // MARK: - Parsing
    private func stationData(from xmlString: String) throws -> [StationData] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stationData: [StationData] = try xmlIndexer["ArrayOfObjStationData"]["objStationData"].value()
        return stationData
    }
}
