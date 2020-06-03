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
}
