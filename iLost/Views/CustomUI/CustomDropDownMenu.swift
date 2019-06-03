//
//  CustomDropDownMenu.swift
//  iLost
//
//  Created by Camilla Gretsch on 28.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class CustomDropDownMenu: BTNavigationDropdownMenu {

    static func setup(items: [String]) -> BTNavigationDropdownMenu {
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: items)
        menuView.navigationBarTitleFont = UIFont(name: "Verdana", size: 20)
        menuView.menuTitleColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        
        menuView.cellTextLabelFont = UIFont(name: "Verdana", size: 18)
        menuView.cellTextLabelColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        
        menuView.arrowTintColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        menuView.cellSelectionColor = UIColor(red: 39/255, green: 159/255, blue: 238/255, alpha: 0.5)
        menuView.shouldKeepSelectedCellColor = true
        
        return menuView
    }
}
