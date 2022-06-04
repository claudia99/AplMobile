//
//  Constructor.swift
//  AplMobile
//
//  Created by Claudia Apostol on 13.05.2022.
//

import Foundation

public struct ConstructorTable: Codable {
    public let season: String?
    public let round: String?
    public let constructors: [Constructor]
    
    private enum CodingKeys: String, CodingKey {
        case season
        case round
        case constructors = "Constructor"
    }
}

public struct ConstructorStandings: Codable {
    public let position: String?
    public let positionText: String?
    public let points: String?
    public let wins: String?
    public let constructor: Constructor?
    
    private enum CodingKeys: String, CodingKey {
        case position
        case positionText
        case points
        case wins
        case constructor = "Constructor"
    }
}

public struct Constructors: Codable {
    public let data: ConstructorsData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct ConstructorsData: Codable {
    public let xmlns: String
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let constructorTable: StandingsTable

    private enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case constructorTable = "StandingsTable"
    }
}


public struct Constructor: Codable {
    let constructorId: String
    let name: String
    let nationality: String
    let url: String
}
