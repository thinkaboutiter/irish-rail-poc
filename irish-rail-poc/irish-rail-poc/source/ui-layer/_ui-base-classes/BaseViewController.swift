//
//  BaseViewController.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W23-02-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
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
