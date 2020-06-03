//
//  ErrorCreator.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-03-Jun-Wed.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation

enum ErrorCreator {
    case generic
    case custom(domain: String, code: Int, localizedMessage: String)
        
    func error() -> NSError {
        switch self {
        case .generic:
            return self.error(domain: Constatns.domainName,
                              code: Constatns.genericCode,
                              message: Constatns.genericMessage)
            
        case .custom(let domain, let code, let message):
            return self.error(domain: domain,
                              code: code,
                              message: message)
        }
    }
    
    fileprivate func error(domain: String, code: Int, message: String) -> NSError {
        let error: NSError = NSError(
            domain: domain,
            code: code,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ])
        
        return error
    }
}

// MARK: - Constants
private extension ErrorCreator {
    
    enum Constatns {
        static let domainName: String = "Application.GenericError"
        static let genericCode: Int = 9999
        static let genericMessage: String = "I've got a bad feeling about this."
    }
}
