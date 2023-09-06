//
//  SignUpViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var plusPhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var idValidationText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidationText: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var userNameValidationText: UILabel!
    @IBOutlet weak var birthdateValidationText: UILabel!
    
    var selectedImageName: String?

    
    // MARK: - View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        createDatePicker()
        setupUI()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        passwordTextField.isSecureTextEntry = true
        
        signUpButton.layer.cornerRadius = 5
        
        handleTextInputChange()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
    
        userEmailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        birthdateTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)

        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        alreadyHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
    }
    
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
//            let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//            attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
//            alreadyHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
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
    //        func validateUsername(_ username: String?) -> Bool {
    //            guard let username = username else { return false }
    //            userNameTextField.layer.borderWidth = 2.0
    //            userNameTextField.layer.cornerRadius = 7.0
    //            if username.isValidCredential {
    //                idValidationText.text = ""
    //                userNameTextField.layer.borderColor = UIColor(named: "green")?.cgColor
    //                return true
    //            } else {
    //                idValidationText.text = "영문/숫자를 포함하여 5자 이상 작성하세요."
    //                userNameTextField.layer.borderColor = UIColor(named: "red")?.cgColor
    //                return false
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
    
    @IBAction func plusPhotoButtonTapped(_ sender: UIButton) {
        

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedURL = urls.first {
            let imagePath = selectedURL.path
            print("선택한 이미지 파일의 경로: \(imagePath)")
            
        }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let userEmail = userEmailTextField.text ?? ""
        let userPassword = passwordTextField.text ?? ""
        let userName = userNameTextField.text ?? ""
        let birthdateText = birthdateTextField.text ?? ""
        
        if !validateUserEmail(userEmail) { return }
        if !validatePassword(userPassword) { return }
        if !validateUserName(userName) { return }
        if !validateBirthdate(birthdateText) {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let imageName = selectedImageName,
            let birthdate = dateFormatter.date(from: birthdateText) {
            let newUser = User(email: userEmail, password: userPassword, name: userName, birthdate: birthdate, profileImage: imageName, isUsingKickboard: false, rideHistory: [], registeredKickboards: dummyKickboards[0])
            var users = UserDefaultsManager.shared.getUsers() ?? [:]
            let newUserID = UUID().uuidString
            users[newUserID] = newUser
            UserDefaultsManager.shared.saveUsers(users)
            UserDefaultsManager.shared.saveLoggedInState(true)
            print("\(newUser)")
            self.dismiss(animated: true, completion: nil)
        } else {
            let defaultImageName = "defaultProfileImage.jpg"
            let newUser = User(email: userEmail, password: userPassword, name: userName, birthdate: Date(), profileImage: defaultImageName, isUsingKickboard: false, rideHistory: [], registeredKickboards: dummyKickboards[0])
            var users = UserDefaultsManager.shared.getUsers() ?? [:]
            let newUserID = UUID().uuidString
            users[newUserID] = newUser
            UserDefaultsManager.shared.saveUsers(users)
            UserDefaultsManager.shared.saveLoggedInState(true)
            print("\(newUser)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func alreadyHaveAccountButtonTapped(_ sender: UIButton) {
        userEmailTextField.text = ""
        passwordTextField.text = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func showPasswordButton(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    
    func validateUserEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }

        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isEmailValid = predicate.evaluate(with: email)

        if isEmailValid {
            idValidationText.text = ""
            userEmailTextField.layer.borderColor = UIColor(named: "green")?.cgColor
            
            if let users = UserDefaultsManager.shared.getUsers(),
               users.values.contains(where: { $0.email == email }) {
                idValidationText.text = "이미 등록된 이메일 주소입니다."
                idValidationText.font = UIFont.systemFont(ofSize: 12)
                idValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
                userEmailTextField.layer.borderColor = UIColor(named: "red")?.cgColor
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x - 10, y: userEmailTextField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x + 10, y: userEmailTextField.center.y))
                userEmailTextField.layer.add(animation, forKey: "position")
                
                return false
            }
        } else {
            idValidationText.text = "이메일 주소 형식이 올바르지 않습니다."
            idValidationText.font = UIFont.systemFont(ofSize: 12)
            idValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            userEmailTextField.layer.borderColor = UIColor(named: "red")?.cgColor
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x - 10, y: userEmailTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x + 10, y: userEmailTextField.center.y))
            userEmailTextField.layer.add(animation, forKey: "position")
            
            return false
        }

        return true
    }
    
    
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }

        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{5,}$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isPasswordValid = predicate.evaluate(with: password)

        if !isPasswordValid {
            passwordValidationText.text = "영문 대문자, 소문자, 숫자를 모두 포함하여 5자 이상 작성하세요."
            passwordValidationText.font = UIFont.systemFont(ofSize: 9)
            passwordValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            passwordTextField.layer.borderColor = UIColor(named: "red")?.cgColor
                
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true // 역방향 애니메이션 적용
                animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 10, y: passwordTextField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 10, y: passwordTextField.center.y))
            passwordTextField.layer.add(animation, forKey: "position")
        } else {
            passwordValidationText.text = ""
            passwordTextField.layer.borderColor = UIColor(named: "green")?.cgColor
        }

        return isPasswordValid
    }
    
    
    func validateUserName(_ userName: String?) -> Bool {
        guard let userName = userName else { return false }

        let regex = "^[가-힣]{2,5}$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isUserNameValid = predicate.evaluate(with: userName)

        if !isUserNameValid {
            userNameValidationText.text = "한글 2~5자만 입력하세요."
            userNameValidationText.font = UIFont.systemFont(ofSize: 12)
            userNameValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            userNameTextField.layer.borderColor = UIColor(named: "red")?.cgColor
                
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: userNameTextField.center.x - 10, y: userNameTextField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: userNameTextField.center.x + 10, y: userNameTextField.center.y))
            userNameTextField.layer.add(animation, forKey: "position")
        } else {
            idValidationText.text = ""
            userNameTextField.layer.borderColor = UIColor(named: "green")?.cgColor
        }

        return isUserNameValid
    }

    func validateBirthdate(_ birthdate: String?) -> Bool {
        guard let birthdate = birthdate else { return false }
        
        let regex = "^\\d{4}-\\d{2}-\\d{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isBirthdateValid = predicate.evaluate(with: birthdate)
        
        if !isBirthdateValid {
            birthdateValidationText.text = "올바른 생년월일 형식이 아닙니다"
            birthdateValidationText.font = UIFont.systemFont(ofSize: 12)
            birthdateValidationText.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            
            birthdateTextField.layer.borderColor = UIColor.red.cgColor
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: birthdateTextField.center.x - 10, y: birthdateTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: birthdateTextField.center.x + 10, y: birthdateTextField.center.y))
            birthdateTextField.layer.add(animation, forKey: "position")
        } else {
            birthdateValidationText.text = ""
            birthdateTextField.layer.borderColor = UIColor(named: "green")?.cgColor
        }
        
        return isBirthdateValid
    }
    
    
    @objc private func handleTextInputChange() {
        let isFormValid = userEmailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false && userNameTextField.text?.isEmpty == false && birthdateTextField.text?.isEmpty == false
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 0.88, green: 0.76, blue: 1.00, alpha: 1.00)
        }
    }

    
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
    
    //    func loadImageFromPath(_ path: String) {
    //        if let image = UIImage(contentsOfFile: path) {
    //            yourProfileImageView.image = image
    //        } else {
    //            print("이미지를 불러올 수 없습니다.")
    //        }
    //    }
    //
    func createDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        
        let calendar = Calendar(identifier: .gregorian)
        var minDateComponents = DateComponents()
        minDateComponents.year = 1980
        minDateComponents.month = 1
        minDateComponents.day = 1
        datePicker.minimumDate = calendar.date(from: minDateComponents)
        
        datePicker.maximumDate = Date()

        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        birthdateTextField.inputView = datePicker
        birthdateTextField.text = dateFormat(date: Date())
        birthdateTextField.placeholder = "birthdate"
    }

    @objc func dateChange(_ sender: UIDatePicker) {
        birthdateTextField.text = dateFormat(date: sender.date)
    }

    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
}


extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func handleTapOnView() {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEmailText = userEmailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let userNameText = userNameTextField.text ?? ""
        let birthdateText = birthdateTextField.text ?? ""
        
        signUpButton.isEnabled = !userEmailText.isEmpty && !userNameText.isEmpty && !passwordText.isEmpty && !birthdateText.isEmpty
        
        return true
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let imageURL = info[.imageURL] as? URL {
            plusPhotoButton.circleImage = true
            let imageName = imageURL.lastPathComponent
            print("선택한 이미지 파일 이름: \(imageName)")
            
            selectedImageName = imageName
            
            plusPhotoButton.setImage(selectedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 선택이 취소될 때 호출되는 메서드
        // 이미지 피커를 닫습니다.
        picker.dismiss(animated: true, completion: nil)
    }
    
}
