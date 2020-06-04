//
//  GetTrainMovementsWebService.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-04-Jun-Thu.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

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
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let trainMovements: [TrainMovementImpl] = try xmlIndexer["ArrayOfObjTrainMovements"]["objTrainMovements"].value()
        return trainMovements
    }
}
