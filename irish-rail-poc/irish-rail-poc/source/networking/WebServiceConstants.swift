//
//  WebServiceConstants.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
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
