//
//  WeatherDetails.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherDetailsViewModel: NSObject {
    
    var id = ""
    var weatherStateName = ""
    var weatherStateAbbr = ""
    var windDirectonCompass = ""
    var created = ""
    var applicableDate = ""
    var minTemp = 0.0
    var maxTemp = 0.0
    var temp = 0.0
    var windSpeed = 0.0
    var windDirection = 0.0
    var airPreasure = 0.0
    var humidity = 0.0
    var visibility = 0.0
    var predictability = 0
    
    init(realmObject: WeatherDetailsRealmObject) {
        id = realmObject.id
        weatherStateName = realmObject.weatherStateName
        weatherStateAbbr = realmObject.weatherStateAbbr
        windDirectonCompass = realmObject.windDirectonCompass
        created = realmObject.created
        applicableDate = realmObject.applicableDate
        minTemp = realmObject.minTemp
        maxTemp = realmObject.maxTemp
        temp = realmObject.temp
        windSpeed = realmObject.windSpeed
        windDirection = realmObject.windDirection
        airPreasure = realmObject.airPreasure
        humidity = realmObject.humidity
        visibility = realmObject.visibility
        predictability = realmObject.predictability
    }
}

extension WeatherDetailsViewModel: Model {
    static func findAll(completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(allRealmObjects: .weatherDetails) as? [WeatherDetailsRealmObject] else { completion([]); return }
            completion(found.map { WeatherDetailsViewModel(realmObject: $0) })
        }
    }
    
    static func findMultiple(filter: NSPredicate, completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(multipleRealmObjects: .weatherDetails, filter: filter) as? [WeatherDetailsRealmObject] else { completion([]); return }
            completion(found.map { WeatherDetailsViewModel(realmObject: $0) })
        }
    }
    
    static func findSingle(filter: NSPredicate, completion: @escaping ModelCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(singleRealmObject: .weatherDetails, filter: filter) as? WeatherDetailsRealmObject else { completion(nil); return }
            completion(WeatherDetailsViewModel(realmObject: found))
        }
    }
    
    static func saveJSONData(rawDataDict: JSONDictionary, completion: IDCompletion? = nil) {
        guard let id = rawDataDict["id"] as? Int64, id != 0 else { completion?(nil); return }
        let stringId = "\(id)"
        var jsonDict: JSONDictionary = ["id":"\(stringId)"]
        
        if let weather_state_name = rawDataDict["weather_state_name"] as? String { jsonDict["weatherStateName"] = weather_state_name }
        if let weather_state_abbr = rawDataDict["weather_state_abbr"] as? String { jsonDict["weatherStateAbbr"] = weather_state_abbr }
        if let wind_direction_compass = rawDataDict["wind_direction_compass"] as? String { jsonDict["windDirectonCompass"] = wind_direction_compass }
        if let created = rawDataDict["created"] as? String { jsonDict["created"] = created }
        if let applicable_date = rawDataDict["applicable_date"] as? String { jsonDict["applicableDate"] = applicable_date }
        if let minTemp = rawDataDict["min_temp"] as? Double { jsonDict["minTemp"] = minTemp }
        if let maxTemp = rawDataDict["max_temp"] as? Double { jsonDict["maxTemp"] = maxTemp }
        if let temp = rawDataDict["the_temp"] as? Double { jsonDict["temp"] = temp }
        if let wind_speed = rawDataDict["wind_speed"] as? Double { jsonDict["windSpeed"] = wind_speed }
        if let wind_direction = rawDataDict["wind_direction"] as? Double { jsonDict["windDirection"] = wind_direction }
        if let air_pressure = rawDataDict["air_pressure"] as? Double { jsonDict["airPreasure"] = air_pressure }
        if let humidity = rawDataDict["humidity"] as? Double { jsonDict["humidity"] = humidity }
        if let visibility = rawDataDict["visibility"] as? Double { jsonDict["visibility"] = visibility }
        if let predictability = rawDataDict["predictability"] as? Int { jsonDict["predictability"] = predictability }

        DispatchQueue.main.async {
            RealmManager.sharedInstance.save(singleRealmObject: .weatherDetails, value: jsonDict)
            completion?(stringId)
        }
    }
    
    func saveViewModel(completion: IDCompletion?) {
        guard id != "Default" else { completion?(nil); return }
        
        let jsonDict: JSONDictionary = [
            "id": id,
            "weatherStateName": weatherStateName,
            "weatherStateAbbr": weatherStateAbbr,
            "windDirectonCompass": windDirectonCompass,
            "created": created,
            "applicableDate": applicableDate,
            "minTemp": minTemp,
            "maxTemp": maxTemp,
            "temp": temp,
            "windSpeed": windSpeed,
            "windDirection": windDirection,
            "airPreasure": airPreasure,
            "humidity": humidity,
            "visibility": visibility,
            "predictability": predictability
        ]
        
        DispatchQueue.main.async { [weak self] in
            RealmManager.sharedInstance.save(singleRealmObject: .weatherDetails, value: jsonDict)
            completion?(self?.id)
        }
    }
}

@objcMembers class WeatherDetailsRealmObject: Object {
    
    dynamic var id = "No Id"
    dynamic var weatherStateName = ""
    dynamic var weatherStateAbbr = ""
    dynamic var windDirectonCompass = ""
    dynamic var created = ""
    dynamic var applicableDate = ""
    dynamic var minTemp = 0.0
    dynamic var maxTemp = 0.0
    dynamic var temp = 0.0
    dynamic var windSpeed = 0.0
    dynamic var windDirection = 0.0
    dynamic var airPreasure = 0.0
    dynamic var humidity = 0.0
    dynamic var visibility = 0.0
    dynamic var predictability = 0
    
    override static func primaryKey() -> String? { return "id" }
}
