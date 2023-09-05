//
//  SideMenuCell.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/05.
//

import UIKit
import Then
import SnapKit

class SideMenuCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var iconImageView = UIImageView().then {
        $0.tintColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let stackView = UIStackView().then {
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 20
    }
    
    // MARK: - View Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .white
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(10)
            $0.bottom.equalTo(self.contentView).offset(-10)
            $0.leading.equalTo(self.contentView).offset(16)
            $0.trailing.equalTo(self.contentView).offset(-10)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
    }
}

