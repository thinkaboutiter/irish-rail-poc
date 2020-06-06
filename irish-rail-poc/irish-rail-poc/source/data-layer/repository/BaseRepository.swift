//
//  BaseRepository.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-05-Jun-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

class BaseRepository<ApiResponseType> {
    
    // MARK: - Properties
    private var webService: BaseWebService<ApiResponseType>?
    func setWebService(_ newValue: BaseWebService<ApiResponseType>) {
        self.webService = newValue
    }
    private let concurrentCacheQueue = DispatchQueue(label: Constants.concurrentQueueLabel,
                                                     qos: .default,
                                                     attributes: .concurrent)
    private var cache: NSMutableOrderedSet = []
    private func clearCache() {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let valid_self = self else {
                return
            }
            valid_self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Initialization
    init() {
        Logger.success.message()
    }
    
    // MARK: - Fetching
    final func fetchResources(success: @escaping () -> Void,
                              failure: @escaping (_ error: Swift.Error) -> Void)
    {
        guard let validWebService: BaseWebService<ApiResponseType> = self.webService else {
            let message: String = "Invalid \(String(describing: BaseWebService<ApiResponseType>.self)) object!"
            let error: NSError = ErrorCreator
                .custom(domain: BaseRepository<ApiResponseType>.Error.domain,
                        code: BaseRepository<ApiResponseType>.Error.Code.invalidWebServiceObject,
                        localizedMessage: message)
                .error()
            failure(error)
            return
        }
        validWebService.fetch(
            success: { (objects: [ApiResponseType]) in
                self.consume(objects,
                             success: success,
                             failure: failure)
                
        },
            failure: failure)
    }
    
    private func consume(_ collection: [ApiResponseType],
                         success: @escaping () -> Void,
                         failure: @escaping (_ error: Swift.Error) -> Void)
    {
        self.concurrentCacheQueue.async(qos: .default,
                                        flags: .barrier)
        { [weak self] in
            guard let valid_self = self else {
                let message: String = "Unable to consume data!"
                let error: NSError = ErrorCreator
                    .custom(domain: BaseRepository<ApiResponseType>.Error.domain,
                            code: BaseRepository<ApiResponseType>.Error.Code.unableToConsumeData,
                            localizedMessage: message)
                    .error()
                failure(error)
                return
            }
            valid_self.cache.addObjects(from: collection)
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else {
                    let message: String = "Unable to notify for data consumption!"
                    let error: NSError = ErrorCreator
                        .custom(domain: BaseRepository<ApiResponseType>.Error.domain,
                                code: BaseRepository<ApiResponseType>.Error.Code.unableToNotifyForDataConsumption,
                                localizedMessage: message)
                        .error()
                    failure(error)
                    return
                }
                success()
            }
        }
    }
    
    /// Clears local cahce.
    /// Subclasses must call super.
    func refresh() {
        self.clearCache()
    }
    
    final func objects() -> [ApiResponseType] {
        var result: [ApiResponseType]!
        self.concurrentCacheQueue.sync { [weak self] in
            guard let valid_self = self else {
                return
            }
            result = valid_self.cache.compactMap { (element: Any) -> ApiResponseType? in
                guard let valid_entity: ApiResponseType = element as? ApiResponseType else {
                    return nil
                }
                return valid_entity
            }
        }
        return result ?? []
    }
    
    // MARK: - Constants
    private enum Constants {
        static var concurrentQueueLabel: String {
            return "\(AppConstants.projectName)-\(String(describing: BaseRepository<ApiResponseType>.self))-concurrent-queue"
        }
    }
    
    // MARK: - Errors
    private enum Error {
        static var domain: String {
            return "\(AppConstants.projectName).\(String(describing: BaseRepository<ApiResponseType>.Error.self))"
        }
        
        enum Code {
            static var unableToConsumeData: Int {
                return 9000
            }
            static var unableToNotifyForDataConsumption: Int {
                return 9001
            }
            static var invalidWebServiceObject: Int {
                return 9002
            }
        }
    }
}
