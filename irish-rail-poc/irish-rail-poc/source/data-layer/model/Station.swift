//
//  Station.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

/** Sample response of Station
 <objStation>
     <StationDesc>Belfast</StationDesc>
     <StationAlias />
     <StationLatitude>54.6123</StationLatitude>
     <StationLongitude>-5.91744</StationLongitude>
     <StationCode>BFSTC</StationCode>
     <StationId>228</StationId>
 </objStation>
 */

struct Station: XMLIndexerDeserializable {
    let desc: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
    
    static func deserialize(_ element: XMLIndexer) throws -> Station {
        return try Station(
            desc: element["StationDesc"].value(),
            alias: element["StationAlias"].value(),
            latitude: element["StationLatitude"].value(),
            longitude: element["StationLongitude"].value(),
            code: element["StationCode"].value(),
            id: element["StationId"].value())
    }
}
