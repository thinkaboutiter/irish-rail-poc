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
    private var station: Station!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = UIColor.systemBackground
    }
    
    // MARK: - Configurations
    func configure(with station: Station, for indexPath: IndexPath) {
        self.station = station
        if indexPath.row % 2 == 0 {
            self.backgroundColor = UIColor(named: "app-cell-background")
        }
        self.stationNameLabel.text = station.desc.uppercased()
        self.stationCodeLabel.text = station.code.uppercased()
    }
    
    func resetUi() {
        let text: String = NSLocalizedString("N/A", comment: "N/A")
        self.stationNameLabel.text = text
        self.stationCodeLabel.text = text
    }
}
