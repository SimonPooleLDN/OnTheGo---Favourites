//
//  BaseView.swift
//  RestaurantApp
//
//  Created by Simon on 8/7/19.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit

@IBDesignable class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }

    func configure() {

    }
}
