//
//  TrainMovement.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SWXMLHash

/** TrainMovement XML object
 <objTrainMovements>
     <TrainCode>E109 </TrainCode>
     <TrainDate>21 Dec 2011</TrainDate>
     <LocationCode>MHIDE</LocationCode>
     <LocationFullName>Malahide</LocationFullName>
     <LocationOrder>1</LocationOrder>
     <LocationType>O</LocationType>
     <TrainOrigin>Malahide</TrainOrigin>
     <TrainDestination>Greystones</TrainDestination>
     <ScheduledArrival>00:00:00</ScheduledArrival>
     <ScheduledDeparture>10:30:00</ScheduledDeparture>
     <ExpectedArrival>00:00:00</ExpectedArrival>
     <ExpectedDeparture>10:30:00</ExpectedDeparture>
     <Arrival>10:19:24</Arrival>
     <Departure>10:30:24</Departure>
     <AutoArrival>1</AutoArrival>
     <AutoDepart>1</AutoDepart>
     <StopType>-</StopType>
 </objTrainMovements>
 */

protocol TrainMovement {
    var trainCode: String { get }
    var trainDate: String { get }
    var locationCode: String { get }
    var locationFullName: String { get }
    var locationOrder: Int { get }
    var locationType: String { get }
    var trainOrigin: String { get }
    var trainDestination: String { get }
    var scheduledArrival: String { get }
    var scheduledDeparture: String { get }
    var expectedArrival: String { get }
    var expectedDeparture: String { get }
    
//    var arrival: String { get }
//    var departure: String { get }
//    var autoArrival: Int { get }
//    var autoDeparture: Int { get }
    
    var stopType: String { get }
}

enum TrainMovementParser {
    static func parse(_ xmlString: String) throws -> [TrainMovement] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let trainMovements: [TrainMovementImpl] = try xmlIndexer["ArrayOfObjTrainMovements"]["objTrainMovements"].value()
        return trainMovements
    }
}

struct TrainMovementImpl: XMLIndexerDeserializable, TrainMovement {
    
    let trainCode: String
    let trainDate: String
    let locationCode: String
    let locationFullName: String
    let locationOrder: Int
    let locationType: String
    let trainOrigin: String
    let trainDestination: String
    let scheduledArrival: String
    let scheduledDeparture: String
    let expectedArrival: String
    let expectedDeparture: String
    
    /* Response is sometimes broken on these ones */
//    let arrival: String
//    let departure: String
//    let autoArrival: Int
//    let autoDeparture: Int
    
    let stopType: String
    
    static func deserialize(_ element: XMLIndexer) throws -> TrainMovementImpl {
        return try TrainMovementImpl(
            trainCode: element["TrainCode"].value(),
            trainDate: element["TrainDate"].value(),
            locationCode: element["LocationCode"].value(),
            locationFullName: element["LocationFullName"].value(),
            locationOrder: element["LocationOrder"].value(),
            locationType: element["LocationType"].value(),
            trainOrigin: element["TrainOrigin"].value(),
            trainDestination: element["TrainDestination"].value(),
            scheduledArrival: element["ScheduledArrival"].value(),
            scheduledDeparture: element["ScheduledDeparture"].value(),
            expectedArrival: element["ExpectedArrival"].value(),
            expectedDeparture: element["ExpectedDeparture"].value(),
//            arrival: element["Arrival"].value(),
//            departure: element["Departure"].value(),
//            autoArrival: element["AutoArrival"].value(),
//            autoDeparture: element["AutoDepart"].value(),
            stopType: element["StopType"].value())
    }
}
