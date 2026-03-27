import Combine
import CoreLocation
import Foundation

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published private(set) var userLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var locationErrorMessage: String?

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5

        // Handle the case where the user already granted permission in a prior run.
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            locationErrorMessage = "Location services are disabled."
            return
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationErrorMessage = nil
            manager.startUpdatingLocation()
        case .notDetermined:
            requestPermission()
        case .denied, .restricted:
            locationErrorMessage = "Location permission denied. Enable it in Settings."
        @unknown default:
            locationErrorMessage = "Unknown location authorization state."
        }
    }

    func requestCurrentLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            locationErrorMessage = "Location services are disabled."
            return
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            requestPermission()
        case .denied, .restricted:
            locationErrorMessage = "Location permission denied. Enable it in Settings."
        @unknown default:
            locationErrorMessage = "Unknown location authorization state."
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationErrorMessage = nil
            startUpdatingLocation()
        case .denied, .restricted:
            locationErrorMessage = "Location permission denied. Enable it in Settings."
        case .notDetermined:
            break
        @unknown default:
            locationErrorMessage = "Unknown location authorization state."
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        Task { @MainActor in
            self.userLocation = location
            self.locationErrorMessage = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationErrorMessage = error.localizedDescription
        }
    }
}
