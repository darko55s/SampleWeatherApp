//
//  ViewController.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/18/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CityViewModel.findAll { cities in
            if let cities = cities as? [CityViewModel] {
                for city in cities {
                    NetworkManager.sharedInstance.getWeatherDetailsFor(cityId: city.id, completion: { (id, error) in
                        if let _ = error {
                            print("Error")
                        } else if let id = id {
                            print("GOT ID:" + id)
                        }
                    })
                }
            }
        }
        // Do any additional setup after loading the view.
    }


}

