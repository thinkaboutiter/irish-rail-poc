//
//  StaticTrainMovement.swift
//  irish-rail-poc-unit-tests
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
import SimpleLogger
@testable import irish_rail_poc

/// Use as namespace to hold all `StationData` static data APIs
enum StaticTrainMovement {
    
    static let singleValue: TrainMovement = {
        let data: TrainMovement = TrainMovement(trainCode: "E109",
                                                trainDate: "08 Jun 2020",
                                                locationCode: "SUTTN",
                                                locationFullName: "Sutton",
                                                locationOrder: 2,
                                                locationType: "S",
                                                trainOrigin: "Howth",
                                                trainDestination: "Greystones",
                                                scheduledArrival: "10:03:30",
                                                scheduledDeparture: "10:04:00",
                                                expectedArrival: "10:04:18",
                                                expectedDeparture: "10:03:24",
                                                stopType: "-")
        return data
    }()
        
    static let responseCollectionValue: [TrainMovement] = {
        var result = Array<TrainMovement>()
        let filename = TargetConstants.trainMovements_xml_filename
        let bundle = TargetConstants.bundle
        guard let path = bundle.path(forResource: filename, ofType: nil) else {
            Logger.error.message("Invalid path for filename=\(filename)")
            return result
        }
        do {
            let contents = try String(contentsOfFile: path)
            result = try TrainMovementParser.parse(contents)
        }
        catch {
            Logger.error.message("Error").object(error as NSError)
        }
        return result
    }()
}
