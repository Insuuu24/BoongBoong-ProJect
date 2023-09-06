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
    @IBOutlet weak var changePasswordButton: UIButton!
    
    let userDefaults = UserDefaultsManager.shared
    var selectedImage: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNav()
        
        if let profileImage = userDefaults.getUser()?.profileImage {
            profileImageView.image = UIImage(data: profileImage)
        }
        profileImageView.circleImage = true
        changeImageButton.isHidden = true
        changeImageButton.layer.cornerRadius = 5
        nameTextField.isEnabled = false
        emailTextField.isEnabled = false
        birthdateTextField.isEnabled = false
        
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
    
    // MARK: - Image Picker
    
    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editedImage
            selectedImage = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        changeImageButton.isHidden = false
        nameTextField.isEnabled = true
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
    }
    
    
}
