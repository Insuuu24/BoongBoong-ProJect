//
//  ChangePasswordViewController.swift
//  BoongBoong-Project
//
//  Created by Lee on 2023/09/07.
//

import UIKit
import Then
import SnapKit

final class ChangePasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    var changeButtonHandler: (() -> Void)?
    var cancelButtonHandler: (() -> Void)?
    var activeTextField: UITextField?
    var keyboardOffset: CGFloat = 0
    
    private let changePasswordLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let changePasswordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.textAlignment = .left
        $0.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        $0.borderStyle = .none
        $0.layer.cornerRadius = 5.0
        $0.isSecureTextEntry = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let passwordValidationText = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var changeButton = UIButton(type: .system).then {
        $0.setTitle("변경하기", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 5.0
        $0.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    private lazy var cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소하기", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 5.0
        $0.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
        $0.setTitleColor(.white, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        changePasswordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubviews(changePasswordLabel, changePasswordTextField, passwordValidationText, cancelButton, changeButton)
        
        changePasswordLabel.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * 0.8)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        changePasswordTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
            $0.top.equalTo(changePasswordLabel.snp.bottom).offset(15)
        }
        
        passwordValidationText.snp.makeConstraints {
            $0.width.equalTo(changePasswordTextField)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(changePasswordTextField.snp.bottom).offset(5)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalTo(passwordValidationText.snp.bottom).offset(5)
        }
        
        changeButton.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalTo(passwordValidationText.snp.bottom).offset(5)
        }
    }
    
    private func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,15}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPasswordValid = predicate.evaluate(with: password)
        
        if !isPasswordValid {
            passwordValidationText.text = "영어, 숫자, 특수문자를 포함하여 5자 ~ 15자 입력해주세요."
            passwordValidationText.font = UIFont.systemFont(ofSize: 13)
            passwordValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            passwordValidationText.isHidden = false
            
            changePasswordTextField.layer.borderColor = UIColor(named: "red")?.cgColor
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordValidationText.center.x - 5, y: passwordValidationText.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: passwordValidationText.center.x + 5, y: passwordValidationText.center.y))
            passwordValidationText.layer.add(animation, forKey: "position")
            changeButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        } else {
            passwordValidationText.isHidden = true
            passwordValidationText.text = ""
            changeButton.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            changePasswordTextField.layer.borderColor = UIColor(named: "green")?.cgColor
        }
        return isPasswordValid
    }
    
    private func showPasswordChangeSuccessMessage() {
        let alertController = UIAlertController(title: "비밀번호 변경", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonTapped() {
        if let cancelButtonHandler = cancelButtonHandler {
            cancelButtonHandler()
        }
    }
    
    @objc func changeButtonTapped() {
        if let newPassword = changePasswordTextField.text, validatePassword(newPassword) {
            if var user = UserDefaultsManager.shared.getUser() {
                user.password = newPassword
                UserDefaultsManager.shared.saveUser(user)
                
                view.endEditing(true)
                
                showPasswordChangeSuccessMessage()
                
                if let changeButtonHandler = changeButtonHandler {
                    changeButtonHandler()
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            keyboardOffset = keyboardHeight
            self.view.frame.origin.y -= keyboardOffset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y += keyboardOffset
            keyboardOffset = 0
        }
    }
    
    @objc func handleTapOnView() {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == changePasswordTextField {
            // 현재 입력된 패스워드 텍스트
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            // 패스워드 유효성 검사
            let isPasswordValid = validatePassword(currentText)
            
            // 유효성에 따라 스타일 변경
            updatePasswordTextFieldStyle(isValid: isPasswordValid)
            
            changeButton.isEnabled = isPasswordValid
            changeButton.setNeedsLayout()
            return true
        }
        return true
    }
    
    private func updatePasswordTextFieldStyle(isValid: Bool) {
        if isValid {
            passwordValidationText.text = ""
        } else {
            passwordValidationText.text = "영문 대문자, 소문자, 숫자를 모두 포함하여 5자 ~ 15자 이상 작성하세요."
        }
    }
}
    
