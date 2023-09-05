//
//  AddKickBoardViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import MapKit
import CoreLocation

class AddKickBoardViewController: UIViewController {
    
    @IBOutlet weak var kickboardImageButton: UIImageView!
    @IBOutlet weak var kickboardName: UITextField!
    @IBOutlet weak var registerDate: UITextField!
    @IBOutlet weak var kickboardMapView: MKMapView!
    @IBOutlet weak var registerButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    // TODO: 위치 권한 허용 안함 선택했을 시 다시 요청
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy / MM / dd"
        registerDate.text = dateFormatter.string(from: Date())
        registerDate.isEnabled = false
        
        kickboardName.addTarget(self, action: #selector(kickboardNameChanged), for: .editingChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kickboardImageButton.circleImage = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        kickboardMapView.showsUserLocation = true
    }
    
    @objc func kickboardNameChanged() {
        updateRegisterButtonState()
    }
    
    func updateRegisterButtonState() {
        if let text = kickboardName.text, !text.isEmpty {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor(named: "mainColor")
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor(named: "subColor")
        }
    }
    
    @IBAction func regionButtonTapped(_ sender: UIButton) {
        if let userLocation = kickboardMapView.userLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            kickboardMapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let userDefaultsManager = UserDefaultsManager.shared
        
        var (latitude, longitude) = (0.0, 0.0)
        if let userLocation = kickboardMapView.userLocation.location {
            latitude = userLocation.coordinate.latitude
            longitude = userLocation.coordinate.longitude
        }
        
        let newKickboard = Kickboard(id: UUID(), registerDate: Date(), boongboongImage: "", boongboongName: kickboardName.text!, latitude: latitude, longitude: longitude, isBeingUsed: false)
        
        if var registeredKickboards = userDefaultsManager.getRegisteredKickboards() {
            registeredKickboards.append(newKickboard)
            userDefaultsManager.saveRegisteredKickboards(registeredKickboards)
        } else {
            let registeredKickboards = [newKickboard]
            userDefaultsManager.saveRegisteredKickboards(registeredKickboards)
        }
        
        // FIXME: 로그인 구현 후에 삭제
        userDefaultsManager.saveUser(dummyUsers[0])
        
        if var user = userDefaultsManager.getUser() {
            user.registeredKickboard = newKickboard
            userDefaultsManager.saveUser(user)
        }
    
        print(userDefaultsManager.getRegisteredKickboards()!)
        dismiss(animated: true)
    }
    
    
}

// MARK: - CLLocationManagerDelegate

extension AddKickBoardViewController: CLLocationManagerDelegate {
    
    // 위치 업데이트 시 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let regionRadius: CLLocationDistance = 300 // 300m
            
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            kickboardMapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}
