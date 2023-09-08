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
    var activeTextField: UITextField?
    var keyboardOffset: CGFloat = 0
    let userDefaults = UserDefaultsManager.shared

    
    private let changePasswordLabel = UILabel()
    private let changePasswordTextField = UITextField()
    private let passwordValidationText = UILabel()
    private let changeButton = UIButton(type: .system)

    
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
        
        let changePasswordLabelWidth = view.frame.width * 0.8
        changePasswordLabel.frame = CGRect(x: (view.frame.width - changePasswordLabelWidth) / 2, y: 0, width: changePasswordLabelWidth, height: 44)
        changePasswordLabel.font = UIFont.systemFont(ofSize: 20)
        changePasswordLabel.text = "비밀번호 변경"
        changePasswordLabel.textAlignment = .center
        view.addSubview(changePasswordLabel)
        changePasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = changePasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraint = changePasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        NSLayoutConstraint.activate([centerXConstraint, topConstraint])


        
        changePasswordTextField.frame = CGRect(x: 10, y: (changePasswordLabel.frame.maxY) + 5, width: (view.frame.width) - 20, height: 44)
        
        changePasswordTextField.placeholder = "Password"
        changePasswordTextField.textAlignment = .left
        changePasswordTextField.backgroundColor = UIColor.white
        changePasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        changePasswordTextField.layer.borderWidth = 1.0
        changePasswordTextField.layer.cornerRadius = 5.0
        changePasswordTextField.isSecureTextEntry = true

        changePasswordTextField.delegate = self
        view.addSubview(changePasswordTextField)
        changePasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraintTextField = changePasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let topConstraintTextField = changePasswordTextField.topAnchor.constraint(equalTo: changePasswordLabel.bottomAnchor, constant: 15)
        let widthConstraintTextField = changePasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20)
        let heightConstraintTextField = changePasswordTextField.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([centerXConstraintTextField, topConstraintTextField, heightConstraintTextField, widthConstraintTextField])

        
        passwordValidationText.frame = CGRect(x: 10, y: changePasswordTextField.frame.maxY + 5, width: view.frame.width, height: 30)
        passwordValidationText.textAlignment = .left
        passwordValidationText.text = ""
        view.addSubview(passwordValidationText)
        passwordValidationText.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintPasswordValidationText = passwordValidationText.topAnchor.constraint(equalTo: changePasswordTextField.bottomAnchor, constant: 5)
        let centerXConstraintPasswordValidationText = passwordValidationText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let widthConstraintPasswordValidationText = passwordValidationText.widthAnchor.constraint(equalTo: changePasswordTextField.widthAnchor)
        let heightConstraintPasswordValidationText = passwordValidationText.heightAnchor.constraint(equalToConstant: 30)
        NSLayoutConstraint.activate([topConstraintPasswordValidationText, centerXConstraintPasswordValidationText, widthConstraintPasswordValidationText, heightConstraintPasswordValidationText])

        
        
        
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 25, y: changePasswordTextField.frame.maxY + 40, width: 160, height: 44)
        cancelButton.setTitle("취소하기", for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
        cancelButton.setTitleColor(.white, for: .normal)
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintCancelButton = cancelButton.topAnchor.constraint(equalTo: passwordValidationText.bottomAnchor, constant: 10)
        let leadingConstraintCancelButton = cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        let widthConstraintCancelButton = cancelButton.widthAnchor.constraint(equalToConstant: 160)
        let heightConstraintCancelButton = cancelButton.heightAnchor.constraint(equalToConstant: 44)

        NSLayoutConstraint.activate([topConstraintCancelButton, leadingConstraintCancelButton, widthConstraintCancelButton, heightConstraintCancelButton])


        changeButton.frame = CGRect(x: 210, y: changePasswordTextField.frame.maxY + 40, width: 160, height: 44)
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.titleLabel?.textAlignment = .center
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        changeButton.layer.cornerRadius = 5.0
        changeButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.isEnabled = false
        view.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraintChangeButton = changeButton.widthAnchor.constraint(equalToConstant: 160)
        let heightConstraintChangeButton = changeButton.heightAnchor.constraint(equalToConstant: 44)
        let trailingConstraintChangeButton = changeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        let verticalSpacingConstraint = changeButton.topAnchor.constraint(equalTo: passwordValidationText.bottomAnchor, constant: 10)
        NSLayoutConstraint.activate([widthConstraintChangeButton, heightConstraintChangeButton, trailingConstraintChangeButton, verticalSpacingConstraint])
        
        
        
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
                if var users = UserDefaultsManager.shared.getUsers() {
                    // 비밀번호를 업데이트합니다.
                    user.password = newPassword
                    // 업데이트된 사용자 정보를 저장합니다.
                    UserDefaultsManager.shared.saveUser(user)

                    // 키보드를 내립니다.
                    view.endEditing(true)

                    // 비밀번호 변경 성공 메시지를 표시합니다.
                    showPasswordChangeSuccessMessage()

                    // 사용자 정보를 다시 저장합니다.
                    UserDefaultsManager.shared.saveUsers([user.email: user])

                    print("로그인된 사용자 아이디: \(user.email), 변경된 비밀번호: \(user.password)")

                    if let changeButtonHandler = changeButtonHandler {
                        changeButtonHandler()
                    }
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
    
    
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }

        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,15}"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPasswordValid = predicate.evaluate(with: password)

        if !isPasswordValid {
            passwordValidationText.text = "영어, 숫자, 특수문자를 포함하여 5자 ~ 15자 입력해주세요."
            passwordValidationText.font = UIFont.systemFont(ofSize: 13)
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
            changeButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        } else {
            passwordValidationText.isHidden = true // 유효성 검사가 통과하면 메시지를 숨깁니다.
            passwordValidationText.text = ""
            changeButton.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
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
    
