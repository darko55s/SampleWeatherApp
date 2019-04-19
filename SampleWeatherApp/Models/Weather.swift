//
//  Weather.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherViewModel: NSObject {
    var details = [WeatherDetailsViewModel]()
    var time = ""
    var sunRise = ""
    var sunSet = ""
    var title = ""
    var locationType = ""
    var id = ""
    var timeZone = ""
    var latLon = ""
    
    init(realmObject: WeatherRealmObject) {
        let detailsFilter = NSPredicate(format: "id IN %@", Object.convertToArray(from: realmObject.details))
        if let found = RealmManager.sharedInstance.find(multipleRealmObjects: .weatherDetails, filter: detailsFilter) as? [WeatherDetailsRealmObject] {
            details = found.map { WeatherDetailsViewModel(realmObject: $0) }
        }
        time = realmObject.time
        sunRise = realmObject.sunRise
        sunSet = realmObject.sunSet
        timeZone = realmObject.timeZone
        title = realmObject.title
        locationType = realmObject.locationType
        id = realmObject.id
        latLon = realmObject.latLon
    }
}

extension WeatherViewModel: Model {
    static func findAll(completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(allRealmObjects: .weather) as? [WeatherRealmObject] else { completion([]); return }
            completion(found.map { WeatherViewModel(realmObject: $0) })
        }
    }
    
    static func findMultiple(filter: NSPredicate, completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(multipleRealmObjects: .weather, filter: filter) as? [WeatherRealmObject] else { completion([]); return }
            completion(found.map { WeatherViewModel(realmObject: $0) })
        }
    }
    
    static func findSingle(filter: NSPredicate, completion: @escaping ModelCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(singleRealmObject: .weather, filter: filter) as? WeatherRealmObject else { completion(nil); return }
            completion(WeatherViewModel(realmObject: found))
        }
    }
    
    static func saveJSONData(rawDataDict: JSONDictionary, completion: IDCompletion?) {
        guard let id = rawDataDict["woeid"] as? Int64, id != 0 else { completion?(nil); return }
        let stringId = "\(id)"

        var jsonDict: JSONDictionary = ["id":stringId]
        
        var details = [String]()
        if let detailsJson = rawDataDict["consolidated_weather"] as? [JSONDictionary] {
            details = detailsJson.compactMap({ "\($0["id"] as! Int64)" })
            detailsJson.forEach({ WeatherDetailsViewModel.saveJSONData(rawDataDict: $0)})
        }
        
        jsonDict["details"] = Object.convertToString(from: details)
        if let time = rawDataDict["time"] as? String { jsonDict["time"] = time }
        if let sunRise = rawDataDict["sun_rise"] as? String { jsonDict["sunRise"] = sunRise }
        if let sun_set = rawDataDict["sun_set"] as? String { jsonDict["sunSet"] = sun_set }
        if let timezone_name = rawDataDict["timezone_name"] as? String { jsonDict["timeZone"] = timezone_name }
        if let title = rawDataDict["title"] as? String { jsonDict["title"] = title }
        if let location_type = rawDataDict["location_type"] as? String { jsonDict["locationType"] = location_type }
        if let latt_long = rawDataDict["latt_long"] as? String { jsonDict["latLon"] = latt_long }

        DispatchQueue.main.async {
            RealmManager.sharedInstance.save(singleRealmObject: .weather, value: jsonDict)
            completion?(stringId)
        }
    }
    
    func saveViewModel(completion: IDCompletion?) {
        guard id != "Default" else { completion?(nil); return }
        
        let jsonDict: JSONDictionary = [
            "id": id,
            "details": Object.convertToString(from: details.compactMap({ $0.id })),
            "time" : time,
            "sunRise":sunRise,
            "sunSet":sunSet,
            "title":title,
            "locationType":locationType,
            "timeZone":timeZone,
            "latLon":latLon
        ]
        
        DispatchQueue.main.async { [weak self] in
            RealmManager.sharedInstance.save(singleRealmObject: .weather, value: jsonDict)
            completion?(self?.id)
        }
    }
}

@objcMembers class WeatherRealmObject: Object {
    
    dynamic var details = ""
    dynamic var time = ""
    dynamic var sunRise = ""
    dynamic var sunSet = ""
    dynamic var title = ""
    dynamic var locationType = ""
    dynamic var id = ""
    dynamic var timeZone = ""
    dynamic var latLon = ""

    override static func primaryKey() -> String? { return "id" }
}
