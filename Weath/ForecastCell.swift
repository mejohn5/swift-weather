//
//  CityCell.swift
//  Weath
//
//  Created by Marcus Johnson on 8/16/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

 
}
