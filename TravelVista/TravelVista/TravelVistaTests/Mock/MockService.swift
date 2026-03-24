//
//  MockService.swift
//  TravelVistaTests
//
//  Created by Jaouad on 22/03/2026.

//
//  Mock du Service pour les tests.
//  ServiceProtocol est défini dans le target principal (ServiceProtocol.swift)
//

import Foundation
@testable import TravelVista

class MockService: ServiceProtocol {

    static let mockCountries: [Country] = [
        Country(
            name: "Norvège",
            capital: "Oslo",
            description: "Description de la Norvège.",
            rate: 4,
            pictureName: "norvege",
            coordinates: Coordinates(latitude: 59.9139, longitude: 10.7522)
        ),
        Country(
            name: "Italie",
            capital: "Rome",
            description: "Description de l'Italie.",
            rate: 3,
            pictureName: "italie",
            coordinates: Coordinates(latitude: 41.9028, longitude: 12.4964)
        ),
        Country(
            name: "Islande",
            capital: "Reykjavik",
            description: "Description de l'Islande.",
            rate: 5,
            pictureName: "islande",
            coordinates: Coordinates(latitude: 64.1466, longitude: -21.9426)
        )
    ]

    static let mockRegions: [Region] = [
        Region(name: "Europe", countries: mockCountries),
        Region(name: "Asie", countries: [
            Country(
                name: "Vietnam",
                capital: "Hanoi",
                description: "Description du Vietnam.",
                rate: 4,
                pictureName: "vietnam",
                coordinates: Coordinates(latitude: 21.0285, longitude: 105.8542)
            )
        ])
    ]

    func load<T: Decodable>(_ filename: String) -> T {
        guard let result = MockService.mockRegions as? T else {
            fatalError("MockService: impossible de caster en \(T.self)")
        }
        return result
    }
}
