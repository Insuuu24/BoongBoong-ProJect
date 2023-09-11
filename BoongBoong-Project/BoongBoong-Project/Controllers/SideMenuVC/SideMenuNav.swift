//
//  SideMenuNav.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/05.
//

import UIKit
import SideMenu

final class SideMenuNav: SideMenuNavigationController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.85
        self.statusBarEndAlpha = 0.0
        self.presentDuration = 0.5
        self.dismissDuration = 0.5
    }
}
