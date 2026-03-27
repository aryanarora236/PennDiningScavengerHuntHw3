//
//  PennDiningScavengerHuntApp.swift
//  PennDiningScavengerHunt
//
//  Created by Aryan Arora on 3/26/26.
//

import SwiftUI

@main
struct PennDiningScavengerHuntApp: App {
    @StateObject private var diningHallViewModel = DiningHallViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(diningHallViewModel)
                .environmentObject(locationManager)
                .onAppear {
                    locationManager.requestPermission()
                    locationManager.startUpdatingLocation()
                }
        }
    }
}
