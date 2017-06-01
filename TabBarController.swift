//
//  TabBarController.swift
//  FantAsta
//
//  Created by PatrizioPezzilli on 23/04/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false;
    }

}
