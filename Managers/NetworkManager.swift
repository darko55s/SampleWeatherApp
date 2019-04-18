//
//  NetworkManager.swift
//  SampleWeatherApp
//
//  Created by Darko Spasovski on 4/19/19.
//  Copyright © 2019 Darko Spasovski. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedInstance = NetworkManager()

    func getWeatherDetailsFor(cityId: String, completion: @escaping NetworkCompletion) {
        let stringUrl = API_BASE_URL + "location/" + cityId
        Alamofire.request(stringUrl).responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? JSONDictionary {
                    WeatherViewModel.saveJSONData(rawDataDict: json, completion: { id in
                        completion(id, nil)
                    })
                } else {
                    completion(nil,NetworkError.badData)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
