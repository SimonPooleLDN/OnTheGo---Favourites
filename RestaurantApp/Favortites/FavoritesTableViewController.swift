//
//  FavoritesTableViewController.swift
//  RestaurantApp
//
//  Created by Simon on 2019-05-10.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit
import MapKit

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UITabBarControllerDelegate {

    @IBOutlet weak var favtableView: UITableView!
    
    var dataSource = [String]()
    var saveingNewRestaurant: Bool = false
    
    var viewModelsToSave: RestaurantListViewModel!
    var detailsModelToSave: DetailsViewModel!
    
    var savedList: [SavedList]!
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "favCell"
    
    @objc func addNewFav() {
        let addNewAlert = UIAlertController(title: "Alert", message: "Create new favorites list or add to a new one?.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            self.saveingNewRestaurant = false
        }
        
        let action2 = UIAlertAction(title: "New", style: .default) { (action:UIAlertAction) in
            let addExistingAlert = UIAlertController(title: "New Favorite List", message: "Type the name of the new list.", preferredStyle: .alert)
            addExistingAlert.addTextField { textField in
                textField.placeholder = "New List Name"
                textField.isSecureTextEntry = false
            }
            let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak addExistingAlert] _ in
                guard let _ = addExistingAlert, let textField = addExistingAlert?.textFields?.first else { return }
                print("Current password \(String(describing: textField.text))")
                self.dataSource.append(textField.text ?? "No Name List")
                self.dataSource = self.uniqueElementsFrom(array: self.dataSource)
                CoreDataFunctions.saveNewRestaurantList(listName: textField.text!, saveRestaurantViewModel: self.viewModelsToSave, saveDetailsModel: self.detailsModelToSave, completion: {
                    print("save Done")
                    CoreDataFunctions.loadRestaurantList(completion: { result in
                        result as [SavedList]
                        print("Load done.")
                        self.savedList = result
                        self.favtableView.reloadData()
                        self.saveingNewRestaurant = false
                    })
                })
            }
            addExistingAlert.addAction(confirmAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            addExistingAlert.addAction(cancelAction)
            self.present(addExistingAlert, animated: true, completion: nil)
        }
        
        let action3 = UIAlertAction(title: "Add To Existing", style: .default) { (action:UIAlertAction) in
            print("You've pressed the destructive");
        }
        
        addNewAlert.addAction(action1)
        addNewAlert.addAction(action2)
        addNewAlert.addAction(action3)
        self.present(addNewAlert, animated: true, completion: nil)
    }
    
    func confirmSaveToExisting(listTitle: String){
        let addNewAlert = UIAlertController(title: "Alert", message: "Added new restaurant to \(listTitle).", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("Added restaurant.");
        }

        addNewAlert.addAction(action)
        self.present(addNewAlert, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        favtableView.reloadData()
    }
    
    func reloadData(){
        CoreDataFunctions.loadRestaurantList(completion: { result in
            result as [SavedList]
            self.savedList = result
        })
        
        for list in savedList {
            dataSource.append(list.listName!)
        }
        dataSource = uniqueElementsFrom(array: dataSource)
    }
    
    @IBOutlet weak var AddNewFav: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self
        
        if saveingNewRestaurant == true {
            addNewFav()
        }
        
        reloadData()
        
        // Register the table view cell class and its reuse id
        self.favtableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        favtableView.delegate = self
        favtableView.dataSource = self
        
//        var rightBarButtonItems = [UIBarButtonItem]()
//        let todayBtn = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(FavoritesTableViewController.addNewFav))
//        rightBarButtonItems.append(todayBtn)
//        self.navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        favtableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.favtableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        // set the text from the data model
        cell.textLabel?.text = self.dataSource[indexPath.row]
        

        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if saveingNewRestaurant == true {
            saveingNewRestaurant = false
            let currentCell = favtableView.cellForRow(at: indexPath)
            let saveListToExisting = currentCell?.textLabel?.text
            CoreDataFunctions.saveNewRestaurantList(listName: saveListToExisting!, saveRestaurantViewModel: self.viewModelsToSave, saveDetailsModel: detailsModelToSave, completion: {
                print("save Done")
                CoreDataFunctions.loadRestaurantList(completion: { result in
                    result as [SavedList]
                    print("Load done.")
                    self.savedList = result
                    self.favtableView.reloadData()
                    self.confirmSaveToExisting(listTitle: saveListToExisting!)
                })
            })
        } else {
            guard let savedListViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteListViewController") as? FavoriteListViewController else {
                fatalError("Could not intantiate viewcontroller")
            }
            
            var viewModelToPass = [RestaurantListViewModel]()
            var detailsModelToPass = [DetailsViewModel]()
            for list in savedList {
                if list.listName == self.dataSource[indexPath.row]{
                    let newViewModel = RestaurantListViewModel.init(name: list.viewModel!.name!,
                                                                    id: list.viewModel!.id!,
                                                                    imageURL: list.viewModel!.imageURL!,
                                                                    distance: list.viewModel!.distance)
                    viewModelToPass.append(newViewModel)
                    let newCoordinate = CLLocationCoordinate2D(latitude: list.detailModel!.latitude, longitude: list.detailModel!.longitude)
                    let newDetailsModel = DetailsViewModel(name: list.detailModel!.name!,
                                                           price: list.detailModel!.price!,
                                                           isOpen: list.detailModel!.isOpen!,
                                                           phoneNumber: list.detailModel!.phone!,
                                                           rating: list.detailModel!.rating!,
                                                           imageURLS: list.detailModel!.photos! as [URL],
                                                           coordinate: newCoordinate)
                    detailsModelToPass.append(newDetailsModel)
                }
            }
            savedListViewController.viewModelsProperty = viewModelToPass
            savedListViewController.detailsModelProperty = detailsModelToPass
            
            let currentCell = favtableView.cellForRow(at: indexPath)
            savedListViewController.title = currentCell?.textLabel?.text
            navigationController?.pushViewController(savedListViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dataSource.remove(at: indexPath.row)
            favtableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            favtableView.reloadData()
        }
    }
}
