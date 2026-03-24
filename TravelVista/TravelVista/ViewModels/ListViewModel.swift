//
//  ListViewModel.swift
//  TravelVista
//
//  Created by Jaouad on 22/03/2026.
//
// ViewModel qui charge les vraies données depuis Service

import Foundation

class ListViewModel: ObservableObject {
    // Tableau de region
    @Published var regions: [Region] = []

    // Injection de dépendance via ServiceProtocol
    init(service : ServiceProtocol = Service()) {
        // Même appel que dans l'ancien ListViewController
        self.regions = service.load("Source.json")
    }
}
