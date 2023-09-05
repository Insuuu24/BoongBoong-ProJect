//
//  ViewController.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit
import MapKit

class MainPageViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var homeMap: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var addKickboardButton: UIButton!
    @IBOutlet weak var returnKickboardButton: UIButton!
    
    var timer: Timer?
    var remainingTimeInSeconds = 60
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        let user = UserDefaultsManager.shared.getUser()
        
        if let kickboard = user?.registeredKickboard {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Helpers
    
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

    @IBAction func addKickboardButtonTapped(_ sender: UIButton) {
    }
    
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
    
}

