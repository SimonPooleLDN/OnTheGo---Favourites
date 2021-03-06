//
//  NetworkService.swift
//  RestaurantApp
//
//  Created by Simon on 11/24/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import Foundation
import Moya


private let apiKey = "jQ6jvdEzkLX9yBC9_hiuOdLsDciCP3C-7Asraj0znFbUeoTLhh87B-f0YXyLqfEm6zlAmLRE8EHnKlz3mxsbwWwz7eU5_2QHN1owFApXxOMdqVUtiI6EZ3AbDxPDXHYx"

enum YelpService {
    enum BusinessesProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }

        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }

        var method: Moya.Method {
            return .get
        }

        var sampleData: Data {
            return Data()
        }

        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(
                    parameters: ["latitude": lat, "longitude": long, "limit": 10], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
            
        }

        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
