//
//  ChangePasswordViewController.swift
//  BoongBoong-Project
//
//  Created by Lee on 2023/09/07.
//

import UIKit


class ChangePasswordViewController: UIViewController {
   
    var changeButtonHandler: (() -> Void)?
     var cancelButtonHandler: (() -> Void)?
     private let scrollView = UIScrollView()
     var activeTextField: UITextField?
     
     private let changePasswordLabel = UILabel()
     private let changePasswordTextField = UITextField()
     private let passwordValidationText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        let changePasswordLabelWidth = view.frame.width * 0.8
        changePasswordLabel.frame = CGRect(x: (view.frame.width - changePasswordLabelWidth) / 2, y: 0, width: changePasswordLabelWidth, height: 44)
        changePasswordLabel.font = UIFont.systemFont(ofSize: 20)
        changePasswordLabel.text = "비밀번호 변경"
        changePasswordLabel.textAlignment = .center
        view.addSubview(changePasswordLabel)
        
        changePasswordTextField.frame = CGRect(x: 10, y: (changePasswordLabel.frame.maxY) + 5, width: (view.frame.width) - 20, height: 44)
        
        changePasswordTextField.placeholder = "Password"
        changePasswordTextField.textAlignment = .left
        changePasswordTextField.backgroundColor = UIColor.white
        changePasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        changePasswordTextField.layer.borderWidth = 1.0
        changePasswordTextField.layer.cornerRadius = 5.0
        changePasswordTextField.isSecureTextEntry = true


        changePasswordTextField.delegate = self
        let textFieldBottomY = changePasswordTextField.frame.maxY
        scrollView.contentSize = CGSize(width: view.frame.width, height: textFieldBottomY)
        view.addSubview(changePasswordTextField)
        
        passwordValidationText.frame = CGRect(x: 10, y: changePasswordTextField.frame.maxY + 5, width: view.frame.width, height: 30)
        passwordValidationText.textAlignment = .left
        passwordValidationText.text = ""
        view.addSubview(passwordValidationText)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 30, y: changePasswordTextField.frame.maxY + 40, width: 100, height: 44)
        cancelButton.setTitle("취소하기", for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)

        let changeButton = UIButton(type: .system)
        changeButton.frame = CGRect(x: view.frame.width - 130, y: changePasswordTextField.frame.maxY + 40, width: 100, height: 44)
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.titleLabel?.textAlignment = .center
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        view.addSubview(changeButton)
    }
    
    @objc func cancelButtonTapped() {
        if let cancelButtonHandler = cancelButtonHandler {
            cancelButtonHandler()
        }
    }

    @objc func changeButtonTapped() {
        // 텍스트 필드의 값을 가져옵니다.
        if let newPassword = changePasswordTextField.text, validatePassword(newPassword) {
            // 사용자 정보를 가져옵니다.
            if var user = UserDefaultsManager.shared.getUser() {
                // 비밀번호를 업데이트합니다.
                user.password = newPassword
                // 업데이트된 사용자 정보를 저장합니다.
                UserDefaultsManager.shared.saveUser(user)
                
                // 키보드를 내립니다.
                view.endEditing(true)
                
                // 비밀번호 변경 성공 메시지를 표시합니다.
                showPasswordChangeSuccessMessage()
                
                if let changeButtonHandler = changeButtonHandler {
                    changeButtonHandler()
                }
            }
        }
    }
    
    func showPasswordChangeSuccessMessage() {
        let alertController = UIAlertController(title: "비밀번호 변경", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.view.frame.origin.y += keyboardHeight
        }
    }
    
    @objc func handleTapOnView() {
        view.endEditing(true)
    }
    
    
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }

        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{5,}$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPasswordValid = predicate.evaluate(with: password)

        if !isPasswordValid {
            passwordValidationText.text = "영문 대문자, 소문자, 숫자를 모두 포함하여 5자 이상 작성하세요."
            passwordValidationText.font = UIFont.systemFont(ofSize: 12)
            passwordValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            passwordValidationText.isHidden = false // 메시지를 표시합니다.

            changePasswordTextField.layer.borderColor = UIColor(named: "red")?.cgColor

            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordValidationText.center.x - 5, y: passwordValidationText.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: passwordValidationText.center.x + 5, y: passwordValidationText.center.y))
            passwordValidationText.layer.add(animation, forKey: "position")
        } else {
            passwordValidationText.isHidden = true // 유효성 검사가 통과하면 메시지를 숨깁니다.
            passwordValidationText.text = ""
            changePasswordTextField.layer.borderColor = UIColor(named: "green")?.cgColor
        }
        return isPasswordValid
    }

}

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
             
             return true
         }
         return true
     }
     
     private func updatePasswordTextFieldStyle(isValid: Bool) {
         if isValid {
             changePasswordTextField.layer.borderColor = UIColor(named: "green")?.cgColor
             passwordValidationText.text = ""
         } else {
             changePasswordTextField.layer.borderColor = UIColor(named: "red")?.cgColor
             passwordValidationText.text = "영문 대문자, 소문자, 숫자를 모두 포함하여 5자 이상 작성하세요."
         }
     }
}

