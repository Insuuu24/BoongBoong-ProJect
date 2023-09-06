//
//  RentKickboardViewController.swift
//  BoongBoong-Project
//
//  Created by 이재희 on 2023/09/06.
//

import UIKit
import FloatingPanel

class RentKickboardViewController: UIViewController {
    
    @IBOutlet weak var kickboardImage: UIImageView!
    @IBOutlet weak var kickboardName: UILabel!
    @IBOutlet weak var kickboardDistance: UILabel!
    @IBOutlet weak var kickboardRegion: UILabel!
    
    var selectedKickboard: Kickboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kickboardImage.layer.cornerRadius = 20
        if let kickboard = selectedKickboard {
            if kickboard.boongboongImage != "" {
                kickboardImage.image = UIImage(named: kickboard.boongboongImage)
            }
            kickboardName.text = kickboard.boongboongName
        }
    }
    
    @IBAction func rentButtonTapped(_ sender: UIButton) {
        let userDefaultsManager = UserDefaultsManager.shared
        
        // 1. 현재 사용자의 isUsingKickboard를 true로 변경
        if var user = userDefaultsManager.getUser() {
            user.isUsingKickboard = true
            userDefaultsManager.saveUser(user)
        }
        
        // 2. 현재 사용자의 rideHistory에 추가 (예: 현재 시간을 추가)
        // FIXME: 대여시간 받아와서 내용 수정하기
        let kickboardID = selectedKickboard?.id
        let startTime = Date()
        let endTime = Date()
        let startPosition = Position(latitude: 37.1234, longitude: 126.5678)
        let endPosition = Position(latitude: 37.5678, longitude: 127.1234)
        
        // 대여 기록 추가
        userDefaultsManager.updateRideHistory(with: RideHistory(kickboardID: kickboardID!, startTime: startTime, endTime: endTime, startPosition: startPosition, endPosition: endPosition))
        
        
        // 3. 해당 킥보드의 isBeingUsed를 true로 변경
        if let selectedKickboard = selectedKickboard, var kickboards = userDefaultsManager.getRegisteredKickboards() {
            if let index = kickboards.firstIndex(where: { $0.id == selectedKickboard.id }) {
                kickboards[index].isBeingUsed = true
                userDefaultsManager.saveRegisteredKickboards(kickboards)
            }
        }
        dismiss(animated: true)
        
    }
    
}

//extension RentKickboardViewController: FloatingPanelControllerDelegate {
//    // Floating Panel의 상태가 변경될 때 호출됩니다.
//    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
//        // 상태에 따른 동작을 수행할 수 있습니다.
//    }
//}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0

        surfaceView.grabberHandle.isHidden = true
        surfaceView.appearance = appearance
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {

    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.35, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.2
    }
}
