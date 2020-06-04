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

class GetTrainMovementsWebService: BaseWebService {
    
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
    
    override func requestParameters() -> Parameters? {
        return [
            WebServiceConstants.RequestParameterKey.trainId: self.trainId,
            WebServiceConstants.RequestParameterKey.trainDate: self.trainDate
        ]
    }

    // MARK: - Fetching
    func getTrainMovements(success: @escaping (_ trainMovements: [TrainMovement]) -> Void,
                           failure: @escaping (_ error: Swift.Error) -> Void)
    {
        super.fetch(
            success: { (xmlString) in
                do {
                    let trainMovements: [TrainMovement] = try self.trainMovements(from: xmlString)
                    success(trainMovements)
                }
                catch {
                    failure(error)
                }
        },
            failure: { (error) in
                failure(error)
        })
    }
    
    // MARK: - Parsing
    private func trainMovements(from xmlString: String) throws -> [TrainMovement] {
        let xmlIndexer: XMLIndexer = SWXMLHash.config { (options: SWXMLHashOptions) in
            options.shouldProcessLazily = true
        }.parse(xmlString)
        let trainMovements: [TrainMovementImpl] = try xmlIndexer["ArrayOfObjTrainMovements"]["objTrainMovements"].value()
        return trainMovements
    }
}
