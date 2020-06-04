//
//  GetTrainMovementsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import Alamofire

class GetTrainMovementsWebService: BaseWebService<TrainMovement> {
    
    // MARK: - Properties
    private let trainId: String
    private let trainDate: String

    // MARK: - Initialization
    init(trainId: String,
         trainDate: String)
    {
        self.trainId = trainId
        self.trainDate = trainDate
        super.init(endpoint: WebServiceConstants.Endpoint.getTrainMovements)
    }
    
    // MARK: - WebService protocol
    override func requestParameters() -> Parameters? {
        return [
            WebServiceConstants.RequestParameterKey.trainId: self.trainId,
            WebServiceConstants.RequestParameterKey.trainDate: self.trainDate
        ]
    }
    
    // MARK: - Parsing
    override func parse(_ xmlString: String) throws -> [TrainMovement] {
        return try TrainMovementParser.parse(xmlString)
    }
}
