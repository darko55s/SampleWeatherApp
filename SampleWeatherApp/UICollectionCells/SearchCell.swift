//
//  SearchCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Enter city name"
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = contentView.bounds
    }
}
