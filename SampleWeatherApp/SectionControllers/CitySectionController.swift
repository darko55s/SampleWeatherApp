//
//  CitySectionController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

class CitySectionController: ListSectionController {
    
    private var city: CityViewModel?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 70)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "CityCell", bundle: nil, for: self, at: index) as? CityCell else {
            fatalError()
        }
        cell.setupCell(city: city!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.city = object as? CityViewModel
    }

}
