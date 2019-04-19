//
//  AddNewButtonCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

protocol AddNewDelegate: class {
    func didSelectAddNew()
}

class AddNewButtonCell: UICollectionViewCell {

    @IBOutlet weak var btnAddnew: UIButton!
    
    weak var delegate: AddNewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onAddNew(_ sender: UIButton) {
        delegate?.didSelectAddNew()
    }
}
