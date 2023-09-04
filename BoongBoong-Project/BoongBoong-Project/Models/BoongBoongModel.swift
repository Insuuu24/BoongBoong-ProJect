//
//  BoongBoongModel.swift
//  BoongBoong-ProJect
//
//  Created by Insu on 2023/09/04.
//

import UIKit

struct User: Codable {
    var email: String
    var password: String
    var name: String
    var birthdate: Date
    var profileImage: String
    var isUsingKickboard: Bool
    var rideHistory: [RideHistory]
    var registeredKickboards: Kickboard
}

struct Kickboard: Codable {
    var id: UUID
    var registerDay: Date
    var boongboongImage: String
    var boongboongName: String
    var latitude: Double
    var longitude: Double
    var isBeingUsed: Bool
}

struct RideHistory: Codable {
    var kickboardID: UUID
    var startTime: Date
    var endTime: Date
    var startPosition: Position
    var endPosition: Position
}

struct Position: Codable {
    var latitude: Double
    var longitude: Double
}
