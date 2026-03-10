//
//  	
//  TravelVista
//
//  Created by Jaouad on 10/03/2026.
//

import SwiftUI

struct TitleViewSwiftUI: View {
    let countryName: String
    let capitalName: String
    let rate: Int

    var body: some View {
        HStack(alignment: .center) {
            // Partie gauche : nom du pays + capitale
            VStack(alignment: .leading, spacing: 2) {
                Text(countryName)
                    .font(.system(size: 22))
                    .foregroundColor(Color("CustomBlue"))
                Text(capitalName)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(white: 0.45))          
            }
            .padding(.leading, 16)

            Spacer()

            // Partie droite : chiffre + 1 étoile (identique à CellView)
            HStack(spacing: 6) {
                Text("\(rate)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.primary)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color("CustomSand"))
            }
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, minHeight: 65)
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Preview
#Preview {
    TitleViewSwiftUI(countryName: "Norvège", capitalName: "Oslo", rate: 4)
}
