//
//  GetAllStationsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

class GetAllStationsWebService: BaseWebService {
    
    func getAllStations(success: @escaping (_ stations: [Station]) -> Void,
                        failure: @escaping (_ error: Swift.Error) -> Void)
    {
        super.fetch(success: { (xmlString: String) in
            do {
                let result: [Station] = try self.stations(from: xmlString)
                success(result)
            }
            catch {
                failure(error)
            }
        }) { (error: Error) in
            failure(error)
        }
    }
    
    private func stations(from xmlString: String) throws -> [Station] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stations: [Station] = try xmlIndexer["ArrayOfObjStation"]["objStation"].value().filter() { $0.latitude != 0.0 && $0.longitude != 0.0}
        return stations
    }
}
