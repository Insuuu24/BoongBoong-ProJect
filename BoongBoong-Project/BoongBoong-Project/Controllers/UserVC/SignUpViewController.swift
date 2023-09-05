//
//  SignUpViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var plusPhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var idValidationText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationText: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        
        //setupUI()
    }
    
    // MARK: - Helpers
    
    //    func setupUI() {
    //        // FIXME: 사진 버튼에 fill되게 수정하기
    //        plusPhotoButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
    //        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
    //        //plusPhotoButton.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
    //
    //        userNameTextField.autocorrectionType = .no
    //        userNameTextField.autocapitalizationType = .none
    //        userNameTextField.delegate = self
    //        userNameTextField.addTarget(self, action: #selector(handleTextInputChange(textField:)), for: .editingChanged)
    //
    //        passwordTextField.isSecureTextEntry = true
    //        passwordTextField.textContentType = .oneTimeCode
    //        passwordTextField.delegate = self
    //        passwordTextField.addTarget(self, action: #selector(handleTextInputChange(textField:)), for: .editingChanged)
    //
    //        signUpButton.layer.cornerRadius = 5
    //        //signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    //        signUpButton.isEnabled = false
    //        signUpButton.backgroundColor = .lightGray
    //
    //        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    //        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
    //        alreadyHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
    //        alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
    //    }
    //
    //    private func resetInputFields() {
    //        userNameTextField.text = ""
    //        passwordTextField.text = ""
    //
    //        userNameTextField.isUserInteractionEnabled = true
    //        passwordTextField.isUserInteractionEnabled = true
    //
    //        signUpButton.isEnabled = false
    //        signUpButton.backgroundColor = .lightGray
    //    }
    //
    ////    func isUsernameTaken(_ username: String) -> Bool {
    ////        return users.contains { user in
    ////            return user.username == username
    ////        }
    ////    }
    //
    //    func validateUsername(_ username: String?) -> Bool {
    //        guard let username = username else { return false }
    //        userNameTextField.layer.borderWidth = 2.0
    //        userNameTextField.layer.cornerRadius = 7.0
    //        if username.isValidCredential {
    //            idValidationText.text = ""
    //            userNameTextField.layer.borderColor = UIColor(named: "green")?.cgColor
    //            return true
    //        } else {
    //            idValidationText.text = "영문/숫자를 포함하여 5자 이상 작성하세요."
    //            userNameTextField.layer.borderColor = UIColor(named: "red")?.cgColor
    //            return false
    //        }
    //    }
    //
    //    func validatePassword(_ password: String?) -> Bool {
    //        guard let password = password else { return false }
    //        passwordTextField.layer.borderWidth = 2.0
    //        passwordTextField.layer.cornerRadius = 7.0
    //        if password.isValidCredential {
    //            passwordValidationText.text = ""
    //            passwordTextField.layer.borderColor = UIColor(named: "green")?.cgColor
    //            return true
    //        } else {
    //            passwordValidationText.text = "영문/숫자를 포함하여 5자 이상 작성하세요."
    //            passwordTextField.layer.borderColor = UIColor(named: "red")?.cgColor
    //            return false
    //        }
    //    }
    //
    //    func validateUsernameWithoutChangingUI(_ username: String?) -> Bool {
    //        guard let username = username else { return false }
    //        if username.isValidCredential {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    //
    //    func validatePasswordWithoutChangingUI(_ password: String?) -> Bool {
    //        guard let password = password else { return false }
    //        if password.isValidCredential {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    //
    //    // MARK: - Actions
    //
    //
    //    @IBAction func userNameEditingDidBegin(_ sender: UITextField) {
    //        _ = validateUsername(sender.text)
    //        handleTextInputChange(textField: sender)
    //    }
    //
    //
    //    @IBAction func passwordEditingDidBegin(_ sender: UITextField) {
    //        _ = validateUsername(userNameTextField.text)
    //        _ = validatePassword(sender.text)
    //        handleTextInputChange(textField: sender)
    //    }
    //
    //
    //    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
    //        if passwordTextField.isSecureTextEntry {
    //            passwordTextField.isSecureTextEntry = false
    //            sender.setImage(UIImage(systemName: "eye"), for: .normal)
    //        } else {
    //            passwordTextField.isSecureTextEntry = true
    //            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    //        }
    //    }
    //
    //
    //
    //
    //    @objc private func handleTapOnView(_ sender: UITextField) {
    //        userNameTextField.resignFirstResponder()
    //        passwordTextField.resignFirstResponder()
    //    }
    //
    ////    @objc private func handlePlusPhoto() {
    ////        let imagePickerController = UIImagePickerController()
    ////        imagePickerController.delegate = self
    ////        imagePickerController.allowsEditing = true
    ////        present(imagePickerController, animated: true, completion: nil)
    ////    }
    //
    //    @objc private func handleTextInputChange(textField: UITextField) {
    //        if textField == userNameTextField {
    //            _ = validateUsername(textField.text)
    //        } else if textField == passwordTextField {
    //            _ = validatePassword(textField.text)
    //        }
    //
    //        let isUsernameValid = validateUsernameWithoutChangingUI(userNameTextField.text)
    //        let isPasswordValid = validatePasswordWithoutChangingUI(passwordTextField.text)
    //
    //        let isFormValid = isUsernameValid && isPasswordValid
    //        signUpButton.isEnabled = isFormValid
    //        signUpButton.backgroundColor = isFormValid ? .systemBlue : .lightGray
    //    }
    //
    //    @objc private func handleAlreadyHaveAccount() {
    //        self.dismiss(animated: true)
    //    }
    //
    ////    @objc private func handleSignUp() {
    ////        guard let username = userNameTextField.text else { return }
    ////        guard let password = passwordTextField.text else { return }
    ////
    ////        userNameTextField.isUserInteractionEnabled = false
    ////        passwordTextField.isUserInteractionEnabled = false
    ////
    ////        signUpButton.isEnabled = false
    ////        signUpButton.backgroundColor = UIColor.lightGray
    ////
    ////        let newUser = User(username: username, profilePhoto: profileImage ?? UIImage(systemName: "person.circle.fill")!, password: password)
    ////        if isUsernameTaken(username) {
    ////            self.resetInputFields()
    ////        } else {
    ////            users.append(newUser)
    ////            myInfo = newUser.username
    ////            print(users)
    ////            if let mainTabBarController = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
    ////                mainTabBarController.selectedIndex = 0
    ////                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
    ////                   let delegate = windowScene.delegate as? SceneDelegate,
    ////                   let window = delegate.window {
    ////                    window.rootViewController = mainTabBarController
    ////                    window.makeKeyAndVisible()
    ////                }
    ////            }
    ////        }
    ////    }
    //
    //
    //
    //
    //}
    //
    //
    ////MARK: - UIImagePickerControllerDelegate
    //
    ////extension SignUpViewController: UIImagePickerControllerDelegate {
    ////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    ////        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    ////
    ////        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
    ////            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    ////            profileImage = editedImage
    ////            plusPhotoButton.circleImage = true
    ////        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
    ////            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    ////            profileImage = originalImage
    ////        }
    ////        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
    ////        dismiss(animated: true, completion: nil)
    ////    }
    ////}
    //
    //// MARK: - UITextFieldDelegate
    //
    //// TODO: username 입력완료 시 password로 위임하기
    //// TODO: usernameTextField, passwordTextField 실시간 유효성 검증 기능 추가 (아이디 중복 여부, 패스워드 유효성 여부)
    //extension SignUpViewController: UITextFieldDelegate {
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    //}
    //
    //
    //fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    //    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    //}
}
