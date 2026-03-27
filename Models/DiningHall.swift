import CoreLocation
import Foundation

struct DiningHall: Identifiable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    var isCollected: Bool

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        isCollected: Bool = false
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isCollected = isCollected
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
