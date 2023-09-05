//
//  UsageRecordViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Then
import SnapKit

class UsageRecordViewController: UIViewController {

    // MARK: - Properties
    
    private let usageRecordTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.estimatedRowHeight = 110
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorColor = .opaqueSeparator
        //$0.register(UsageRecordCell.self, forCellReuseIdentifier: "UsageRecordCell")
    }
    
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        configureUI()
    }
    

    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "이용기록"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    private func configureUI() {
        //usageRecordTableView.delegate = self
        //usageRecordTableView.dataSource = self

        view.addSubview(usageRecordTableView)
        usageRecordTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }
    
    
    
    
    // MARK: - Actions
    
    
    
    
    

}


// MARK: - UITableViewDelegate, UITableViewDataSource

//extension UsageRecordViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return noticeData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UsageRecordCell", for: indexPath) as! UsageRecordCell
//
//        let item = noticeData[indexPath.row]
//
//        cell.configure(title: item.title, date: item.date)
//
//        cell.selectionStyle = .none
//
//        return cell
//    }
//
//
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            // 셀의 separator 인셋을 지정하여 separator의 좌우 여백을 조절
//            if let cell = cell as? UsageRecordCell {
//                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//            }
//        }
//
//}
