//
//  InfoTableViewCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    var cellType: WeatherDetailsCellType = .humidity
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(weather: WeatherDetailsViewModel) {
        switch cellType {
        case .humidity:
            lblDescription.text = "Humidity"
            lblValue.text = "\(weather.humidity)"
            break
        case .preasure:
            lblDescription.text = "Pressure"
            lblValue.text = "\(weather.airPreasure)"
            break
        case .predictability:
            lblDescription.text = "Predictability"
            lblValue.text = "\(weather.predictability)%"
            break
        case .visibility:
            lblDescription.text = "Visibility"
            lblValue.text = "\(weather.visibility)%"
            break
        case .windDirection:
            lblDescription.text = "Wind Direction"
            lblValue.text = "\(weather.windDirectonCompass)"
            break
        case .windSpeed:
            //wind_speed
            let kmh = Int(weather.windSpeed * 1.60934)
            
            lblDescription.text = "Wind Speed"
            lblValue.text = "\(kmh) km/h"
            break
        default:
            lblDescription.text = ""
            lblValue.text = ""
            break
        }
    }
    
    
}
