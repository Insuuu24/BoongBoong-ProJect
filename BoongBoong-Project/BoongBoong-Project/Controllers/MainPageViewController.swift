import UIKit
import MapKit
import CoreLocation
import FloatingPanel

// MainPageViewController 클래스는 메인 화면에 대한 ViewController입니다.
class MainPageViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    
    // 현재 사용 중인 사용자 정보를 저장하기 위한 변수입니다.
    var currentUsing: User?
    let locationManager = CLLocationManager()
    var fpc: FloatingPanelController!
    
    // Interface Builder에 있는 UI 요소에 대한 참조입니다.
    @IBOutlet weak var homeMap: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var addKickboardButton: UIButton!
    @IBOutlet weak var returnKickboardButton: UIButton!
    
    var timer: Timer?
    var remainingTimeInSeconds = 60
    
    // MARK: - View Life Cycle
    
    // 뷰 컨트롤러가 메모리에 로드된 후 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 검색 바와 지도의 델리게이트 설정입니다.
        mapSearchBar.delegate = self
        mapSearchBar.placeholder = "위치 검색"
        homeMap.delegate = self
        
        // 지도를 탭했을 때의 제스처 인식기를 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        homeMap.addGestureRecognizer(tapGesture)
        
        // 더미데이터 추가해놓음 -> 앱 실행 시킬때마다 계속 추가되니까 주의하세요!
        if var kickboards = UserDefaultsManager.shared.getRegisteredKickboards() {
            let kickboard1 = Kickboard(
                id: UUID(),
                registerDate: Date(),
                boongboongImage: "",
                boongboongName: "BoongBoong 1",
                latitude: 37.1234,
                longitude: 126.5678,
                isBeingUsed: false
            )
            
            let kickboard2 = Kickboard(
                id: UUID(),
                registerDate: Date(),
                boongboongImage: "",
                boongboongName: "BoongBoong 2",
                latitude: 37.4321,
                longitude: 127.8765,
                isBeingUsed: true
            )
            kickboards.append(kickboard1)
            kickboards.append(kickboard2)
            UserDefaultsManager.shared.saveRegisteredKickboards(kickboards)
        }
    }
    
    override func viewWillLayoutSubviews() {
        let user = UserDefaultsManager.shared.getUser()
        
        if (user?.registeredKickboard) != nil {
            addKickboardButton.isHidden = true
            
            if user?.isUsingKickboard == true {
                if timer == nil {
                    startTimer()
                }
                returnKickboardButton.isHidden = false
            } else {
                timer?.invalidate()
                timer = nil
                returnKickboardButton.isHidden = true
            }
            
        } else {
            addKickboardButton.isHidden = false
            returnKickboardButton.isHidden = true
        }
        addKickboardMarkersToMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // 뷰가 화면에서 사라지기 직전에 호출됩니다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Helpers
    
    func addKickboardMarkersToMap() {
        if let kickboards = UserDefaultsManager.shared.getRegisteredKickboards() {
            print(kickboards.count)
            for kickboard in kickboards {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: kickboard.latitude, longitude: kickboard.longitude)
                annotation.title = kickboard.boongboongName
                homeMap.addAnnotation(annotation)
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if self.remainingTimeInSeconds > 0 {
                self.remainingTimeInSeconds -= 1
                
                DispatchQueue.main.async {
                    let minutes = self.remainingTimeInSeconds / 60
                    let seconds = self.remainingTimeInSeconds % 60
                    self.returnKickboardButton.setTitle(String(format: "%02d : %02d", minutes, seconds), for: .normal)
                }
            } else {
                timer.invalidate()
                self.timer = nil
                
                DispatchQueue.main.async {
                    self.returnKickboardButton.setTitle("반납하기", for: .normal)
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            RunLoop.current.add(self.timer!, forMode: .default)
            RunLoop.current.run()
        }
    }
    
    // MARK: - Actions
    
    // 킥보드 추가 버튼이 탭됐을 때 호출될 액션입니다.
    @IBAction func addKickboardButtonTapped(_ sender: UIButton) {
    }
    
    // 킥보드 반환 버튼이 탭됐을 때 호출될 액션입니다.
    @IBAction func returnKickboardButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "반납 확인", message: "현재 위치에 킥보드를 반납하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.performReturnKickboardAction()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func performReturnKickboardAction() {
        // TODO: 현재 위치 저장 로직 추가
        if var user = UserDefaultsManager.shared.getUser() {
            user.isUsingKickboard = false
            UserDefaultsManager.shared.saveUser(user)
        }
        returnKickboardButton.isHidden = true
        
        // FIXME: 작동 왜 안함..?
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "알림"
        notificationContent.body = "킥보드 반납이 완료되었습니다"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "returnKickboardNotification", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 추가 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("알림이 성공적으로 추가되었습니다.")
            }
        }
    }
    
    // MARK: - Functions
    
    // 사용자가 검색 바에 텍스트를 입력할 때마다 호출됩니다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 주어진 검색어로 로컬 검색을 시작합니다.
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            // 검색 결과가 없거나 에러가 발생하면 에러를 출력합니다.
            if response == nil {
                print("Error")
            } else {
                // 검색된 위치의 좌표를 가져옵니다.
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // 지도에 있는 모든 주석을 제거합니다.
                let annotations = self.homeMap.annotations
                self.homeMap.removeAnnotations(annotations)
                
                // 새로운 주석을 생성하고 지도에 추가합니다.
                let annotation = MKPointAnnotation()
                annotation.title = searchText
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.homeMap.addAnnotation(annotation)
                
                // 지도를 검색된 위치로 이동시킵니다.
                let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
                self.homeMap.setRegion(coordinateRegion, animated: true)
            }
        }
    }
    
    // 지도의 영역이 변경되면 호출됩니다.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 현재 지도의 중심 좌표를 가져옵니다.
        let center = mapView.centerCoordinate
        // 한국의 최대/최소 위도와 경도 값을 정의합니다.
        let southKoreaMaxLat: CLLocationDegrees = 38.634000
        let southKoreaMinLat: CLLocationDegrees = 33.004115
        let southKoreaMaxLon: CLLocationDegrees = 131.872699
        let southKoreaMinLon: CLLocationDegrees = 124.586300
        
        // 지도가 한국의 영역을 벗어나면 중심 좌표를 서울로 되돌립니다.
        if center.latitude > southKoreaMaxLat || center.latitude < southKoreaMinLat || center.longitude > southKoreaMaxLon || center.longitude < southKoreaMinLon {
            mapView.setCenter(CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), animated: true)
        }
    }
    
    // 지도를 탭했을 때의 액션입니다.
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        // 탭한 위치의 좌표를 가져와서 주석을 생성하고 지도에 추가합니다.
        let location = gesture.location(in: homeMap)
        let coordinate = homeMap.convert(location, toCoordinateFrom: homeMap)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        homeMap.addAnnotation(annotation)
    }
    
    // 지도의 주석을 탭했을 때 호출됩니다.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 선택된 주석을 지도에서 제거합니다.
        if let annotation = view.annotation {
            mapView.removeAnnotation(annotation)
            
            // FIXME: 데이터 전달 필요함
            if let markerAnnotation = annotation as? MKPointAnnotation {
                configureFloatingPanel()
            }
        }
    }
    
    func configureFloatingPanel() {
        fpc = FloatingPanelController()
        //fpc.delegate = self
        
        let contentVC = UIStoryboard(name: "RentKickboardPage", bundle: nil).instantiateViewController(withIdentifier: "RentKickboard2")
        fpc.set(contentViewController: contentVC)
        
        fpc.changePanelStyle()
        fpc.layout = MyFloatingPanelLayout()
        fpc.contentMode = .static
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        fpc.addPanel(toParent: self)
    }
    
    func circularImageWithBorder(image: UIImage, targetSize: CGSize, borderWidth: CGFloat = 4.0, borderColor: UIColor = UIColor.purple) -> UIImage? {
        let diameter = min(targetSize.width, targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter)))
        path.addClip()
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        
        // 테두리 그리기
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 사용자의 현재 위치에 대한 주석은 기본 뷰를 반환합니다.
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true // 터치시 정보 창이 나타나도록 합니다.
        } else {
            annotationView?.annotation = annotation
        }
        
        // "Maker" 이미지를 불러옵니다. // 이 부분에서 사이즈 조절 가능
        if let makerImage = UIImage(named: "Maker") {
            if let circularMakerImage = circularImageWithBorder(image: makerImage, targetSize: CGSize(width: 50, height: 50)) {
                annotationView?.image = circularMakerImage
            }
        }
        return annotationView
    }
    // 현재 사용자의 킥보드 사용 상태에 따라 버튼의 타이틀을 업데이트합니다.
    func updateKickboardButtonTitle() {
        if let user = currentUsing, user.isUsingKickboard {
            addKickboardButton.setTitle("탑승 중", for: .normal)
        }
    }
}

extension MainPageViewController: CLLocationManagerDelegate {
    
    // 위치 업데이트 시 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let regionRadius: CLLocationDistance = 300 // 300m
            
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            homeMap.setRegion(region, animated: true)  // 수정된 부분
            manager.stopUpdatingLocation()
        }
    }
}
