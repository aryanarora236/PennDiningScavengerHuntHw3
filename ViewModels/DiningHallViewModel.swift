import Combine
import CoreLocation
import Foundation

@MainActor
final class DiningHallViewModel: ObservableObject {
    @Published private(set) var diningHalls: [DiningHall] = DiningHallData.all

    func hall(for hallID: UUID) -> DiningHall? {
        diningHalls.first(where: { $0.id == hallID })
    }

    func markCollected(hallID: UUID) {
        guard let index = diningHalls.firstIndex(where: { $0.id == hallID }) else {
            return
        }
        diningHalls[index].isCollected = true
    }

    func distanceToHall(userLocation: CLLocation, hallID: UUID) -> CLLocationDistance? {
        guard let hall = hall(for: hallID) else {
            return nil
        }
        return userLocation.distance(from: hall.location)
    }

    func isWithinCollectionRange(userLocation: CLLocation, hallID: UUID) -> Bool {
        guard let distance = distanceToHall(userLocation: userLocation, hallID: hallID) else {
            return false
        }
        return distance <= 50
    }
}
