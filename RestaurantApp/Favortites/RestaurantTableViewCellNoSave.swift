//
//  RestaurantTableViewCell.swift
//  RestaurantApp
//
//  Created by Simon on 8/7/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantTableViewCellNoSave: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var makerImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var indexPath: IndexPath!
    var delegate: RestaurantCellSubclassDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with viewModel: RestaurantListViewModel, saveIndexPath: IndexPath) {
        restaurantImageView.af_setImage(withURL: viewModel.imageUrl)
        restaurantNameLabel.text = viewModel.name
        let test = viewModel.formattedDistance
        locationLabel.text = viewModel.formattedDistance
        indexPath = saveIndexPath
    }
    
    @IBAction func saveAction(_ sender: Any) {
        delegate.saveButtonTapped(indexPath: indexPath)
    }

}
