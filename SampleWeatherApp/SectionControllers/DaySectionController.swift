//
//  DaySectionController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

protocol DaySectionDelegate: class {
    func didSelectDay(weather: WeatherDetailsViewModel?)
}

class DaySectionController: ListSectionController {
    
    private var weather: WeatherDetailsViewModel?
    weak var delegate: DaySectionDelegate?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "DayCell", bundle: nil, for: self, at: index) as? DayCell else {
            fatalError()
        }
        cell.setupCell(weather: weather!)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.weather = object as? WeatherDetailsViewModel
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelectDay(weather: weather)
    }
}
