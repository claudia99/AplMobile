//
//  DriverStanding.swift
//  AplMobile
//
//  Created by Claudia Apostol on 13.05.2022.
//

import Foundation

public struct DriverStandings: Codable {
    public let data: DriverStandingsData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct DriverStandingsData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let standingsTable: StandingsTable?
    public let driverTable: DriverTable?

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case standingsTable = "StandingsTable"
        case driverTable = "DriverTable"
    }
}

public struct StandingsTable: Codable {
    public let season: String?
    public let standingsLists: [StandingsList]

    private enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

public struct StandingsList: Codable {
    public let season, round: String
    public let driverStandings: [DriverStanding]?
    public let constructorStandings: [ConstructorStandings]?
    

    private enum CodingKeys: String, CodingKey {
        case season
        case round
        case driverStandings = "DriverStandings"
        case constructorStandings = "ConstructorStandings"
    }
}

public struct DriverStanding: Codable {
    public let position: String
    public let positionText: String
    public let points: String
    public let wins: String
    public let driver: Driver
    public let constructors: [Constructor]
    
    private enum CodingKeys: String, CodingKey {
        case position
        case positionText
        case points
        case wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}
