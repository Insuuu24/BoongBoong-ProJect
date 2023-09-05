//
//  RentKickboardViewController.swift
//  BoongBoong-Project
//
//  Created by 이재희 on 2023/09/06.
//

import UIKit
import FloatingPanel

// TODO: RentKickboardViewController은 테스트용 -> MainPageViewController에서 연결하기
class RentKickboardViewController: UIViewController {
    
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingPanel()
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

class RentKickboardViewController2: UIViewController {
    
    @IBOutlet weak var kickboardImage: UIImageView!
    @IBOutlet weak var kickboardName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kickboardImage.layer.cornerRadius = 20
    }
    
    @IBAction func rentButtonTapped(_ sender: UIButton) {
    }
    
}
