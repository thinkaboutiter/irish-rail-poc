//
//  ErrorCreator.swift
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
        static let genericMessage: String = NSLocalizedString("I've got a bad feeling about this.", comment: "I've got a bad feeling about this.")
    }
}
