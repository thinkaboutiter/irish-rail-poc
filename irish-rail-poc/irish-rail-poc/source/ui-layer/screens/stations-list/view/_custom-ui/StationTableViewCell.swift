//
//  StationTableViewCell.swift
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
        self.resetUI()
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
    
    func resetUI() {
        let text: String = NSLocalizedString("N/A", comment: "N/A")
        self.stationNameLabel.text = text
        self.stationCodeLabel.text = text
    }
}
