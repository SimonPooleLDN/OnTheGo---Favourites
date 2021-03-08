//
//  FavoritesCell.swift
//  RestaurantApp
//
//  Created by Simon on 2019-05-10.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import Foundation
import UIKit

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var FavCellLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        
    }
}
