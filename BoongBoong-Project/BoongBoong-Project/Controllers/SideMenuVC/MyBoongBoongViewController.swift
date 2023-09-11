//
//  MyBoongBoongViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import Then
import MapKit

final class MyBoongBoongViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var kickboardImage: UIImageView!
    @IBOutlet weak var kickboardName: UITextField!
    @IBOutlet weak var registerDate: UITextField!
    @IBOutlet weak var kickboardMap: MKMapView!
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var editBarButton: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureUI()
        kickboardMap.showsUserLocation = true
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "My Boong Boong"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        editBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editBarButtonTapped))
        navigationItem.rightBarButtonItem = editBarButton
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
    
    private func configureUI() {
        if let kickboard = UserDefaultsManager.shared.getUser()?.registeredKickboard {
            kickboardImage.image = UIImage(data: kickboard.boongboongImage)
            kickboardImage.circleImage = true
            
            kickboardName.text = kickboard.boongboongName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy / MM / dd"
            let registerDateString = dateFormatter.string(from: kickboard.registerDate)
            registerDate.text = registerDateString
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: kickboard.latitude, longitude: kickboard.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = kickboard.boongboongName
            kickboardMap.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 300
            let region = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            kickboardMap.setRegion(region, animated: true)
            
            kickboardName.isEnabled = false
            registerDate.isEnabled = false
            editButton.isEnabled = false
            editButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func regionButtonTapped(_ sender: UIButton) {
        if let userLocation = kickboardMap.userLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            kickboardMap.setRegion(region, animated: true)
        }
    }
    
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        editButton.isHidden = false
        kickboardName.isEnabled = true
        kickboardName.addTarget(self, action: #selector(kickboardNameChanged), for: .editingChanged)
        if #available(iOS 16.0, *) {
            editBarButton.isHidden = true
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func kickboardNameChanged() {
        updateRegisterButtonState()
    }
    
    func updateRegisterButtonState() {
        if let text = kickboardName.text, !text.isEmpty {
            editButton.isEnabled = true
            editButton.backgroundColor = UIColor(named: "mainColor")
        } else {
            editButton.isEnabled = false
            editButton.backgroundColor = UIColor(named: "subColor")
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        if let newName = kickboardName.text,
           let newImage = kickboardImage.image,
           let kickboardID = UserDefaultsManager.shared.getUser()?.registeredKickboard?.id {
            UserDefaultsManager.shared.updateKickboardInfo(kickboardID: kickboardID, newName: newName, newImage: newImage)
            DispatchQueue.main.async {
                MainPageViewController.sharedInstance?.addKickboardMarkersToMap()
            }
        }
        
        editButton.isHidden = true
        kickboardName.isEnabled = false
        if #available(iOS 16.0, *) {
            editBarButton.isHidden = false
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editBarButtonTapped(_:)))
        }
    }
    
    @IBAction func deleteKickboardButtonTapped(_ sender: UIButton) {
        if let kickboardID = UserDefaultsManager.shared.getUser()?.registeredKickboard?.id {
            UserDefaultsManager.shared.deleteKickboard(kickboardID)
            
            navigationController?.popViewController(animated: true)
            MainPageViewController.sharedInstance?.addKickboardMarkersToMap()
        }
        
    }
    
}
