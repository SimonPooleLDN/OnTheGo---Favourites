//
//  RestaurantTableViewController.swift
//  RestaurantApp
//
//  Created by Simon on 8/7/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

class FavoriteListViewController: UITableViewController, ListActions, RestaurantCellSubclassDelegate {
    
    var savedList: [SavedList]!
    
    let locationService = LocationService()
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    
    var detailsModelProperty = [DetailsViewModel]()
    var viewModelsProperty = [RestaurantListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ListActions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModelsProperty.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCellNoSave
        
        let vm = viewModelsProperty[indexPath.row]
        cell.configure(with: vm, saveIndexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsFoodViewController else { return }
        detailsViewController.viewModel = detailsModelProperty[indexPath.row]
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        print("tap cell")
    }
    
    func saveButtonTapped(indexPath: IndexPath) {
        print("save tapped")
    }
}
