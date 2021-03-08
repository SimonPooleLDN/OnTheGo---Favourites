//
//  ViewModel+CoreDataProperties.swift
//  RestaurantApp
//
//  Created by Simon on 2019-05-11.
//  Copyright © 2019 Simon Poole. All rights reserved.
//
//

import Foundation
import CoreData


extension ViewModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ViewModel> {
        return NSFetchRequest<ViewModel>(entityName: "ViewModel")
    }

    @NSManaged public var distance: Double
    @NSManaged public var id: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var name: String?
    @NSManaged public var list: SavedList?

}
