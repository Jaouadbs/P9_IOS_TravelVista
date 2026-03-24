//
//  ListView.swift
//  TravelVista
//
//  Created by Jaouad on 10/03/2026.
// Remplace ListViewController et CustomCell

import SwiftUI

// MARK: - Vue des cellules(remplace CustomCell)
struct CellView: View {
    // Reçoit un vrai Country au lieu de données statiques
    let country: Country
    var body: some View {
        HStack(spacing: 12) {

            // Image ronde du pays
            Image(country.pictureName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            // Nom du pays + capitale
            VStack(alignment: .leading, spacing: 2) {
                Text(country.name)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color("CustomBlue"))
                Text(country.capital)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()

            // Note + étoile
            HStack(spacing: 12) {
                Text("\(country.rate)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.primary)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(Color("CustomSand"))
            }
        }
        .frame(height: 65)
        .padding(.horizontal,4)
    }
}

// MARK: - ListView(Remplace ListViewController)
struct ListView: View {

    // ViewModel fournit les données
    @StateObject private var viewModel = ListViewModel()

    var body: some View {
        // NavigationView pour gérer la navigation
        NavigationView {
            List {
                // Parcours les regions et pays
                ForEach(viewModel.regions, id: \.name) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.countries, id:\.name) { country in

                            // On passe le pays à DetailView
                            NavigationLink(destination: DetailView(country: country)) {
                                CellView(country: country)
                            }
                        }
                    }
                }
            }
                .listStyle(.plain)
                .navigationTitle("Liste de voyages")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

#Preview("CellView") {
    CellView(country: Country(
        name: "Novège",
        capital: "Oslo",
        description: "Beau Pays",
        rate: 4, pictureName: "Novege",
        coordinates: Coordinates(latitude: 59.9139, longitude: 10.7522)
    ))
    .previewLayout(.sizeThatFits)

}

#Preview ("ListView") {
    ListView()
}
