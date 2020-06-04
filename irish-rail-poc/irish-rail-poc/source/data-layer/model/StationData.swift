//
//  StationData.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

/** StationData XML object
<objStationData>
    <Servertime>2020-06-03T08:37:37.363</Servertime>
    <Traincode>E872 </Traincode>
    <Stationfullname>Malahide</Stationfullname>
    <Stationcode>MHIDE</Stationcode>
    <Querytime>08:37:37</Querytime>
    <Traindate>03 Jun 2020</Traindate>
    <Origin>Greystones</Origin>
    <Destination>Malahide</Destination>
    <Origintime>07:20</Origintime>
    <Destinationtime>08:37</Destinationtime>
    <Status>En Route</Status>
    <Lastlocation>Departed Portmarnock</Lastlocation>
    <Duein>3</Duein>
    <Late>3</Late>
    <Exparrival>08:40</Exparrival>
    <Expdepart>00:00</Expdepart>
    <Scharrival>08:37</Scharrival>
    <Schdepart>00:00</Schdepart>
    <Direction>Northbound</Direction>
    <Traintype>DART</Traintype>
    <Locationtype>D</Locationtype>
</objStationData>
*/

protocol StationData {
    var serverTime: String { get }
    var trainCode: String { get }
    var stationFullName: String { get }
    var stationCode: String { get }
    var queryTime: String { get }
    var trainDate: String { get }
    var origin: String { get }
    var destination: String { get }
    var originTime: String { get }
    var destinationTime: String { get }
    var status: String { get }
    var lastLocation: String { get }
    var dueIn: Int { get }
    var late: Int { get }
    var expectedArrival: String { get }
    var expectedDeparture: String { get }
    var sheduleArrival: String { get }
    var sheduleDeparture: String { get }
    var direction: String { get }
    var trainType: String { get }
    var locationType: String { get }
}

enum StationDataParser {
    static func parse(_ xmlString: String) throws -> [StationData] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stationData: [StationDataImpl] = try xmlIndexer["ArrayOfObjStationData"]["objStationData"].value()
        return stationData
    }
}

struct StationDataImpl: XMLIndexerDeserializable, StationData {
    
    let serverTime: String
    let trainCode: String
    let stationFullName: String
    let stationCode: String
    let queryTime: String
    let trainDate: String
    let origin: String
    let destination: String
    let originTime: String
    let destinationTime: String
    let status: String
    let lastLocation: String
    let dueIn: Int
    let late: Int
    let expectedArrival: String
    let expectedDeparture: String
    let sheduleArrival: String
    let sheduleDeparture: String
    let direction: String
    let trainType: String
    let locationType: String
    
    static func deserialize(_ element: XMLIndexer) throws -> StationDataImpl {
        return try StationDataImpl(
            serverTime: element["Servertime"].value(),
            trainCode: element["Traincode"].value(),
            stationFullName: element["Stationfullname"].value(),
            stationCode: element["Stationcode"].value(),
            queryTime: element["Querytime"].value(),
            trainDate: element["Traindate"].value(),
            origin: element["Origin"].value(),
            destination: element["Destination"].value(),
            originTime: element["Origintime"].value(),
            destinationTime: element["Destinationtime"].value(),
            status: element["Status"].value(),
            lastLocation: element["Lastlocation"].value(),
            dueIn: element["Duein"].value(),
            late: element["Late"].value(),
            expectedArrival: element["Exparrival"].value(),
            expectedDeparture: element["Expdepart"].value(),
            sheduleArrival: element["Scharrival"].value(),
            sheduleDeparture: element["Schdepart"].value(),
            direction: element["Direction"].value(),
            trainType: element["Traintype"].value(),
            locationType: element["Locationtype"].value())
    }
}
