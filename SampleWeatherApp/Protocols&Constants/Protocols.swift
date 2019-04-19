//
//  Protocols.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/18/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import Foundation

protocol Model {
    static func findAll(completion: @escaping ModelsCompletion)
    static func findMultiple(filter: NSPredicate, completion: @escaping ModelsCompletion)
    static func findSingle(filter: NSPredicate, completion: @escaping ModelCompletion)
    static func saveJSONData(rawDataDict: JSONDictionary, completion: IDCompletion?)
    func saveViewModel(completion: IDCompletion?)
}
