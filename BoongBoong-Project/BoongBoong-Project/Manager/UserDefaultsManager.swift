//
//  UserDefaultsManager.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/04.
//

import UIKit

let locations: [(latitude: Double, longitude: Double)] = [
    // 용산구 위치
    (37.545415, 126.978312), // 위치 1
    (37.541756, 126.976892), // 위치 2
    (37.546048, 126.981992), // 위치 3

    // 중구 위치
    (37.566295, 126.978924), // 위치 4
    (37.564342, 126.977984), // 위치 5
    (37.567229, 126.979500), // 위치 6

    // 동작구 위치
    (37.496415, 126.961470), // 위치 7
    (37.500567, 126.961884), // 위치 8
    (37.498267, 126.962614)  // 위치 9
]

let dummyRideHistories = [
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: Position(latitude: 37.5665, longitude: 126.9780), endPosition: Position(latitude: 37.5775, longitude: 126.9880)),
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: Position(latitude: 37.5665, longitude: 126.9780), endPosition: Position(latitude: 37.5775, longitude: 126.9880))
]

let dummyKickboards = [
    Kickboard(id: UUID(), registerDate: Date(), boongboongImage: (UIImage(named: "defaultKickboardImage")?.pngData()!)!, boongboongName: "BoongBoong 1", latitude: 37.5665, longitude: 126.9780, isBeingUsed: true),
    Kickboard(id: UUID(), registerDate: Date(), boongboongImage: (UIImage(named: "defaultKickboardImage")?.pngData()!)!, boongboongName: "BoongBoong 2", latitude: 37.5675, longitude: 126.9790, isBeingUsed: false)
]

let dummyUsers = [
    User(email: "user1@example.com", password: "password1", name: "박인수", birthdate: Date(), profileImage: (UIImage(named: "defaultUserImage")?.pngData()!)!, isUsingKickboard: false, rideHistory: dummyRideHistories, registeredKickboard: dummyKickboards[0]),
    User(email: "user2@example.com", password: "password2", name: "서영덕", birthdate: Date(), profileImage: (UIImage(named: "defaultUserImage")?.pngData()!)!, isUsingKickboard: false, rideHistory: [], registeredKickboard: dummyKickboards[1])
]

class UserDefaultsManager {
    // UserDefaults 키 정의
    private let userKey = "user"
    private let usersKey = "users"
    private let isLoggedInKey = "isLoggedIn"
    private let registeredKickboardsKey = "registeredKickboards"

    // UserDefaults 인스턴스
    private let userDefaults = UserDefaults.standard

    // 싱글톤 인스턴스
    static let shared = UserDefaultsManager()
    

    // 사용자 정보 저장
    func saveUser(_ user: User) {
        if let encodedData = try? JSONEncoder().encode(user) {
            userDefaults.set(encodedData, forKey: userKey)
        }
        // FIXME: 아래 코드 위치 나중에 변경하기 (킥보드 더미데이터 추가하는 부분임)
        var kickboards: [Kickboard] = []
        for (index, location) in locations.enumerated() {
            kickboards.append(Kickboard(
                id: UUID(),
                registerDate: Date(), boongboongImage: (UIImage(named: "defaultKickboardImage")?.pngData()!)!,
                boongboongName: "BoongBoong \(index + 1)",
                latitude: location.latitude,
                longitude: location.longitude,
                isBeingUsed: false
            ))
        }
        UserDefaultsManager.shared.saveRegisteredKickboards(kickboards)
    }

    // 사용자 정보 가져오기
    func getUser() -> User? {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
    
    // 모든 사용자 정보 저장하기
    func saveUsers(_ users: [String: User]) {
        if let encodedData = try? JSONEncoder().encode(users) {
            userDefaults.set(encodedData, forKey: usersKey)
        }
    }

    // 모든 사용자 정보 가져오기
    func getUsers() -> [String: User]? {
        if let userData = userDefaults.data(forKey: usersKey),
           let users = try? JSONDecoder().decode([String: User].self, from: userData) {
            return users
        }
        return nil
    }

    // 로그인 상태 저장
    func saveLoggedInState(_ isLoggedIn: Bool) {
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
    }

    // 로그인 상태 가져오기
    func isLoggedIn() -> Bool {
        return userDefaults.bool(forKey: isLoggedInKey)
    }
    
    // 현재 로그인한 사용자의 이메일 가져오기
    func getUserLoggedInEmail() -> String? {
        return userDefaults.string(forKey: "loggedInUserEmail")
    }

    // 등록된 킥보드 정보 저장
    func saveRegisteredKickboards(_ kickboards: [Kickboard]) {
        if let encodedData = try? JSONEncoder().encode(kickboards) {
            userDefaults.set(encodedData, forKey: registeredKickboardsKey)
        }
    }

    // 등록된 킥보드 정보 가져오기
    func getRegisteredKickboards() -> [Kickboard]? {
        if let kickboardsData = userDefaults.data(forKey: registeredKickboardsKey),
           let kickboards = try? JSONDecoder().decode([Kickboard].self, from: kickboardsData) {
            return kickboards
        }
        return nil
    }
    
    // 등록된 킥보드 정보 변경
    func updateKickboardInfo(kickboardID: UUID, newName: String, newImage: UIImage) {
        if var user = getUser(), var registeredKickboard = user.registeredKickboard {
            if registeredKickboard.id == kickboardID {
                registeredKickboard.boongboongName = newName
                user.registeredKickboard = registeredKickboard
                user.registeredKickboard?.boongboongImage = newImage.pngData()!
                saveUser(user)
            }
        }
        if var kickboards = getRegisteredKickboards() {
            if let index = kickboards.firstIndex(where: { $0.id == kickboardID }) {
                kickboards[index].boongboongName = newName
                kickboards[index].boongboongImage = newImage.pngData()!
                saveRegisteredKickboards(kickboards)
            }
        }
    }
    
    // 등록된 킥보드 삭제
    func deleteKickboard(_ kickboardIDToDelete: UUID) {
        if var user = getUser() {
            user.registeredKickboard = nil
            saveUser(user)
        }
        if var kickboards = getRegisteredKickboards() {
            kickboards.removeAll { $0.id == kickboardIDToDelete }
            saveRegisteredKickboards(kickboards)
        }
    }
    
    // 사용자 정보를 가져와서 대여 기록을 업데이트하는 함수
    func updateRideHistory(with rideHistory: RideHistory) {
        if var user = getUser() {
            var userRideHistories = user.rideHistory
            userRideHistories.append(rideHistory)
            user.rideHistory = userRideHistories
            saveUser(user)
        }
    }

    // 로그아웃
    func logout() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: isLoggedInKey)
        userDefaults.removeObject(forKey: registeredKickboardsKey)
    }
}
