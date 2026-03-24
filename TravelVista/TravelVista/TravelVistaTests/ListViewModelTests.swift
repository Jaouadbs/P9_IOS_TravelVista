//
//  ListViewModelTests.swift
//  TravelVistaTests
//
//  Created by Jaouad on 23/03/2026.

//  Pattern AAA utilisé : Arrange / Act / Assert
//  - Arrange : préparer les données et le ViewModel
//  - Act     : appeler la méthode ou accéder à la propriété testée
//  - Assert  : vérifier le résultat attendu
//

import XCTest
@testable import TravelVista

final class ListViewModelTests: XCTestCase {

    // MARK: - Propriétés

    var sut: ListViewModel!
    var mockService: MockService!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        mockService = MockService()
        // On injecte le MockService dans le ViewModel
        sut = ListViewModel(service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Tests : Chargement des données

    func test_init_loadsRegions() {
        // Assert
        XCTAssertFalse(sut.regions.isEmpty,
                       "Le ViewModel doit charger des régions à l'initialisation")
    }

    func test_init_loadsCorrectNumberOfRegions() {
        // Assert
        XCTAssertEqual(sut.regions.count, MockService.mockRegions.count,
                       "Le nombre de régions doit correspondre aux données mock")
    }

    func test_init_firstRegionIsEurope() {
        // Assert
        XCTAssertEqual(sut.regions.first?.name, "Europe",
                       "La première région doit être Europe")
    }

    func test_init_secondRegionIsAsie() {
        // Assert
        XCTAssertEqual(sut.regions[1].name, "Asie",
                       "La deuxième région doit être Asie")
    }

    // MARK: - Tests : Contenu des pays

    func test_europe_hasThreeCountries() {
        // Arrange
        let europe = sut.regions.first { $0.name == "Europe" }

        // Assert
        XCTAssertNotNil(europe, "La région Europe doit exister")
        XCTAssertEqual(europe?.countries.count, 3,
                       "L'Europe doit contenir 3 pays dans les données mock")
    }

    func test_firstCountry_isNorway() {
        // Arrange
        let firstCountry = sut.regions.first?.countries.first

        // Assert
        XCTAssertEqual(firstCountry?.name, "Norvège")
        XCTAssertEqual(firstCountry?.capital, "Oslo")
        XCTAssertEqual(firstCountry?.rate, 4)
    }

    func test_country_rateIsWithinValidRange() {
        // Arrange & Act
        for region in sut.regions {
            for country in region.countries {
                // Assert
                XCTAssertGreaterThanOrEqual(country.rate, 1,
                    "\(country.name) : la note doit être >= 1")
                XCTAssertLessThanOrEqual(country.rate, 5,
                    "\(country.name) : la note doit être <= 5")
            }
        }
    }

    func test_country_coordinatesAreValid() {
        // Arrange & Act
        for region in sut.regions {
            for country in region.countries {
                // Assert
                XCTAssertGreaterThanOrEqual(country.coordinates.latitude, -90,
                    "\(country.name) : latitude invalide")
                XCTAssertLessThanOrEqual(country.coordinates.latitude, 90,
                    "\(country.name) : latitude invalide")
                XCTAssertGreaterThanOrEqual(country.coordinates.longitude, -180,
                    "\(country.name) : longitude invalide")
                XCTAssertLessThanOrEqual(country.coordinates.longitude, 180,
                    "\(country.name) : longitude invalide")
            }
        }
    }

    func test_country_pictureNameIsNotEmpty() {
        // Arrange & Act
        for region in sut.regions {
            for country in region.countries {
                // Assert
                XCTAssertFalse(country.pictureName.isEmpty,
                    "\(country.name) : pictureName ne doit pas être vide")
            }
        }
    }

    // MARK: - Tests : Modèle Country

    func test_country_equality() {
        // Arrange
        let country1 = MockService.mockCountries[0]
        let country2 = MockService.mockCountries[0]

        // Assert
        XCTAssertEqual(country1.name, country2.name)
        XCTAssertEqual(country1.capital, country2.capital)
        XCTAssertEqual(country1.rate, country2.rate)
    }

    func test_region_name_isNotEmpty() {
        // Arrange & Act
        for region in sut.regions {
            // Assert
            XCTAssertFalse(region.name.isEmpty,
                           "Le nom de la région ne doit pas être vide")
        }
    }
}
