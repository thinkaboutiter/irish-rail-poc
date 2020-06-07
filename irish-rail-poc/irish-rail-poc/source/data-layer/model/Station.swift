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

struct Station: Hashable {
    let desc: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
}

enum StationParser {
    static func parse(_ xmlString: String) throws -> [Station] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stations: [StationApiObject] = try xmlIndexer["ArrayOfObjStation"]["objStation"].value().filter() { $0.latitude != 0.0 && $0.longitude != 0.0}
        let result: [Station] = stations.map() { Station(desc: $0.desc,
                                                         alias: $0.alias,
                                                         latitude: $0.latitude,
                                                         longitude: $0.longitude,
                                                         code: $0.code,
                                                         id: $0.id) }
        return result
    }
}

private struct StationApiObject: XMLIndexerDeserializable {
    let desc: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
    
    static func deserialize(_ element: XMLIndexer) throws -> StationApiObject {
        return try StationApiObject(
            desc: element["StationDesc"].value(),
            alias: element["StationAlias"].value(),
            latitude: element["StationLatitude"].value(),
            longitude: element["StationLongitude"].value(),
            code: element["StationCode"].value(),
            id: element["StationId"].value())
    }
}
