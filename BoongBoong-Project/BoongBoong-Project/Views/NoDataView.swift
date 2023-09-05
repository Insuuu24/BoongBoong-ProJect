//
//  NoDataView.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/05.
//

import UIKit
import Then
import SnapKit

class NoDataView: UIView {
    
    // MARK: - Properties
    
    var buttonAction: (() -> Void)?

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18)
    }

    private let subtitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var actionButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.circleRect()
        $0.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubviews(titleLabel,subtitleLabel, actionButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        actionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(40)
        }
    }
    
    func configure(title: String, subtitle: String, buttonTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc private func didTapActionButton() {
        buttonAction?()
    }

}
