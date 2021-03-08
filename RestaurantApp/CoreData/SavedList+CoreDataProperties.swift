//
//  SavedList+CoreDataProperties.swift
//  RestaurantApp
//
//  Created by Simon on 2019-05-11.
//  Copyright © 2019 Simon Poole. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedList> {
        return NSFetchRequest<SavedList>(entityName: "SavedList")
    }

    @NSManaged public var listName: String?
    @NSManaged public var detailModel: DetailsModel?
    @NSManaged public var viewModel: ViewModel?

}
