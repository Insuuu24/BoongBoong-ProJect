//
//  SignInViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Then
import SnapKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        passwordTextField.isSecureTextEntry = true
     
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))

        signInButton.isEnabled = false
        
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
    
    private func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewControllerToPresent
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let userEmail = userEmailTextField.text else {
            showErrorAlert(title: "로그인 실패", message: "이메일을 입력해주세요.")
            return
        }
        
        guard let userPassword = passwordTextField.text else {
            showErrorAlert(title: "로그인 실패", message: "비밀번호를 입력해주세요.")
            return
        }
        
        if let users = UserDefaultsManager.shared.getUsers(), let user = users.values.first(where: { $0.email == userEmail && $0.password == userPassword }) {
            print("로그인 성공")
            UserDefaultsManager.shared.saveUser(user)
            let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
            UserDefaultsManager.shared.saveUser(user)
            UserDefaultsManager.shared.saveLoggedInState(true)
            if let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPage") as? MainPageViewController {
                self.changeRootViewController(mainPageViewController)
            }
        } else {
            showErrorAlert(title: "로그인 실패", message: "이메일 또는 비밀번호가 일치하지 않거나, 등록된 사용자 정보가 없습니다.")
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

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
