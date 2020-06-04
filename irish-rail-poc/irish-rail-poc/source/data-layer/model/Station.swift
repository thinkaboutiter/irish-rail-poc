//
//  Station.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

/** Station XML object
 <objStation>
     <StationDesc>Belfast</StationDesc>
     <StationAlias />
     <StationLatitude>54.6123</StationLatitude>
     <StationLongitude>-5.91744</StationLongitude>
     <StationCode>BFSTC</StationCode>
     <StationId>228</StationId>
 </objStation>
 */

protocol Station {
    var desc: String { get }
    var alias: String? { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var code: String { get }
    var id: Int { get }
}

struct StationImpl: XMLIndexerDeserializable, Station {
    let desc: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
    
    static func deserialize(_ element: XMLIndexer) throws -> StationImpl {
        return try StationImpl(
            desc: element["StationDesc"].value(),
            alias: element["StationAlias"].value(),
            latitude: element["StationLatitude"].value(),
            longitude: element["StationLongitude"].value(),
            code: element["StationCode"].value(),
            id: element["StationId"].value())
    }
}
