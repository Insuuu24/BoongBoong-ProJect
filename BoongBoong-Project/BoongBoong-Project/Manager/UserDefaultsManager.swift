//
//  UserDefaultsManager.swift
//  BoongBoong-Project
//
//  Created by Insu on 2023/09/04.
//

import Foundation


let dummyRideHistories = [
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: (37.5665, 126.9780), endPosition: (37.5775, 126.9880)),
    RideHistory(kickboardID: UUID(), startTime: Date(), endTime: Date(), startPosition: (37.5665, 126.9780), endPosition: (37.5755, 126.9860))
]

let dummyKickboards = [
    Kickboard(id: UUID(), boongboongImage: "image1.jpg", boongboongName: "BoongBoong 1", latitude: 37.5665, longitude: 126.9780, isBeingUsed: true),
    Kickboard(id: UUID(), boongboongImage: "image2.jpg", boongboongName: "BoongBoong 2", latitude: 37.5675, longitude: 126.9790, isBeingUsed: false)
]

let dummyUsers = [
    User(email: "user1@example.com", password: "password1", name: "박인수", birthdate: Date(), profileImage: "profile1.jpg", isUsingKickboard: true, rideHistory: dummyRideHistories, registeredKickboards: dummyKickboards[0]),
    User(email: "user2@example.com", password: "password2", name: "서영덕", birthdate: Date(), profileImage: "profile2.jpg", isUsingKickboard: false, rideHistory: [], registeredKickboards: dummyKickboards[1])
]

