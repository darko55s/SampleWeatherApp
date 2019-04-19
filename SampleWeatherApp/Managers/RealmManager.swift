//
//  RealmManager.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/18/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmObjectType: String {
    case city
    case weather
    case weatherDetails
}

class RealmManager {
    // Constants and Variables
    private var realm: Realm!
    static let sharedInstance = RealmManager()
    
    init() {
        setupRealm()
    }
    
    internal func setupRealm() {
        var config = Realm.Configuration()
        
        var currentSchema = UInt64(UserDefaults.standard.integer(forKey: "RealmSchemaVersion"))
        config.schemaVersion = currentSchema
        

        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("RealmDB.realm")
        Realm.Configuration.defaultConfiguration = config
        
        do {
            realm = try Realm(configuration: config)
            print("Realm - Connected to RealmDB.realm")
            print("Realm - Full path: \(String(describing: config.fileURL))")
        } catch let error {
            if error.localizedDescription.contains("Migration is required due to the following errors") {
                currentSchema += 1
                config = Realm.Configuration(schemaVersion: currentSchema, migrationBlock: { (_, _) in })
                config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("RealmDB.realm")
                config.schemaVersion = currentSchema
                UserDefaults.standard.set(currentSchema, forKey: "RealmSchemaVersion")
                UserDefaults.standard.synchronize()
                setupRealm()
            } else if error.localizedDescription.contains("Provided schema version") {
                currentSchema += 1
                config.schemaVersion = currentSchema
                UserDefaults.standard.set(currentSchema, forKey: "RealmSchemaVersion")
                UserDefaults.standard.synchronize()
                setupRealm()
            } else {
                print("Realm - Could not access database \(config.fileURL!): \(error)")
            }
        }
    }
    
    func find(allRealmObjects type: RealmObjectType) -> [Object?] {
        guard realm != nil else { return [] }
        switch type {
        case .city: return realm.objects(CityRealmObject.self).map { $0 }
        case .weatherDetails: return realm.objects(WeatherDetailsRealmObject.self).map { $0 }
        case .weather: return realm.objects(WeatherRealmObject.self).map { $0 }
        }
    }
    
    func find(multipleRealmObjects type: RealmObjectType, filter: NSPredicate) -> [Object?] {
        guard realm != nil else { return [] }
        switch type {
        case .city: return realm.objects(CityRealmObject.self).filter(filter).map { $0 }
        case .weatherDetails: return realm.objects(WeatherDetailsRealmObject.self).filter(filter).map { $0 }
        case .weather: return realm.objects(WeatherRealmObject.self).filter(filter).map { $0 }
        }
    }
    
    func find(singleRealmObject type: RealmObjectType, filter: NSPredicate) -> Object? {
        let results = find(multipleRealmObjects: type, filter: filter)
        guard results.count == 1, let found = results.first else { return nil }
        return found
    }
    
    func save(singleRealmObject type: RealmObjectType, value: JSONDictionary) {
        guard realm != nil else { return }
        do {
            try realm.write {
                switch type {
                case .city:
                    realm.create(CityRealmObject.self, value: value, update: true)
                    print("Realm - City \(value["id"] ?? "") written!")
                case .weather:
                    realm.create(WeatherRealmObject.self, value: value, update: true)
                    print("Realm - Weather \(value["id"] ?? "") written!")
                case .weatherDetails:
                    realm.create(WeatherDetailsRealmObject.self, value: value, update: true)
                    print("Realm - WeatherDetails \(value["id"] ?? "") written!")
                }
            }
        } catch let error {
            // TODO: Handle error catching in a better way.
            print("Realm - Could not write to database: \(error)")
        }
    }
    
    func deleteAll() {
        guard realm != nil else { return }
        do {
            try realm.write {
                realm.deleteAll()
                print("Realm - All RealmObjects Deleted")
            }
        } catch let error {
            // TODO: Handle error catching in a better way.
            print("Realm - Could not delete all objects: \(error)")
        }
    }
    
    func delete(allRealmObjects type: RealmObjectType) {
        guard realm != nil else { return }
        do {
            try realm.write {
                switch type {
                case .city:
                    realm.delete(realm.objects(CityRealmObject.self))
                    print("Realm - All Citys deleted!")
                case .weather:
                    realm.delete(realm.objects(WeatherRealmObject.self))
                    print("Realm - All Weathers deleted!")
                case .weatherDetails:
                    realm.delete(realm.objects(WeatherDetailsRealmObject.self))
                    print("Realm - All WeatherDetails deleted!")
                }
            }
        } catch let error {
            // TODO: Handle error catching in a better way.
            print("Realm - Could not delete objects: \(error)")
        }
    }
    
    func delete(someRealmObjects type: RealmObjectType, filter: NSPredicate) {
        guard realm != nil else { return }
        do {
            try realm.write {
                let foundObjects = find(multipleRealmObjects: type, filter: filter)
                print("Realm - Deleting \(type.rawValue) RealmObjects that match filter: \(filter)")
                foundObjects.forEach {
                    if let object = $0 { realm.delete(object) }
                    print("Realm - Object deleted!")
                }
            }
        } catch let error {
            // TODO: Handle error catching in a better way.
            print("Realm - Could not delete objects: \(error)")
        }
    }
}
