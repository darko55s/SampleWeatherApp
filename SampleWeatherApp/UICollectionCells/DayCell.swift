//
//  DayCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import Kingfisher

class DayCell: UICollectionViewCell {
   
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var holderView: UIView!
    
    func setupCell(weather: WeatherDetailsViewModel) {
        lblCurrentTemp.text = "Current\n\(Int(weather.temp))˚"
        lblMaxTemp.text = "Max\n\(Int(weather.maxTemp))˚"
        lblMinTemp.text = "Min\n\(Int(weather.minTemp))˚"
        let imageUrl = ICON_BASE_URL +  weather.weatherStateAbbr + ".png"
        icon.kf.setImage(with: URL(string: imageUrl))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: weather.applicableDate) {
            dateFormatter.dateFormat = "EEEE"
            weekDay.text = dateFormatter.string(from: date)
        }
    }

}
