//
//  TravelVistaIntegrationTests.swift
//  TravelVista
//
//  Created by Jaouad on 10/03/2026.
//

//  Tests d'intégration : interaction entre vues SwiftUI et composants UIKit existants


import XCTest
import SwiftUI
@testable import TravelVista

final class TravelVistaIntegrationTests: XCTestCase {

    private var window: UIWindow?

    // MARK: - Helpers

    private func makeCountry() -> Country {
        Country(
            name: "Norvège",
            capital: "Oslo",
            description: "Description de la Norvège.",
            rate: 4,
            pictureName: "norvege",
            coordinates: Coordinates(latitude: 59.9139, longitude: 10.7522)
        )
    }

    private func makeDetailVC(country: Country) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as! DetailViewController
        vc.country = country

        // On stocke la window dans self.window (propriété de la classe)
        // pour qu'elle reste en mémoire pendant toute la durée du test.
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = vc
        w.makeKeyAndVisible()
        self.window = w

        // Déclenche viewDidLoad + viewWillAppear + layout complet
        _ = vc.view
        vc.viewWillAppear(false)

        return vc
    }

    override func tearDown() {
        // Nettoyage après chaque test
        window = nil
        super.tearDown()
    }

    // MARK: - DetailViewController : chargement depuis le storyboard

    func test_detailVC_instantiatesFromStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        XCTAssertNotNil(vc, "DetailViewController doit pouvoir être instancié depuis le storyboard")
        XCTAssertTrue(vc is DetailViewController)
    }

    func test_detailVC_setsCountry() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)
        XCTAssertNotNil(vc.country)
        XCTAssertEqual(vc.country?.name, "Norvège")
    }

    func test_detailVC_titleMatchesCountryName() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)
        XCTAssertEqual(vc.title, "Norvège")
    }

    func test_detailVC_imageViewLoadsImage() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)
        XCTAssertNotNil(vc.imageView.image,
                        "L'imageView doit afficher une image après chargement du pays")
    }

    func test_detailVC_descriptionTextViewIsSet() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)
        XCTAssertFalse(vc.descriptionTextView.text.isEmpty,
                       "La description ne doit pas être vide")
        XCTAssertEqual(vc.descriptionTextView.text, country.description)
    }

    // MARK: - TitleViewSwiftUI intégrée dans DetailViewController

    func test_detailVC_embedsTitleViewSwiftUI() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)

        // On vérifie qu'un UIHostingController a été ajouté comme enfant
        // Cela ne fonctionne que si didMove(toParent: self) a bien été appelé
        let hasHostingChild = vc.children.contains {
            $0 is UIHostingController<TitleViewSwiftUI>
        }
        XCTAssertTrue(hasHostingChild,
                      "DetailViewController doit contenir un UIHostingController<TitleViewSwiftUI>")
    }

    func test_detailVC_titleViewIsHiddenAfterSwiftUIEmbed() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)
        XCTAssertTrue(vc.titleView.isHidden,
                      "L'ancienne titleView UIKit doit être cachée après l'embed SwiftUI")
    }

    func test_detailVC_swiftUIHostingViewIsInHierarchy() {
        let country = makeCountry()
        let vc = makeDetailVC(country: country)

        // La vue du UIHostingController doit être dans la hiérarchie
        let hostingVC = vc.children.first {
            $0 is UIHostingController<TitleViewSwiftUI>
        }
        XCTAssertNotNil(hostingVC?.view.superview,
                        "La vue SwiftUI doit être attachée à la hiérarchie de vues")
    }
}
