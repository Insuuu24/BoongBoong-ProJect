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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
       

    }
    
    func RUD() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        passwordTextField.isSecureTextEntry = true
       
     
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))


            signInButton.isEnabled = false
            signInButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        
        userEmailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        
        signInButton.layer.cornerRadius = 5
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        dontHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
        
    }
//    func setupUI() {
//        userEmailTextField.autocorrectionType = .no
//        userEmailTextField.autocapitalizationType = .none
//        userEmailTextField.delegate = self
//        userEmailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.textContentType = .oneTimeCode
//        passwordTextField.delegate = self
//        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//
//        signInButton.layer.cornerRadius = 5
//        signInButton.isEnabled = false
//
//        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
//        dontHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
//    }
    
    private func resetInputFields() {
        userEmailTextField.text = ""
        passwordTextField.text = ""
        
        userEmailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        
        signInButton.isEnabled = false
        signInButton.backgroundColor = .lightGray
    }
    

    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        
        if let users = UserDefaultsManager.shared.getUsers(), let _ = users.values.first(where: { $0.email == userEmail && $0.password == userPassword }) {
            print("로그인 성공")
            let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
            if let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPage") as? MainPageViewController {
                self.changeRootViewController(mainPageViewController)
            }
        } else {
            showErrorAlert(title: "로그인 실패", message: "이메일 또는 비밀번호가 일치하지 않거나, 등록된 사용자 정보가 없습니다.")
        }
    }
    
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewControllerToPresent
            }, completion: nil)
        }
    }
    
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        userEmailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = userEmailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        if isFormValid {
            signInButton.isEnabled = true
            signInButton.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        }
    }
    
    // FIXME: 경고문 화면에 출력하기
//    @objc private func handleSignUp() {
//        guard let username = usernameTextField.text else { return }
//        guard let password = passwordTextField.text else { return }
//
//        usernameTextField.isUserInteractionEnabled = false
//        passwordTextField.isUserInteractionEnabled = false
//
//        signInButton.isEnabled = false
//        signInButton.backgroundColor = UIColor.lightGray
//
//        if let existingUser = getUserByUsername(username) {
//            if existingUser.password != password {
//                showErrorAlert(title: "로그인 실패", message: "비밀번호가 일치하지 않습니다.")
//                resetInputFields()
//            } else {
//                myInfo = existingUser.username
//                print("로그인 성공: \(myInfo!)")
//                if let mainTabBarController = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
//                    mainTabBarController.selectedIndex = 0
//                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                       let delegate = windowScene.delegate as? SceneDelegate,
//                       let window = delegate.window {
//                        window.rootViewController = mainTabBarController
//                        window.makeKeyAndVisible()
//                    }
//                }
//            }
//        } else {
//            showErrorAlert(title: "로그인 실패", message: "존재하지 않는 아이디입니다.")
//            resetInputFields()
//        }
//    }

    
    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
}
    

// MARK: - UITextFieldDelegate

// TODO: username 입력완료 시 password로 위임하기
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEmailText = userEmailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        signInButton.isEnabled = !userEmailText.isEmpty && !passwordText.isEmpty
        
        return true
    }

    
    
}
