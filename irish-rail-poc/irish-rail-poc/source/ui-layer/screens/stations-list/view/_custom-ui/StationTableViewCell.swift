//
//  StationTableViewCell.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-09-Jun-Tue.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: StationTableViewCell.self)
    }
    @IBOutlet private weak var stationNameLabel: UILabel!
    @IBOutlet private weak var stationCodeLabel: UILabel!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
