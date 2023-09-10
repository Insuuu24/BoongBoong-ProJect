//
//  UserDefaultsManager.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/04.
//

import UIKit

let locations: [(latitude: Double, longitude: Double)] = [
    // 강동구 위치
    (37.52928, 127.12390),
    
    // 송파구 위치
    (37.51475, 127.10650),
    
    // 강남구 위치
    (37.51796, 127.04736),
    
    // 서초구 위치
    (37.48295, 127.03215),
    
    // 관악구 위치
    (37.47743, 126.95189),
    
    // 동작구 위치
    (37.51213, 126.94039),
    
    // 금천구 위치
    (37.45683, 126.89603),
    
    // 구로구 위치
    (37.49488, 126.88888),
    
    // 영등포구 위치
    (37.52624, 126.89588),
    
    // 양천구 위치
    (37.51689, 126.86726),
    
    // 강서구 위치
    (37.56755, 126.81823),
    
    // 광진구 위치
    (37.53820, 127.08429),
    
    // 중랑구 위치
    (37.60628, 127.09429),
    
    // 노원구 위치
    (37.65275, 127.05855),
    
    // 도봉구 위치
    (37.66894, 127.04859),
    
    // 강북구 위치
    (37.62544, 127.02851),
    
    // 성북구 위치
    (37.58924, 127.01819),
    
    // 동대문구 위치
    (37.57443, 127.04049),
    
    // 성동구 위치
    (37.56444, 127.03821),
    
    // 중구 위치
    (37.55946, 127.00664),
    
    // 용산구 위치
    (37.53277, 126.98993),
    
    // 종로구 위치
    (37.57276, 126.97817),
    
    // 서대문구 위치
    (37.57892, 126.93681),
    
    // 마포구 위치
    (37.56601, 126.90334),
    
    // 은평구 위치
    (37.60212, 126.92998)
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
    
    static var id = 0
    
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

    // 등록된 킥보드 정보 저장
    func saveRegisteredKickboards(_ kickboards: [Kickboard]) {
        print(kickboards)
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
            registeredKickboard.boongboongName = newName
            registeredKickboard.boongboongImage = newImage.pngData()!
            user.registeredKickboard = registeredKickboard
            saveUser(user)
        }
        print(kickboardID)
        if var kickboards = getRegisteredKickboards() {
            print(kickboards)
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
