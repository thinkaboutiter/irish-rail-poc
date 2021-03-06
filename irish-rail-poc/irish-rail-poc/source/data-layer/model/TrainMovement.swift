//
//  TrainMovement.swift
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

struct TrainMovement: Hashable {
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
}

enum TrainMovementParser {
    static func parse(_ xmlString: String) throws -> [TrainMovement] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let trainMovements: [TrainMovementApiObject] = try xmlIndexer["ArrayOfObjTrainMovements"]["objTrainMovements"].value()
        let result: [TrainMovement] = trainMovements.map() { TrainMovement(trainCode: $0.trainCode,
                                                                           trainDate: $0.trainDate,
                                                                           locationCode: $0.locationCode,
                                                                           locationFullName: $0.locationFullName,
                                                                           locationOrder: $0.locationOrder,
                                                                           locationType: $0.locationType,
                                                                           trainOrigin: $0.trainOrigin,
                                                                           trainDestination: $0.trainDestination,
                                                                           scheduledArrival: $0.scheduledArrival,
                                                                           scheduledDeparture: $0.scheduledDeparture,
                                                                           expectedArrival: $0.expectedArrival,
                                                                           expectedDeparture: $0.expectedDeparture,
                                                                           stopType: $0.stopType) }
        return result
    }
}

private struct TrainMovementApiObject: XMLIndexerDeserializable {
    
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
    
    static func deserialize(_ element: XMLIndexer) throws -> TrainMovementApiObject {
        return try TrainMovementApiObject(
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
