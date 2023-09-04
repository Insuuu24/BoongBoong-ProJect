//
//  BoongBoongModel.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import Foundation

struct User {
    var email: String
    var password: String
    var name: String
    var birthdate: Date
    var profileImage: String
    var isUsingKickboard: Bool
    var rideHistory: [RideHistory]
    var registeredKickboards: Kickboard
}

struct Kickboard {
    var id: UUID
    var boongboongImage: String
    var boongboongName: String
    var latitude: Double
    var longitude: Double
    var isBeingUsed: Bool
}

struct RideHistory {
    var kickboardID: UUID
    var startTime: Date
    var endTime: Date
    var startPosition: (Double, Double)
    var endPosition: (Double, Double)
}
