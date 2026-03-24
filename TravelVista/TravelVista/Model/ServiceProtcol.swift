//
//  ServiceProtcol.swift
//  TravelVista
//
//  Created by Jaouad on 22/03/2026.

//  Protocole que Service implémente, permettant l'injection
//  de dépendance dans ListViewModel.


import Foundation

protocol ServiceProtocol {
    func load<T: Decodable>(_ filename: String) -> T
}

// Extension pour que Service respecte le protocole
// sans modifier le fichier Service.swift original
extension Service: ServiceProtocol {}
