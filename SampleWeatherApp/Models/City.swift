//
//  CityRealmObject.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import UIKit
import RealmSwift
import IGListKit

class CityViewModel: NSObject {
    var id = ""
    var name = ""
    var isExpanded = false
    var userPicked = false
    
    init(realmObject: CityRealmObject) {
        id = realmObject.id
        name = realmObject.name
        userPicked = realmObject.userPicked
    }
}

extension CityViewModel: Model {
    static func findAll(completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(allRealmObjects: .city) as? [CityRealmObject] else { completion([]); return }
            completion(found.map { CityViewModel(realmObject: $0) })
        }
    }
    
    static func findMultiple(filter: NSPredicate, completion: @escaping ModelsCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(multipleRealmObjects: .city, filter: filter) as? [CityRealmObject] else { completion([]); return }
            completion(found.map { CityViewModel(realmObject: $0) })
        }
    }
    
    static func findSingle(filter: NSPredicate, completion: @escaping ModelCompletion) {
        DispatchQueue.main.async {
            guard let found = RealmManager.sharedInstance.find(singleRealmObject: .city, filter: filter) as? CityRealmObject else { completion(nil); return }
            completion(CityViewModel(realmObject: found))
        }
    }
    
    static func saveJSONData(rawDataDict: JSONDictionary, completion: IDCompletion? = nil) {
        guard let id = rawDataDict["woeid"] as? Int, id != 0 else { completion?(nil); return }
        let stringId = "\(id)"
        var jsonDict: JSONDictionary = ["id":stringId]
        if let name = rawDataDict["title"] as? String { jsonDict["name"] = name }
        if let userPicked = rawDataDict["userPicked"] as? Bool { jsonDict["userPicked"] = userPicked }
        
        DispatchQueue.main.async {
            RealmManager.sharedInstance.save(singleRealmObject: .city, value: jsonDict)
            completion?(stringId)
        }
    }
    
    func saveViewModel(completion: IDCompletion?) {
        guard id != "Default" else { completion?(nil); return }
        
        let jsonDict: JSONDictionary = [
            "id": id,
            "name": name,
            "userPicked": userPicked
        ]
        
        DispatchQueue.main.async { [weak self] in
            RealmManager.sharedInstance.save(singleRealmObject: .city, value: jsonDict)
            completion?(self?.id)
        }
    }
}

extension CityViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let cityModel = object as? CityViewModel else { return false }
        return (id == cityModel.id && name == cityModel.name)
    }
}

@objcMembers class CityRealmObject: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var userPicked = false
    
    override static func primaryKey() -> String? { return "id" }
}

