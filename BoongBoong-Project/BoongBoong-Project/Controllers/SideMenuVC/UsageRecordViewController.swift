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
    
    //    private let emptyStateView = NoDataView()
    //
    //    private let usageRecordTableView = UITableView().then {
    //        $0.translatesAutoresizingMaskIntoConstraints = false
    //        $0.estimatedRowHeight = 150
    //        $0.rowHeight = UITableView.automaticDimension
    //        $0.separatorColor = .opaqueSeparator
    //    }
    //
    //    // MARK: - View Life Cycle
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        configureNav()
    //        configureUI()
    //    }
    //
    //    // MARK: - Helpers
    //
    //    private func configureNav() {
    //        navigationItem.title = "이용기록"
    //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    //        navigationItem.largeTitleDisplayMode = .always
    //
    //        let appearance = UINavigationBarAppearance().then {
    //            $0.configureWithOpaqueBackground()
    //            $0.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 28, weight: .semibold), .foregroundColor: UIColor.label]
    //            $0.titleTextAttributes = [.foregroundColor: UIColor.label]
    //            $0.shadowColor = .clear
    //        }
    //
    //        let scrollAppearance = UINavigationBarAppearance().then {
    //            $0.configureWithOpaqueBackground()
    //            $0.backgroundColor = .white
    //            $0.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    //            $0.titleTextAttributes = [.foregroundColor: UIColor.label]
    //        }
    //
    //        navigationController?.navigationBar.topItem?.title = ""
    //        navigationController?.navigationBar.tintColor = .black
    //        navigationController?.navigationBar.prefersLargeTitles = true
    //        navigationController?.navigationBar.standardAppearance = scrollAppearance
    //        navigationController?.navigationBar.compactAppearance = scrollAppearance
    //        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    //
    //    }
    //
    //    private func configureUI() {
    //        usageRecordTableView.delegate = self
    //        usageRecordTableView.dataSource = self
    //        usageRecordTableView.register(UsageRecordCell.self, forCellReuseIdentifier: "UsageRecordCell")
    //
    //        view.addSubview(usageRecordTableView)
    //        usageRecordTableView.snp.makeConstraints {
    //            $0.top.leading.trailing.bottom.equalToSuperview()
    //        }
    //    }
    //
    //    private func updateViewForDataCount(count: Int) {
    //        if count == 0 {
    //            view.addSubview(emptyStateView)
    //            emptyStateView.snp.makeConstraints {
    //                $0.edges.equalToSuperview()
    //            }
    //            emptyStateView.configure(title: "아직 이용기록이 없어요",
    //                                     subtitle: "지금 이용하기 버튼을 눌러서 이용해보세요!",
    //                                     buttonTitle: "지금 이용하기")
    //
    //            emptyStateView.buttonAction = {
    //                // 여기에 화면 전환 로직을 추가
    //            }
    //        } else {
    //            emptyStateView.removeFromSuperview()
    //        }
    //    }
    //}
    //
    //// MARK: - UITableViewDelegate, UITableViewDataSource
    //
    //extension UsageRecordViewController: UITableViewDelegate, UITableViewDataSource {
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // 임시로 0을 반환 -> 더미데이터 사용
    //        let count = 2
    //        updateViewForDataCount(count: count)
    //        return count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "UsageRecordCell", for: indexPath) as! UsageRecordCell
    //        cell.configure(with: UserDefaultsManager.shared.getUser()?.rideHistory[indexPath])!)
    //        return cell
    //    }
    //
    //}
    
}
