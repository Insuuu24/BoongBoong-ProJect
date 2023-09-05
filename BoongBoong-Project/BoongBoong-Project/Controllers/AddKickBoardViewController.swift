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
    
    @IBOutlet weak var kickboardMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // TODO: 위치 권한 허용 안함 선택했을 시 다시 요청
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        kickboardMapView.showsUserLocation = true
    }
    
    @IBAction func regionButtonTapped(_ sender: UIButton) {
        if let userLocation = kickboardMapView.userLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            kickboardMapView.setRegion(region, animated: true)
        }
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
