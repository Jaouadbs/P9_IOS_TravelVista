//
//  DetailView.swift
//  TravelVista
//
//  Created by Jaouad on 20/03/2026.

//  Ticket 4 — Pont SwiftUI → UIKit pour DetailViewController
//  Implémente UIViewControllerRepresentable pour permettre à SwiftUI
//  d'afficher un UIViewController existant.
//

import SwiftUI

struct DetailView: UIViewControllerRepresentable {

    // Le pays à afficher — sera passé depuis ListView au Ticket 5
    // Pour l'instant on crée un pays fictif pour tester la navigation
    let country: Country

    // MARK: - Fonction 1 (obligatoire)
    // Crée et retourne une instance de DetailViewController depuis le storyboard
    func makeUIViewController(context: Context) -> DetailViewController {

        // Instanciation depuis le storyboard via son Storyboard ID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "DetailViewController"
        )

        // Cast vers DetailViewController
        // guard + fatalError pour gérer l'échec de conversion
        guard let detailVC = viewController as? DetailViewController else {
            fatalError("Impossible de caster en DetailViewController — vérifie le Storyboard ID")
        }

        // Passage du pays au controller UIKit
        detailVC.country = country

        return detailVC
    }

    // MARK: - Fonction 2 (obligatoire par le protocole)
    // Vue statique : rien à mettre à jour après le chargement initial
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        // Laissé vide intentionnellement — la vue se charge une seule fois
    }
}
