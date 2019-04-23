//
//  TitleTableViewCell.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/23/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import Kingfisher

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeatherInfo: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(weather: WeatherDetailsViewModel) {
        lblWeatherInfo.text = weather.weatherStateName
        let imageUrl = ICON_BASE_URL +  weather.weatherStateAbbr + ".png"
        icon.kf.setImage(with: URL(string: imageUrl))
        currentTemp.text = "Current temp: \(Int(weather.minTemp))˚"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: weather.applicableDate) {
            if date.isYesterday {
                lblDate.text = "Yesterday"
            } else if date .isToday {
                lblDate.text = "Today"
            } else if date.isTomorrow {
                lblDate.text = "Tomorrow"
            } else {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                lblDate.text = dateFormatter.string(from: date)
            }
        }
    }
    
}
