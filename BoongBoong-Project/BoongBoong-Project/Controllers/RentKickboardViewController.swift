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
    @IBOutlet weak var rentButton: UIButton!
    
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
        
        let alert = UIAlertController(title: "대여 시간 선택", message: "대여하실 시간을 선택해주세요", preferredStyle: .alert)
                        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.minuteInterval = 10
                
        let vc = UIViewController()
        vc.view = datePicker
                
        alert.setValue(vc, forKey: "contentViewController")
        
        var selectedHours = 0
        var selectedMinutes = 0
        
        let confirmAction = UIAlertAction(title: "선택 완료", style: .default) { (_) in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            selectedHours = components.hour ?? 0
            selectedMinutes = components.minute ?? 0
            
            print("선택된 대여 시간: \(selectedHours)시간 \(selectedMinutes)분")
            
            let anotherAlert = UIAlertController(title: "대여 확인", message: "\(selectedHours)시간 \(selectedMinutes)분 대여하시겠습니까?", preferredStyle: .alert)
            
            let anotherConfirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
                // 1. 현재 사용자의 isUsingKickboard를 true로 변경
                if var user = userDefaultsManager.getUser() {
                    user.isUsingKickboard = true
                    userDefaultsManager.saveUser(user)
                }

                // 2. 현재 사용자의 rideHistory에 추가 (예: 현재 시간을 추가)
                // FIXME: 위치 받아와서 내용 수정하기
                let kickboardID = self.selectedKickboard?.id
                let startTime = Date()
                let endTime = Calendar.current.date(byAdding: .minute, value: selectedHours * 60 + selectedMinutes, to: startTime)!
                let startPosition = Position(latitude: 37.1234, longitude: 126.5678)
                let endPosition = Position(latitude: 37.5678, longitude: 127.1234)

                // 대여 기록 추가
                userDefaultsManager.updateRideHistory(with: RideHistory(kickboardID: kickboardID!, startTime: startTime, endTime: endTime, startPosition: startPosition, endPosition: endPosition))


                // 3. 해당 킥보드의 isBeingUsed를 true로 변경
                if let selectedKickboard = self.selectedKickboard, var kickboards = userDefaultsManager.getRegisteredKickboards() {
                    if let index = kickboards.firstIndex(where: { $0.id == selectedKickboard.id }) {
                        kickboards[index].isBeingUsed = true
                        userDefaultsManager.saveRegisteredKickboards(kickboards)
                    }
                }
                self.dismiss(animated: true)
            }
            anotherAlert.addAction(anotherConfirmAction)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            anotherAlert.addAction(cancelAction)

            self.present(anotherAlert, animated: true, completion: nil)
        }
        alert.addAction(confirmAction)
                
        present(alert, animated: true)
        
    }
    
    @objc func handleTitleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            // title 영역을 터치했을 때 대화 상자를 닫습니다.
            dismiss(animated: true, completion: nil)
        }
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
