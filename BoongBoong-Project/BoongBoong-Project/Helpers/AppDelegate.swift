//
//  AppDelegate.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // "첫 실행" 여부를 확인하고 더미데이터를 추가합니다.
        if !isAppAlreadyLaunchedOnce() {
            addDummyKickboardData()
        }
        sleep(1)
        // 앱의 나머지 초기화 코드를 진행합니다.
        return true
    }

    func isAppAlreadyLaunchedOnce() -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("firstLaunch.txt")

        if fileManager.fileExists(atPath: fileURL.path) {
            return true
        } else {
            try? "App Launched".write(to: fileURL, atomically: true, encoding: .utf8)
            return false
        }
    }
    
    func addDummyKickboardData() {
        var kickboards: [Kickboard] = []
        for (index, location) in locations.enumerated() {
            kickboards.append(Kickboard(
                id: UUID(), registerDate: Date(), boongboongImage: (UIImage(named: "defaultKickboardImage")?.pngData()!)!,
                boongboongName: "BoongBoong \(index + 1)",
                latitude: location.value.latitude,
                longitude: location.value.longitude,
                isBeingUsed: false
            ))
        }
        UserDefaultsManager.shared.saveRegisteredKickboards(kickboards)
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        sleep(1)
//        return true
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

