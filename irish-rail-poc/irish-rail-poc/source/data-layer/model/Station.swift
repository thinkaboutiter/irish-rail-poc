//
//  Station.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
