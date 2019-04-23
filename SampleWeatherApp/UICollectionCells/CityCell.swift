//
//  CityCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

protocol CityCellDelegate: class {
    func didLongPress()
}

class CityCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    var longPressGesture: UILongPressGestureRecognizer?
    weak var delegate: CityCellDelegate?
    
    var city: CityViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(city: CityViewModel) {
        if longPressGesture == nil {
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLogPressCell))
        }
        addGestureRecognizer(longPressGesture!)
        self.city = city
        lblTitle.text = city.name
    }
    
    @objc func didLogPressCell() {
        delegate?.didLongPress()
    }

}
