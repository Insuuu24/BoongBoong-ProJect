//
//  SignInViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Then
import SnapKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    var changedPassword: String?
    let userDefaults = UserDefaultsManager.shared

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        let user = userDefaults.getUser()!
        print("저장된 유저 데이터: \(user.password)")
        let users = UserDefaultsManager.shared.getUsers()
        print("저장된 유저 데이터: \(user.password)")

    }
    
    private func RUD() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    // MARK: - Helpers
    
    private func configureUI() {
        passwordTextField.isSecureTextEntry = true
     
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))

        signInButton.isEnabled = false
        signInButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        
        userEmailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        signInButton.layer.cornerRadius = 5
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(named: "mainColor") ?? UIColor.systemBlue]))

        dontHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
        
    }
    
    private func resetInputFields() {
        userEmailTextField.text = ""
        passwordTextField.text = ""
        
        userEmailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        
        signInButton.isEnabled = false
        signInButton.backgroundColor = .lightGray
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let userEmail = userEmailTextField.text, !userEmail.isEmpty else {
               showErrorAlert(title: "로그인 실패", message: "이메일을 입력해주세요.")
               return
           }
           
           guard let userPassword = passwordTextField.text, !userPassword.isEmpty else {
               showErrorAlert(title: "로그인 실패", message: "비밀번호를 입력해주세요.")
               return
           }
        
        if let users = UserDefaultsManager.shared.getUsers(),
                  let loggedInUser = users.values.first(where: { $0.email == userEmail }) {
                   
                   if let newPassword = changedPassword {
                   }
                   
                   if loggedInUser.password == userPassword {
                       print("로그인 성공")
                       UserDefaultsManager.shared.saveUser(loggedInUser)
                       let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
                       if let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPage") as? MainPageViewController {
                           self.changeRootViewController(mainPageViewController)
                       }
                   } else {
                       showErrorAlert(title: "로그인 실패", message: "비밀번호가 일치하지 않습니다.")
                   }
               } else {
                   let users = UserDefaultsManager.shared.getUsers()
                   showErrorAlert(title: "로그인 실패", message: "등록된 사용자가 아닙니다.")
               }
    }
    
    private func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewControllerToPresent
            }, completion: nil)
        }
    }

    
    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        userEmailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = !(userEmailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        signInButton.isEnabled = isFormValid
        signInButton.backgroundColor = isFormValid ? UIColor(named: "mainColor") : UIColor(named: "subColor")
    }
}
    

// MARK: - UITextFieldDelegate

// TODO: username 입력완료 시 password로 위임하기
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
