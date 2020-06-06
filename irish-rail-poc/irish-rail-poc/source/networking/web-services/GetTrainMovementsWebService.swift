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

final class GetTrainMovementsWebService: BaseWebService<TrainMovement> {
    
    // MARK: - Properties
    private var trainId: String?
    private var trainDate: String?

    // MARK: - Initialization
    init() {
        super.init(endpoint: WebServiceConstants.Endpoint.getTrainMovements)
        Logger.success.message()
    }
    
    deinit {
        Logger.fatal.message()
    }
    
    // MARK: - WebService protocol
    override func requestParameters() -> Parameters? {
        guard let trainId: String = self.trainId else {
            let message: String = Error.Message.invalidTrainIdMessage
            Logger.error.message(message)
            return nil
        }
        guard let trainDate = self.trainDate else {
            let message: String = Error.Message.invalidTrainDateMessage
            Logger.error.message(message)
            return nil
        }
        return [
            WebServiceConstants.RequestParameterKey.trainId: trainId,
            WebServiceConstants.RequestParameterKey.trainDate: trainDate
        ]
    }
    
    // MARK: - Checks
    override func performPreFetchParametersCheck() throws {
        guard let _ = self.trainId else {
            let message: String = Error.Message.invalidTrainIdMessage
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainIdParameter,
                                                     localizedMessage: message).error()
            throw error
        }
        guard let _ = self.trainDate else {
            let message: String = Error.Message.invalidTrainDateMessage
            let error: NSError = ErrorCreator.custom(domain: Error.domain,
                                                     code: Error.Code.invalidTrainIdParameter,
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

