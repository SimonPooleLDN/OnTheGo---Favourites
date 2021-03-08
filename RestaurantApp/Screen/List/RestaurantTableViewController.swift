//
//  RestaurantTableViewController.swift
//  RestaurantApp
//
//  Created by Simoon on 8/7/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

protocol ListActions: class {
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel)
}

class RestaurantTableViewController: UITableViewController, ListActions, RestaurantCellSubclassDelegate {

    let locationService = LocationService()
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()

    var viewModelsProperty = [RestaurantListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ListActions?

    @IBAction func saveAction(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }

    }

    
    func saveButtonTapped(indexPath: IndexPath) {
        guard let favsViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteTableViewController") as? FavoritesTableViewController else { return }
        
        let vm = viewModelsProperty[indexPath.row]
        favsViewController.viewModelsToSave = vm
        favsViewController.saveingNewRestaurant = true
        service.request(.details(id: vm.id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    favsViewController.detailsModelToSave = detailsViewModel
                    self?.navigationController?.pushViewController(favsViewController, animated: true)
                }
            case .failure(let error):
                print("Failed to get details \(error)")
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModelsProperty.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell

        let vm = viewModelsProperty[indexPath.row]
        cell.configure(with: vm, saveIndexPath: indexPath)
        cell.delegate = self

        return cell
    }

    // MARK: - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else { return }
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = viewModelsProperty[indexPath.row]
        delegate?.didTapCell(detailsViewController, viewModel: vm)
    }
    
    private func loadDetails(for viewController: UIViewController, withId id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? DetailsFoodViewController)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Failed to get details \(error)")
            }
        }
    }
    
    private func loadDetailsForSaving(withId id: String, indexPath: IndexPath){
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else { return }
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = viewModelsProperty[indexPath.row]
        delegate?.didTapCell(detailsViewController, viewModel: vm)
    }
    
    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModelsLoad = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: { $0.distance < $1.distance })
                
                if let viewModelsLoaded = viewModelsLoad {
                    self!.viewModelsProperty = viewModelsLoaded
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        loadDetails(for: viewController, withId: viewModel.id)
    }
}
