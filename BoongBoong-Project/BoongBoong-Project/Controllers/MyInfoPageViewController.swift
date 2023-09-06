//
//  MyInfoPageViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class MyInfoPageViewController: UIViewController {

    // MARK: - Properties
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
    }
    
    // MARK: - Helpers

    private func configureNav() {
        navigationItem.title = "마이페이지"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.titleTextAttributes = [.foregroundColor: UIColor.label]
            $0.shadowColor = .clear
        }
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }

}
