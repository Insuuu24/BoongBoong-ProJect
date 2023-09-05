//
//  UserDefaultsManager.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/04.
//

import UIKit

let dummyRideHistories = [
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: Position(latitude: 37.5665, longitude: 126.9780), endPosition: Position(latitude: 37.5775, longitude: 126.9880)),
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: Position(latitude: 37.5665, longitude: 126.9780), endPosition: Position(latitude: 37.5775, longitude: 126.9880))
]

let dummyKickboards = [
    Kickboard(id: UUID(), registerDate: Date(), boongboongImage: "image1.jpg", boongboongName: "BoongBoong 1", latitude: 37.5665, longitude: 126.9780, isBeingUsed: true),
    Kickboard(id: UUID(), registerDate: Date(), boongboongImage: "image2.jpg", boongboongName: "BoongBoong 2", latitude: 37.5675, longitude: 126.9790, isBeingUsed: false)
]

let dummyUsers = [
    User(email: "user1@example.com", password: "password1", name: "박인수", birthdate: Date(), profileImage: "profile1.jpg", isUsingKickboard: true, rideHistory: dummyRideHistories, registeredKickboard: dummyKickboards[0]),
    User(email: "user2@example.com", password: "password2", name: "서영덕", birthdate: Date(), profileImage: "profile2.jpg", isUsingKickboard: false, rideHistory: [], registeredKickboard: dummyKickboards[1])
]

class UserDefaultsManager {
    // UserDefaults 키 정의
    private let userKey = "user"
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
    }

    // 사용자 정보 가져오기
    func getUser() -> User? {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
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
    func updateKickboardInfo(kickboardID: UUID, newName: String, newImage: String) {
        if var user = getUser(), var registeredKickboard = user.registeredKickboard {
            if registeredKickboard.id == kickboardID {
                registeredKickboard.boongboongName = newName
                // TODO: 이미지 업데이트 로직 추가
                user.registeredKickboard = registeredKickboard
                saveUser(user)
            }
        }
        if var kickboards = getRegisteredKickboards() {
            if let index = kickboards.firstIndex(where: { $0.id == kickboardID }) {
                kickboards[index].boongboongName = newName
                // TODO: 이미지 업데이트 로직 추가
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

    // 로그아웃
    func logout() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: isLoggedInKey)
        userDefaults.removeObject(forKey: registeredKickboardsKey)
    }
}
