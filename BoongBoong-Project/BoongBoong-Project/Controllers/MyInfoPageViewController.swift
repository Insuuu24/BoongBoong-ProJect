//
//  MyInfoPageViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class MyInfoPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneEditButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    let userDefaults = UserDefaultsManager.shared
    var selectedImage: UIImage?
    
    var isNameChanged = false
    var isImageChanged = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        
        let user = userDefaults.getUser()!
        
        if let profileImage = userDefaults.getUser()?.profileImage {
            profileImageView.image = UIImage(data: profileImage)
        }
        profileImageView.circleImage = true
        changeImageButton.isHidden = true
        changeImageButton.circleImage = true
        
        nameTextField.isEnabled = false
        nameTextField.text = user.name
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        
        emailTextField.isEnabled = false
        emailTextField.text = user.email
        
        birthdateTextField.isEnabled = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM / dd"
        birthdateTextField.text = dateFormatter.string(from: user.birthdate)
        birthdateTextField.isEnabled = false
        
        doneEditButton.isHidden = true
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "마이페이지"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.titleTextAttributes = [.foregroundColor: UIColor.label]
            $0.shadowColor = .clear
        }
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    // MARK: - IBAction
    
    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        changeImageButton.isHidden = false
        nameTextField.isEnabled = true
        doneEditButton.isHidden = false
        doneEditButton.isEnabled = false
        changePasswordButton.isEnabled = false
        changePasswordButton.setTitleColor(.lightGray, for: .disabled)
    }
    
    @IBAction func doneEditButtonTapped(_ sender: UIButton) {
        // TODO: user정보 업데이트하기
        isNameChanged = false
        isImageChanged = false
        changePasswordButton.isEnabled = true
        changePasswordButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty, text != userDefaults.getUser()?.name {
            isNameChanged = true
        } else {
            isNameChanged = false
        }
        updateDoneEditButton()
    }
    
    fileprivate func updateDoneEditButton() {
        if isNameChanged || isImageChanged {
            doneEditButton.isEnabled = true
            doneEditButton.backgroundColor = UIColor(named: "mainColor")
        } else {
            doneEditButton.isEnabled = false
            doneEditButton.backgroundColor = UIColor(named: "subColor")
        }
    }
    
    // TODO: 비밀번호 변경 기능 구현
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editedImage
            selectedImage = editedImage
            isImageChanged = true
            updateDoneEditButton()
        }
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
