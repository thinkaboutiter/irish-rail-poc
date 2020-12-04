//
//  GetTrainMovementsWebService.swift
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
import Alamofire
import SimpleLogger

/// Get Train Movements usage
/// 
///     http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=e109&TrainDate=21_dec_2011
///
/// returns all stop information for the given train as follows
///
///     TrainCode
///     TrainDate
///     LocationCode
///     LocationFullName
///     LocationOrder
///     LocationType O= Origin, S= Stop, T= TimingPoint (non stopping location) D = Destination
///     TrainOrigin
///     TrainDestination
///     ScheduledArrival
///     ScheduledDeparture
///     Arrival (actual)
///     Departure (actual)
///     AutoArrival (was information automatically generated)
///     AutoDepart
///     StopType C= Current N = Next
///     
/// Please note all these webservice names and parameters are case sensitive
final class GetTrainMovementsWebService: BaseWebService<TrainMovement> {

    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getTrainMovements)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - WebService protocol
    
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        guard let _ = self.requestParameters?[WebServiceConstants.RequestParameterKey.trainId] else {
            let message: String = Error.Message.invalidTrainIdMessage
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainIdParameter,
                                                     localizedMessage: message).error()
            throw error
        }
        guard let _ = self.requestParameters?[WebServiceConstants.RequestParameterKey.trainDate] else {
            let message: String = Error.Message.invalidTrainDateMessage
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainDateParameter,
                                                     localizedMessage: message).error()
            throw error
        }
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [TrainMovement] {
        return try TrainMovementParser.parse(xmlString)
    }
}

// MARK: - Errors
private extension GetTrainMovementsWebService {
    enum Error {
        static let domain: String = "\(AppConstants.projectName).\(String(describing: GetTrainMovementsWebService.Error.self))"
        
        enum Code {
            static let invalidTrainIdParameter: Int = 9000
            static let invalidTrainDateParameter: Int = 9001
        }
        
        enum Message {
            static let invalidTrainIdMessage: String = "Invalid train_id parameter!"
            static let invalidTrainDateMessage: String = "Invalid train_date parameter!"
        }
    }
}

