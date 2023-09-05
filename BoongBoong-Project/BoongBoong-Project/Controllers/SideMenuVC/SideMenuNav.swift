//
//  SideMenuNav.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/05.
//

import UIKit
import SideMenu

class SideMenuNav: SideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.7
        self.statusBarEndAlpha = 0.0
        self.presentDuration = 0.5
        self.dismissDuration = 0.5
    }
}
