//
//  Extensions.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func convertToArray(from string: String) -> [String] {
        return string.replacingOccurrences(of: "<", with: "").split(separator: ">").map { String($0) }
    }
    
    static func convertToString(from array: [String], sorted: Bool = true) -> String {
        guard array.count > 0 else { return "" }
        var mutableArray = array
        if sorted { mutableArray = array.sorted { $0 < $1 } }
        return mutableArray.count == 1 ? "<\(mutableArray[0])>" : mutableArray.reduce("") { $0 + "<\($1)>" }
    }
    
    static func convertToDataList(from dicts: [JSONDictionary]) -> List<Data> {
        let attributesData = List<Data>()
        for dict in dicts { attributesData.append(NSKeyedArchiver.archivedData(withRootObject: dict)) }
        return attributesData
    }
    
    static func convertToDictionaries(from dataList: List<Data>) -> [JSONDictionary] {
        var dictionaries = [JSONDictionary]()
        dataList.forEach { if let dict = NSKeyedUnarchiver.unarchiveObject(with: $0) as? JSONDictionary { dictionaries.append(dict) } }
        return dictionaries
    }
}
