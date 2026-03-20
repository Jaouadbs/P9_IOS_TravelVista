//
//  ListView.swift
//  TravelVista
//
//  Created by Jaouad on 10/03/2026.
// Remplace ListViewController et CustomCell

import SwiftUI

// MARK: - Vue des cellules(remplace CustomCell)
struct CellView: View {
    var body: some View {
        HStack(spacing: 12) {

            // Image ronde
            Image("norvege")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            // Nom du pays + capitale
            VStack(alignment: .leading, spacing: 2) {
                Text("Toto")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color("CustomBlue"))
                Text("Lorem Ipsum")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            Spacer()

            // Note + étoile
            HStack(spacing: 12) {
                Text("4")
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
    var body: some View {
        // Navigation à ajouter après
        List{
            // Sections
            Section(header: Text("Europe")) {
                CellView()
                CellView()
                CellView()
                CellView()
            }
            Section(header: Text("Asie")) {
                CellView()
            }
            Section(header: Text("Afrique")) {
                CellView()
                CellView()
            }
            Section(header: Text("Ameriques")) {
                CellView()
                CellView()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Liste de voyages")
    }
}

#Preview("CellView", traits: .sizeThatFitsLayout) {
    CellView()
}

#Preview ("ListView") {
    ListView()
}
