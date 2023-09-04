//
//  Extensions.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

// MARK: - View

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

extension UIImageView {
    
    var circleImage: Bool {
        set {
            if newValue {
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.layer.borderWidth = 0.5
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
                self.clipsToBounds = true
            } else {
                self.layer.cornerRadius = 0
                self.clipsToBounds = true
            }
        } get {
            return false
        }
    }
}

//extension MainViewController: DetailPageViewControllerDelegate {
//    func didUpdatePost(at index: Int, post: UserPost) {
//        posts[index] = post
//        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//    }
//}

extension UIButton {
    
    var circleImage: Bool {
        set {
            if newValue {
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.layer.borderWidth = 0.5
                self.layer.cornerRadius = 0.5 * self.bounds.size.width
                self.clipsToBounds = true
            } else {
                self.layer.cornerRadius = 0
                self.clipsToBounds = true
            }
        } get {
            return false
        }
    }
    
}

extension String {
    var isValidCredential: Bool {
            let regex = "^(?=.*[a-zA-Z])(?=.*\\d).{5,}$"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
        }
}

extension Int {
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        
        if self >= 1000 && self < 1000000 {
            formatter.positiveSuffix = "K"
            return formatter.string(from: NSNumber(value: Double(self) / 1000)) ?? "\(self)"
        } else if self >= 1000000 {
            formatter.positiveSuffix = "M"
            return formatter.string(from: NSNumber(value: Double(self) / 1000000)) ?? "\(self)"
        } else {
            return "\(self)"
        }
    }
}
