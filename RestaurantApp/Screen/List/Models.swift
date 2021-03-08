//
//  Models.swift
//  RestaurantApp
//
//  Created by Simon on 11/27/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import Foundation
import CoreLocation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let name: String
    let imageUrl: URL
    let distance: Double
    let id: String

    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }

    var formattedDistance: String? {
        return RestaurantListViewModel.numberFormatter.string(from: distance as NSNumber)
    }
}

extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = business.distance / 1609.344
    }
}

extension RestaurantListViewModel {
    init(name: String, id: String, imageURL: URL, distance: Double) {
        self.name = name
        self.id = id
        self.imageUrl = imageURL
        self.distance = distance
    }
}

struct Details: Decodable {
    let price: String
    let phone: String
    let isClosed: Bool
    let rating: Double
    let name: String
    let photos: [URL]
    let coordinates: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}


struct DetailsViewModel {
    let name: String
    let price: String
    let isOpen: String
    let phoneNumber: String
    let rating: String
    let imageUrls: [URL]
    let coordinate: CLLocationCoordinate2D
}

extension DetailsViewModel {
    init(details: Details) {
        self.name = details.name
        self.price = details.price
        self.isOpen = details.isClosed ? "Closed" : "Open"
        self.phoneNumber = details.phone
        self.rating = "\(details.rating) / 5.0"
        self.imageUrls = details.photos
        self.coordinate = details.coordinates
    }
}

extension DetailsViewModel {
    init(name: String, price: String, isOpen: String, phoneNumber: String, rating: String, imageURLS: [URL], coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.price = price
        self.isOpen = isOpen
        self.phoneNumber = phoneNumber
        self.rating = "\(rating) / 5.0"
        self.imageUrls = imageURLS
        self.coordinate = coordinate
    }
}
