//
//  BaseViewController.swift
//  irish-rail-poc
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov (thinkaboutiter@gmail.com)
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

import UIKit

/// Abstract.
/// Base class for all view controllers within the app.
class BaseViewController: UIViewController {
    
    // MARK: - No Content View
    private lazy var noContentView: NoContentView = {
        let minDimension: CGFloat = min(self.view.bounds.width, self.view.bounds.height)
        let width: CGFloat = minDimension * 0.5
        let heigh: CGFloat = width * 0.5
        let result: NoContentView = NoContentView(frame: CGRect(origin: .zero,
                                                                size: CGSize(width: width,
                                                                             height: heigh)))
        return result
    }()
    
    func showNoContentView(with text: String) {
        self.noContentView.setText(text)
        self.noContentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.noContentView)
        self.noContentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.noContentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.noContentView.setNeedsUpdateConstraints()
    }
    
    func hideNoContentView() {
        self.noContentView.removeFromSuperview()
    }
}
