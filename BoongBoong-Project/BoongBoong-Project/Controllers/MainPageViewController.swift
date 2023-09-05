import UIKit
import MapKit

// MainPageViewController 클래스는 메인 화면에 대한 ViewController입니다.
class MainPageViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    
    // 현재 사용 중인 사용자 정보를 저장하기 위한 변수입니다.
    var currentUsing: User?
    
    // Interface Builder에 있는 UI 요소에 대한 참조입니다.
    @IBOutlet weak var homeMap: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var addKickboardButton: UIButton!
    @IBOutlet weak var returnKickboardButton: UIButton!
    
    // MARK: - View Life Cycle
    
    // 뷰 컨트롤러가 메모리에 로드된 후 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 검색 바와 지도의 델리게이트 설정입니다.
        mapSearchBar.delegate = self
        mapSearchBar.placeholder = "위치 검색"
        homeMap.delegate = self
        
        // 킥보드 사용 상태에 따라 버튼 타이틀을 업데이트합니다.
        updateKickboardButtonTitle()
        
        // 지도를 탭했을 때의 제스처 인식기를 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        homeMap.addGestureRecognizer(tapGesture)
    }
    
    // 뷰가 화면에 나타나기 직전에 호출됩니다.
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
    
    
    
    // MARK: - Actions
    
    // 킥보드 추가 버튼이 탭됐을 때 호출될 액션입니다.
    @IBAction func addKickboardButtonTapped(_ sender: UIButton) {
    }
    
    // 킥보드 반환 버튼이 탭됐을 때 호출될 액션입니다.
    @IBAction func returnKickboardButtonTapped(_ sender: UIButton) {
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
    
    // 현재 사용자의 킥보드 사용 상태에 따라 버튼의 타이틀을 업데이트합니다.
    func updateKickboardButtonTitle() {
        if let user = currentUsing, user.isUsingKickboard {
            addKickboardButton.setTitle("탑승 중", for: .normal)
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
        }
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
}
