//
//  Item.swift
//  Prueba tecnica
//
//  Created by César MS on 28/06/21.
//

import Foundation

struct Item: Codable {
    let name: String
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin: String
    let description, lifeSpan: String
    let affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, intelligence: Int
    let wikipediaURL: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case description = "description"
        case lifeSpan = "life_span"
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case intelligence
        case wikipediaURL = "wikipedia_url"
        case image
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let url: String?
}
