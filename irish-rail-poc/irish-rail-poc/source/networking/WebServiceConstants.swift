//
//  WebServiceConstants.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

enum WebServiceConstants {
    
    static let domain: String = "api.irishrail.ie"
    static let realtimePath: String = "/realtime/realtime.asmx"
    
    enum HttpPrefix {
        static let plain: String = "http://"
    }
    
    enum Endpoint {
        static let getAllStations: String = "/getAllStationsXML"
        static let getStationDataByCode: String = "/getStationDataByCodeXML"
        static let getTrainMovements: String = "/getTrainMovementsXML"
    }
    
    enum RequestParameterKey {
        static let stationCode: String = "StationCode"
        static let trainId: String = "TrainId"
        static let trainDate: String = "TrainDate"
    }
    
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: WebServiceConstants.Error.self))"
        
        enum Code {
            static let invalidResponseObject: Int = 9000
            static let invalidStatusCode: Int = 9001
            static let unableToObtainResponseObject: Int = 9002
        }
    }
}
