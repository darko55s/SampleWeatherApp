//
//  AddNewCitySection.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import IGListKit

func addNewCitySectionController() -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? AddNewButtonCell else { return }
    }
    
    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 70)
    }
    
    return ListSingleSectionController(nibName: "AddNewButtonCell", bundle: nil, configureBlock: configureBlock, sizeBlock: sizeBlock)
}
