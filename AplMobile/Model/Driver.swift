//
//  Driver.swift
//  AplMobile
//
//  Created by Claudia Apostol on 05.05.2022.
//

import Foundation

public struct Driver: Codable {
    let code: String?
    let dateOfBirth: String
    let driverId: String
    let familyName: String
    let givenName: String
    let nationality: String
    let permanentNumber: String?
    let url: String
}

public struct DriverTable: Codable {
    public let drivers: [Driver]

    private enum CodingKeys: String, CodingKey {
        case drivers = "Drivers"
    }
}

