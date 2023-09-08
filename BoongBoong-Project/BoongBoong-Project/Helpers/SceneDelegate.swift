//
//  SceneDelegate.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if !isAppAlreadyLaunchedOnce() {
            // FIXME: 아래 코드 위치 나중에 변경하기 (킥보드 더미데이터 추가하는 부분임)
            var kickboards: [Kickboard] = []
            for (index, location) in locations.enumerated() {
                kickboards.append(Kickboard(
                    id: UUID(), registerDate: Date(), boongboongImage: (UIImage(named: "defaultKickboardImage")?.pngData()!)!,
                    boongboongName: "BoongBoong \(index + 1)",
                    latitude: location.latitude,
                    longitude: location.longitude,
                    isBeingUsed: false
                ))
            }
            UserDefaultsManager.shared.saveRegisteredKickboards(kickboards)
        }
        
        if UserDefaultsManager.shared.isLoggedIn() {
            let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
            if let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPage") as? MainPageViewController {
                window.rootViewController = mainPageViewController
                window.makeKeyAndVisible()
            }
        } else {
            let storyboard = UIStoryboard(name: "SignInPage", bundle: nil)
            if let signInPageViewController = storyboard.instantiateViewController(withIdentifier: "SignInPage") as? SignInViewController {
                window.rootViewController = signInPageViewController
                window.makeKeyAndVisible()
            }
        }


    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
}

