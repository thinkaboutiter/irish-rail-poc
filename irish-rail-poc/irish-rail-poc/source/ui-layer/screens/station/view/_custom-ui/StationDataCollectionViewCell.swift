//
//  StationDataCollectionViewCell.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class StationDataCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: StationDataCollectionViewCell.self)
    }
    @IBOutlet private weak var stationDataView: StationDataView!
    private(set) var stationData: StationData?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stationDataView.reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(with: 4)
    }
    
    // MARK: - Congigurations
    func configure(with stationData: StationData) {
        self.stationData = stationData
        let vm: StationDataViewModel = StationDataViewModelImpl(stationData: stationData)
        self.stationDataView.configure(with: vm)
    }
}
