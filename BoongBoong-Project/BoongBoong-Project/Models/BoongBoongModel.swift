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
    var profileImage: Data
    var isUsingKickboard: Bool
    var rideHistory: [RideHistory]
    var registeredKickboard: Kickboard?
}

struct Kickboard: Codable {
    let id: UUID
    var registerDate: Date
    var boongboongImage: Data
    var boongboongName: String
    var latitude: Double
    var longitude: Double
    var isBeingUsed: Bool
}

struct RideHistory: Codable {
    var boongboongName: String
    var startTime: Date
    var endTime: Date
    var startPosition: Position
    var endPosition: Position
}

struct Position: Codable {
    var latitude: Double
    var longitude: Double
}
