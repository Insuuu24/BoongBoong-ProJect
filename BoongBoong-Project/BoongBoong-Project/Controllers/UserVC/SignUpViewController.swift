//
//  SignUpViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userEmailValidationLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVaildationLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameValidationLabel: UILabel!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var birthDateValidationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    var selectedProfileImageData: Data?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        
        handleTextInputChange()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        
        signUpButton.isEnabled = false
        
        userEmailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        birthDateTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(named: "mainColor") ?? UIColor.systemBlue]))
        
        alreadyHaveAccountButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedURL = urls.first {
            let imagePath = selectedURL.path
            print("선택한 이미지 파일의 경로: \(imagePath)")
        }
    }
    
    private func validateUserEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = predicate.evaluate(with: email)
        
        if !isEmailValid {
            userEmailValidationLabel.text = "이메일 주소 형식이 올바르지 않습니다."
            userEmailValidationLabel.font = UIFont.systemFont(ofSize: 12)
            userEmailValidationLabel.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x - 10, y: userEmailTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: userEmailTextField.center.x + 10, y: userEmailTextField.center.y))
            userEmailTextField.layer.add(animation, forKey: "position")
        } else {
            userEmailValidationLabel.text = ""
        }
        
        return isEmailValid
    }
    
    private func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isPasswordValid = predicate.evaluate(with: password)
        
        if !isPasswordValid {
            passwordVaildationLabel.text = "영어, 숫자, 특수문자를 포함하여 5자 이상 입력해주세요."
            passwordVaildationLabel.font = UIFont.systemFont(ofSize: 10)
            passwordVaildationLabel.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 10, y: passwordTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 10, y: passwordTextField.center.y))
            passwordTextField.layer.add(animation, forKey: "position")
        } else {
            passwordVaildationLabel.text = ""
        }
        
        return isPasswordValid
    }
    
    private func validateUserName(_ userName: String?) -> Bool {
        guard let userName = userName else { return false }
        
        let regex = "^[가-힣ㄱ-ㅎㅏ-ㅣ]{2,5}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isUserNameValid = predicate.evaluate(with: userName)
        
        if !isUserNameValid {
            userNameValidationLabel.text = "한글 2~5자만 입력하세요."
            userNameValidationLabel.font = UIFont.systemFont(ofSize: 12)
            userNameValidationLabel.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: userNameTextField.center.x - 10, y: userNameTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: userNameTextField.center.x + 10, y: userNameTextField.center.y))
            userNameTextField.layer.add(animation, forKey: "position")
        } else {
            userEmailValidationLabel.text = ""
        }
        
        return isUserNameValid
    }
    
    private func validateBirthdate(_ birthdate: String?) -> Bool {
        guard let birthdate = birthdate else { return false }
        
        let regex = "^\\d{4}.\\d{2}.\\d{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isBirthdateValid = predicate.evaluate(with: birthdate)
        
        if !isBirthdateValid {
            birthDateValidationLabel.text = "올바른 생년월일 형식이 아닙니다"
            birthDateValidationLabel.font = UIFont.systemFont(ofSize: 12)
            birthDateValidationLabel.textColor = UIColor(red: 0.56, green: 0.27, blue: 0.96, alpha: 1.00)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: birthDateTextField.center.x - 10, y: birthDateTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: birthDateTextField.center.x + 10, y: birthDateTextField.center.y))
            birthDateTextField.layer.add(animation, forKey: "position")
        } else {
            birthDateValidationLabel.text = ""
        }
        
        return isBirthdateValid
    }
    
    private func createDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        birthDateTextField.inputView = datePicker
        birthDateTextField.placeholder = "날짜를 선택해주세요"
    }
    
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let userEmail = userEmailTextField.text ?? ""
        let userPassword = passwordTextField.text ?? ""
        let userName = userNameTextField.text ?? ""
        let birthdateText = birthDateTextField.text ?? ""
        
        if !validateUserEmail(userEmail) { return }
        if !validatePassword(userPassword) { return }
        if !validateUserName(userName) { return }
        if !validateBirthdate(birthdateText) {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let imageData = selectedProfileImageData {
            if let birthdate = dateFormatter.date(from: birthdateText) {
                let newUser = User(email: userEmail, password: userPassword, name: userName, birthdate: birthdate, profileImage: imageData, isUsingKickboard: false, rideHistory: [])
                
                var users = UserDefaultsManager.shared.getUsers() ?? [:]
                
                let newUserID = UUID().uuidString
                users[newUserID] = newUser
                
                UserDefaultsManager.shared.saveUsers(users)
                //UserDefaultsManager.shared.saveLoggedInState(true)
                
                print("\(newUser)")
                
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            print("회원가입이 실패하였습니다.")
        }

    }
    
    @IBAction func alreadyHaveAccountButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
    @objc private func handleTapOnView() {
        self.view.endEditing(true)
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = userEmailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false && userNameTextField.text?.isEmpty == false && birthDateTextField.text?.isEmpty == false && selectedProfileImageData != nil

        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(named: "mainColor")
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(named: "subColor")
        }
    }

    @objc func dateChange(_ sender: UIDatePicker) {
        birthDateTextField.text = dateFormat(date: sender.date)
        birthDateTextField.resignFirstResponder()
        handleTextInputChange()
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEmailText = userEmailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let userNameText = userNameTextField.text ?? ""
        let birthdateText = birthDateTextField.text ?? ""
        
        signUpButton.isEnabled = !userEmailText.isEmpty && !userNameText.isEmpty && !passwordText.isEmpty && !birthdateText.isEmpty
        
        return true
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoButton.circleImage()
            
            if let imageData = selectedImage.pngData() {
                selectedProfileImageData = imageData
                photoButton.setImage(selectedImage, for: .normal)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}



