//
//  GetTrainMovementsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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

