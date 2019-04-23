//
//  CitySectionController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

protocol CitySectionDelegate: class {
    func didSelectCity(city: CityViewModel?)
    func didLongPressCity(city: CityViewModel?)
}

class CitySectionController: ListSectionController {
    
    private var city: CityViewModel?
    weak var delegate: CitySectionDelegate?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 70)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "CityCell", bundle: nil, for: self, at: index) as? CityCell else {
            fatalError()
        }
        cell.setupCell(city: city!)
        if let _ = viewController as? HomeViewController {
            cell.delegate = self
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.city = object as? CityViewModel
    }
    
    override func didSelectItem(at index: Int) {
        city!.isExpanded = !city!.isExpanded
        delegate?.didSelectCity(city: city)
    }
}

extension CitySectionController: CityCellDelegate {
    func didLongPress() {
        delegate?.didLongPressCity(city: self.city)
    }
}
