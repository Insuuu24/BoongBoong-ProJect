//
//  ViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import MapKit

class MainPageViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var homeMap: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var addKickboardButton: UIButton!
    @IBOutlet weak var returnKickboardButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Helpers
    
    
    
    
    
    // MARK: - Actions

    @IBAction func addKickboardButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func returnKickboardButtonTapped(_ sender: UIButton) {
    }
    
}

