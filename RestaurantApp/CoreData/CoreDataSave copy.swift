//
//  CoreDataSave.swift
//  Get Rec'd App Suite
//
//  Created by Simon on 2019-02-07.
//  Copyright © 2019 Simon Poole All rights reserved.
//

import UIKit
import CoreData

class CoreDataFunctions{
    
    private static func setContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    static func saveNewRestaurantList(listName: String, saveRestaurantViewModel: RestaurantListViewModel, saveDetailsModel: DetailsViewModel, completion: @escaping () -> Void) { //}, saveDetailsModel: DetailsViewModel){
        
        let context = setContext()
        
        let listEntity              = NSEntityDescription.entity(forEntityName: "SavedList", in: context)
        let newList                 = SavedList(entity: listEntity!, insertInto: context)
        newList.listName            = listName
        let viewModelEntity         = NSEntityDescription.entity(forEntityName: "ViewModel", in: context)
        let newviewModel            = ViewModel(entity: viewModelEntity!, insertInto: context)
        newList.viewModel           = newviewModel
        let test = saveRestaurantViewModel.distance
        newList.viewModel!.distance = saveRestaurantViewModel.distance
        newList.viewModel!.id       = saveRestaurantViewModel.id
        newList.viewModel!.imageURL = saveRestaurantViewModel.imageUrl
        newList.viewModel!.name     = saveRestaurantViewModel.name
        let detailsModelEntity      = NSEntityDescription.entity(forEntityName: "DetailsModel", in: context)
        let newDetailsModel         = DetailsModel(entity: detailsModelEntity!, insertInto: context)
        newList.detailModel         = newDetailsModel
        newList.detailModel!.latitude = saveDetailsModel.coordinate.latitude
        newList.detailModel!.longitude = saveDetailsModel.coordinate.longitude
        newList.detailModel!.isOpen = saveDetailsModel.isOpen
        newList.detailModel!.name   = saveDetailsModel.name
        newList.detailModel!.phone  = saveDetailsModel.phoneNumber
        newList.detailModel!.photos = saveDetailsModel.imageUrls
        newList.detailModel!.price  = saveDetailsModel.price
        newList.detailModel!.rating = saveDetailsModel.rating
        do
        {
            try context.save()
            print("Saved new restaurant.")
        }
        catch { fatalError("Unable to save data.") }
        
        completion()
    }
    
    static func delete(ids: [Int], idAttribute: String){
        let extractValues: [NSManagedObject]
        let context = setContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notifications")
        request.returnsObjectsAsFaults = false
        do
        {
            extractValues = try context.fetch(request) as! [NSManagedObject]
        }
        catch { fatalError("Could not load Data") }
        
        for object in extractValues {
            let ID = object.value(forKey: idAttribute) as! Int
            for id in ids{
                if ID == id{
                    context.delete(object)
                }
            }
        }
    }
    
    static func loadRestaurantList(completion: @escaping ([SavedList]) -> Void) {
        
        let extractValues: [SavedList]
        let context = setContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedList")

        do
        {
            extractValues = try context.fetch(request) as! [SavedList]
        }
        catch { fatalError("Could not load Data") }
        completion(extractValues)
        }
}



