//
//  ContainerViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class SideMenuViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var boongBoongLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var myPageButton: UIButton!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    
    private var menu: [SideMenuModel] = [
    SideMenuModel(icon: UIImage(systemName: "list.clipboard")!, title: "이용 기록"),
    SideMenuModel(icon: UIImage(systemName: "scooter")!, title: "내 붕붕이")
    ]
    
    var defaultHighlightedCell: Int = 0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        configureUI()
    }

    // MARK: - Helpers
    
    func setupTableView() {
        menuTableView.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")
        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.menuTableView.separatorStyle = .none
        self.menuTableView.rowHeight = 50
    }

    func configureUI() {
        userImageView.layer.cornerRadius = 30
        userImageView.clipsToBounds = true
        //userImageView.layer.borderColor = .lightGray
        userImageView.layer.borderWidth = 1
        self.userImageView.image = UIImage(named: "boongBoongLogo.png")
    }
    
    // MARK: - Actions
    
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        // 로그아웃 로직 구현
    }
    
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let usageRecordVC = UsageRecordViewController()
            self.navigationController?.pushViewController(usageRecordVC, animated: true)
        case 1:
            performSegue(withIdentifier: "myBoongBoongVC", sender: self)
            //            guard let myBoongBoongVC = storyboard?.instantiateViewController(withIdentifier: "MyBoongBoong") as? MyBoongBoongViewController else { return }
            //            self.present(myBoongBoongVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        cell.selectionStyle = .none
        return cell
    }
}
