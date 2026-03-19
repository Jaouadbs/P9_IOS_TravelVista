//
//  DetailViewController.swift
//  TravelVista
//
//  Created by Amandine Cousin on 18/12/2023.
//

import UIKit
import MapKit
import SwiftUI

class DetailViewController: UIViewController, MKMapViewDelegate {

    // MARK: - IBOutlets

    // Conservés pour la connexion storyboard — remplacés visuellement par TitleViewSwiftUI
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalNameLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var rateView: UIView!

    // Tjrs actifs et utilisés
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var embedMapView: UIView!


    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomDesign()

        if let country = self.country {
            self.setUpData(country: country)
        }
    }

    // MARK: - Setup
    
    private func setUpData(country: Country) {
        self.title = country.name

        //Tjrs gérés en UIKIT
        self.imageView.image = UIImage(named: country.pictureName )
        self.descriptionTextView.text = country.description

        // A supprimer. Remplacé par TitleViewSwiftUI
        //self.countryNameLabel.text = country.name
        //self.capitalNameLabel.text = country.capital
        //self.setRateStars(rate: country.rate)

        // Remplacement de titleView par TitleViewSwiftUI
        self.embedTitleView(country: country)

        self.setMapLocation(
            lat: country.coordinates.latitude,
            long: country.coordinates.longitude
        )
    }

    // MARK: - Intégration SwiftUI

    /// Remplace l'ancienne titleView UIKit par TitleViewSwiftUI via UIHostingController.
    /// AddChild -> addSubview -> Contraintes -> didMove(toParent)
    private func embedTitleView(country: Country) {
        // Ajout de la Vue avec les données de pays
        let swiftUIView = TitleViewSwiftUI(
            countryName: country.name,
            capitalName: country.capital,
            rate: country.rate
        )
        // Créer le UIHostingController qui encapsule la vue SwiftUI
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Intégrer le hosting
        self.addChild(hostingController)

        guard let hostedView = hostingController.view else { return }

        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.backgroundColor = .systemBackground

        // Ajout la vue SwiftUI au dessus de l'ancienne titleView
        //si titleView a un superview (app normale) : on s'insère au-dessus d'elle
        //sinon (tests unitaires) : on s'ajoute directement à self.view
        let targetSuperView = titleView.superview ?? self.view!
        targetSuperView.insertSubview(hostedView,aboveSubview: titleView )

        //Cacher l'ancienne titleview UIKit
        // la connexion est tjrs présente avec storyboard
        titleView.isHidden = true

        // Contraintes: Lavouvelle vue occupe exactement la meme position
        // taille que  l'ancienne titleView
        NSLayoutConstraint.activate([
            hostedView.topAnchor.constraint(equalTo: targetSuperView.topAnchor),
            hostedView.leadingAnchor.constraint(equalTo: targetSuperView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: targetSuperView.trailingAnchor),
            hostedView.heightAnchor.constraint(equalToConstant: 65)

        ])
        // Intégration du child view controller
        hostingController.didMove(toParent: self)
    }

    // MARK: - Design

    private func setCustomDesign() {
        self.mapView.layer.cornerRadius = self.mapView.frame.size.width / 2
        self.embedMapView.layer.cornerRadius = self.embedMapView.frame.size.width / 2
        self.mapButton.layer.cornerRadius = self.mapButton.frame.size.width / 2
        
        self.mapView.layer.borderColor = UIColor(named: "CustomSand")?.cgColor
        self.mapView.layer.borderWidth = 2
    }

    // Méthode setRateStars à - SUPPRIMER
    // Les étoiles sont gérées par TitleViewSwiftUI
    
    /*private func setRateStars(rate: Int) {
        var lastRightAnchor = self.rateView.rightAnchor
        for _ in 0..<rate {
            let starView = UIImageView(image: UIImage(systemName: "star.fill"))
            self.rateView.addSubview(starView)

            starView.translatesAutoresizingMaskIntoConstraints = false
            starView.widthAnchor.constraint(equalToConstant: 19).isActive = true
            starView.heightAnchor.constraint(equalToConstant: 19).isActive = true
            starView.centerYAnchor.constraint(equalTo: self.rateView.centerYAnchor).isActive = true
            starView.rightAnchor.constraint(equalTo: lastRightAnchor).isActive = true
            lastRightAnchor = starView.leftAnchor
        }
    }*/

    private func setMapLocation(lat: Double, long: Double) {
        let initialLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: initialLocation, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.delegate = self
    }
    

    
    // Cette fonction est appelée lorsque la carte est cliquée
    // Elle permet d'afficher un nouvel écran qui contient une carte
    @IBAction func showMap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        nextViewController.setUpData(
            capitalName: self.country?.capital,
            lat: self.country?.coordinates.latitude ?? 28.394857,
            long: self.country?.coordinates.longitude ?? 84.124008
        )
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
