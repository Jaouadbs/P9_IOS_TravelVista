//
//  DetailViewControllerTests.swift
//  TravelVistaTests
//
//  Created by Jaouad on 23/03/2026.

//  Tests d'intégration de DetailViewController
//  Vérifie l'intégration entre UIKit et SwiftUI (TitleViewSwiftUI)
//

import XCTest
import SwiftUI
@testable import TravelVista

final class DetailViewControllerTests: XCTestCase {

    // MARK: - Propriétés

    var sut: DetailViewController!

    // La window DOIT être une propriété de la classe.
    // Si elle est locale, elle est détruite après makeDetailVC
    // → hiérarchie de vues effondrée → tests échouent.
    var window: UIWindow?

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = makeDetailVC(country: MockService.mockCountries[0])
    }

    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }

    // MARK: - Helper : instancie DetailViewController depuis le storyboard

    private func makeDetailVC(country: Country) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "DetailViewController"
        ) as? DetailViewController else {
            fatalError("Vérifiez que le Storyboard ID est bien 'DetailViewController'")
        }

        // Injection du pays mock
        vc.country = country

        // Attache à une UIWindow pour construire la hiérarchie de vues

        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }) {

            let w = UIWindow(windowScene: windowScene)
            // Utilise le contexte de l'écran de la scene pour le frame
            w.frame = windowScene.screen.bounds
            w.rootViewController = vc
            w.makeKeyAndVisible()
            self.window = w
        } else {
            // Fallback pour environnements de test sans scene active
            // On tente d'obtenir un UIScreen depuis le contexte de la vue
            _ = vc.view // Assure le chargement de la vue

            if let screen = vc.view.window?.windowScene?.screen {
                let w = UIWindow(windowScene: vc.view.window!.windowScene!)
                w.frame = screen.bounds
                w.rootViewController = vc
                w.makeKeyAndVisible()
                self.window = w
            } else if let screen = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.screen {
                let w = UIWindow(windowScene: UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first!)
                w.frame = screen.bounds
                w.rootViewController = vc
                w.makeKeyAndVisible()
                self.window = w
            } else {
                // Dernier recours: tente d'utiliser une UIWindowScene disponible, puis crée la fenêtre via init(windowScene:)

                if let anyScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first {
                    let w = UIWindow(windowScene: anyScene)
                    w.frame = anyScene.screen.bounds
                    w.rootViewController = vc
                    w.makeKeyAndVisible()
                    self.window = w
                } else {
                    // Environnements de tests extrêmement contraints: pas de scene disponible.
                    // Sur iOS 26 et plus, l'init(frame:) est dépréciée. Nous évitons de l'appeler et nous attachons
                    // la vue directement pour permettre aux assertions d'inspecter la hiérarchie minimale.
                    if #available(iOS 26.0, *) {
                        // Pas de UIWindowScene disponible: ne créez pas de fenêtre dépréciée.
                        // Force le chargement de la vue et retourne sans créer de UIWindow.
                        _ = vc.view
                        self.window = nil
                    } else {
                        // Sur versions antérieures, utilisez une fenêtre en dernier recours.
                        let w = UIWindow(frame: UIScreen.main.bounds)
                        w.rootViewController = vc
                        w.makeKeyAndVisible()
                        self.window = w
                    }
                }
            }
        }

        // Déclenche viewDidLoad + layout
        _ = vc.view
        vc.viewWillAppear(false)

        return vc
    }

    // MARK: - Tests : Instanciation

    func test_instantiation_fromStoryboard() {
        // Assert
        XCTAssertNotNil(sut,
                        "DetailViewController doit s'instancier depuis le storyboard")
    }

    func test_instantiation_countryIsSet() {
        // Assert
        XCTAssertNotNil(sut.country,
                        "Le pays doit être injecté dans le controller")
        XCTAssertEqual(sut.country?.name, "Norvège")
    }

    // MARK: - Tests : Données affichées

    func test_title_matchesCountryName() {
        // Assert
        XCTAssertEqual(sut.title, "Norvège",
                       "Le titre de navigation doit correspondre au nom du pays")
    }

    func test_imageView_isNotNil() {
        // Assert
        XCTAssertNotNil(sut.imageView.image,
                        "L'imageView doit afficher une image")
    }

    func test_descriptionTextView_isNotEmpty() {
        // Assert
        XCTAssertFalse(sut.descriptionTextView.text.isEmpty,
                       "La description ne doit pas être vide")
    }

    func test_descriptionTextView_matchesCountryDescription() {
        // Arrange
        let expectedDescription = MockService.mockCountries[0].description

        // Assert
        XCTAssertEqual(sut.descriptionTextView.text, expectedDescription)
    }

    // MARK: - Tests : Intégration SwiftUI (TitleViewSwiftUI)

    func test_swiftUI_hostingControllerIsAdded() {
        // Assert — vérifie que didMove(toParent:) a bien été appelé
        let hasHostingChild = sut.children.contains {
            $0 is UIHostingController<TitleViewSwiftUI>
        }
        XCTAssertTrue(hasHostingChild,
                      "Un UIHostingController<TitleViewSwiftUI> doit être enfant du VC")
    }

    func test_swiftUI_titleViewIsHidden() {
        // Assert — l'ancienne titleView UIKit doit être cachée
        XCTAssertTrue(sut.titleView.isHidden,
                      "L'ancienne titleView UIKit doit être isHidden = true")
    }

    func test_swiftUI_hostingViewIsInHierarchy() {
        // Arrange
        let hostingVC = sut.children.first {
            $0 is UIHostingController<TitleViewSwiftUI>
        }

        // Assert — la vue SwiftUI doit être attachée à la hiérarchie
        XCTAssertNotNil(hostingVC?.view.superview,
                        "La vue SwiftUI doit avoir un superview")
    }

    // MARK: - Tests : Différents pays

    func test_withItaly_titleIsRome() {
        // Arrange
        let italy = MockService.mockCountries[1]
        let vc = makeDetailVC(country: italy)

        // Assert
        XCTAssertEqual(vc.title, "Italie")
        XCTAssertEqual(vc.country?.capital, "Rome")
        XCTAssertEqual(vc.country?.rate, 3)
    }

    func test_withIceland_rateIsFive() {
        // Arrange
        let iceland = MockService.mockCountries[2]
        let vc = makeDetailVC(country: iceland)

        // Assert
        XCTAssertEqual(vc.country?.rate, 5)
        XCTAssertEqual(vc.country?.capital, "Reykjavik")
    }
}

