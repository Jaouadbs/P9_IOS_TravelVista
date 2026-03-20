//
//  AppDelegate.swift
//  TravelVista
//
//  Created by Amandine Cousin on 13/12/2023.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Remplacement de ListViewController par ListView (SwiftUI)
        guard let windowScene = application.connectedScenes
            .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive})
                as? UIWindowScene else {
            return true
        }
        window = UIWindow(windowScene: windowScene)
        window? .rootViewController = UIHostingController(rootView: ListView())
        window?.makeKeyAndVisible()
        return true
    }
}

