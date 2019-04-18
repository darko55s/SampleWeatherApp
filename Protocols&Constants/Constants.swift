//
//  Constants.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/18/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badData
}

typealias NetworkCompletion = (_ id: String?,_ error: Error?) -> ()
typealias IDCompletion = (String?) -> Void
typealias ModelCompletion = (Model?) -> Void
typealias ModelsCompletion = ([Model]) -> Void
typealias JSONDictionary = [String: Any]

let API_BASE_URL = "https://www.metaweather.com/api/"
