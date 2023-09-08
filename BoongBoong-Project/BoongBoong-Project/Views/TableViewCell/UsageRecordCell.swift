//
//  UsageRecordCell.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Then
import SnapKit

class UsageRecordCell: UITableViewCell {

    // MARK: - Properties
    
    private let kickboardIDLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let durationLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .right
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func configureUI() {
        contentView.addSubviews(kickboardIDLabel, timeLabel, durationLabel)
        
        kickboardIDLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.left.equalTo(contentView).offset(16)
            $0.right.lessThanOrEqualTo(durationLabel.snp.left).offset(-16)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(kickboardIDLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentView).offset(16)
            $0.right.lessThanOrEqualTo(durationLabel.snp.left).offset(-16)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
        
        durationLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.right.equalTo(contentView).offset(-15)
            $0.width.lessThanOrEqualTo(contentView).multipliedBy(0.4)
        }
    }
    
    func configure(with history: RideHistory) {
        // 데이터 바인딩
        kickboardIDLabel.text = "Kickboard: \(history.boongboongName)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let dateLabelString = dateFormatter.string(from: history.startTime)
        
        dateFormatter.dateFormat = "HH:mm"
        let startTimeLabelString = dateFormatter.string(from: history.startTime)
        let endTimeLabelString = dateFormatter.string(from: history.endTime)
        
        timeLabel.text = "\(dateLabelString) (\(startTimeLabelString)~\(endTimeLabelString))"
        
        let duration = history.endTime.timeIntervalSince(history.startTime)
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        durationLabel.text = "\(hours)시간 \(minutes)분"
    }

}


