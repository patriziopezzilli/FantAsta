//
//  MyTabView.swift
//  FantAsta
//
//  Created by Patrizio Pezzilli on 04/08/17.
//  Copyright © 2017 Patrizio Pezzilli. All rights reserved.
//

import Foundation
import UIKit

class MyTabView : UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor.white
    }
}
