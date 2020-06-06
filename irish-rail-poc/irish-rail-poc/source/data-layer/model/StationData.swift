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

struct StationData: Hashable {
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
    let scheduleArrival: String
    let scheduleDeparture: String
    let direction: String
    let trainType: String
    let locationType: String
}

enum StationDataParser {
    static func parse(_ xmlString: String) throws -> [StationData] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let stationData: [StationDataApiObject] = try xmlIndexer["ArrayOfObjStationData"]["objStationData"].value()
        let result: [StationData] = stationData.map() { StationData(serverTime: $0.serverTime,
                                                                    trainCode: $0.trainCode,
                                                                    stationFullName: $0.stationFullName,
                                                                    stationCode: $0.stationCode,
                                                                    queryTime: $0.queryTime,
                                                                    trainDate: $0.trainDate,
                                                                    origin: $0.origin,
                                                                    destination: $0.destination,
                                                                    originTime: $0.originTime,
                                                                    destinationTime: $0.destinationTime,
                                                                    status: $0.status,
                                                                    lastLocation: $0.lastLocation,
                                                                    dueIn: $0.dueIn,
                                                                    late: $0.late,
                                                                    expectedArrival: $0.expectedArrival,
                                                                    expectedDeparture: $0.expectedDeparture,
                                                                    scheduleArrival: $0.scheduleArrival,
                                                                    scheduleDeparture: $0.scheduleDeparture,
                                                                    direction: $0.direction,
                                                                    trainType: $0.trainType,
                                                                    locationType: $0.locationType) }
        return result
    }
}

private struct StationDataApiObject: XMLIndexerDeserializable {
    
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
    let scheduleArrival: String
    let scheduleDeparture: String
    let direction: String
    let trainType: String
    let locationType: String
    
    static func deserialize(_ element: XMLIndexer) throws -> StationDataApiObject {
        return try StationDataApiObject(
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
            scheduleArrival: element["Scharrival"].value(),
            scheduleDeparture: element["Schdepart"].value(),
            direction: element["Direction"].value(),
            trainType: element["Traintype"].value(),
            locationType: element["Locationtype"].value())
    }
}
