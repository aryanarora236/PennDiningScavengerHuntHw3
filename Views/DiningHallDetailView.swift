import Combine
import CoreLocation
import SwiftUI

struct DiningHallDetailView: View {
    let hallID: UUID

    @EnvironmentObject private var viewModel: DiningHallViewModel
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var shakeManager = ShakeManager()

    @State private var statusMessage = "Shake your phone or tap Collect."
    @State private var statusColor: Color = .secondary

    var body: some View {
        Group {
            if let hall = viewModel.hall(for: hallID) {
                content(for: hall)
            } else {
                ContentUnavailableView("Dining Hall Not Found", systemImage: "mappin.slash")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            shakeManager.startMonitoring()
            locationManager.startUpdatingLocation()
            locationManager.requestCurrentLocation()
        }
        .onDisappear {
            shakeManager.stopMonitoring()
        }
        .onReceive(shakeManager.$shakeCount.dropFirst()) { _ in
            attemptCollection(trigger: "Shake")
        }
    }

    private func content(for hall: DiningHall) -> some View {
        VStack(spacing: 18) {
            Text(hall.name)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            collectionStatusPill(for: hall)

            if let userLocation = locationManager.userLocation,
               let distance = viewModel.distanceToHall(userLocation: userLocation, hallID: hallID) {
                Text("Distance: \(Int(distance.rounded()))m")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else if let errorMessage = locationManager.locationErrorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
            } else {
                Text("Distance unavailable. Requesting location...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text(debugLocationText(for: hall))
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text(statusMessage)
                .foregroundStyle(statusColor)
                .multilineTextAlignment(.center)

            Button("Collect") {
                attemptCollection(trigger: "Button")
            }
            .buttonStyle(.borderedProminent)
            .disabled(hall.isCollected)
        }
        .padding()
    }

    private func debugLocationText(for hall: DiningHall) -> String {
        let target = String(format: "Target: %.5f, %.5f", hall.latitude, hall.longitude)
        if let userLocation = locationManager.userLocation {
            let current = String(
                format: "Current: %.5f, %.5f",
                userLocation.coordinate.latitude,
                userLocation.coordinate.longitude
            )
            return "\(current)\n\(target)"
        }
        return "Current: unavailable\n\(target)"
    }

    private func collectionStatusPill(for hall: DiningHall) -> some View {
        Text(hall.isCollected ? "Collected" : "Not Collected")
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(hall.isCollected ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
            .clipShape(Capsule())
    }

    private func attemptCollection(trigger: String) {
        guard let hall = viewModel.hall(for: hallID) else {
            statusMessage = "This dining hall no longer exists."
            statusColor = .red
            return
        }

        if hall.isCollected {
            statusMessage = "Already collected."
            statusColor = .orange
            return
        }

        guard let userLocation = locationManager.userLocation else {
            statusMessage = "Location unavailable. Move outside and try again."
            statusColor = .red
            locationManager.requestCurrentLocation()
            return
        }

        guard viewModel.isWithinCollectionRange(userLocation: userLocation, hallID: hallID) else {
            let meters = Int((viewModel.distanceToHall(userLocation: userLocation, hallID: hallID) ?? 0).rounded())
            statusMessage = "Too far away (\(meters)m). Get within 50m."
            statusColor = .red
            return
        }

        viewModel.markCollected(hallID: hallID)
        statusMessage = "Collected via \(trigger)."
        statusColor = .green
    }
}
