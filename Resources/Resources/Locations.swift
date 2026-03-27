import CoreLocation

/// This file contains hardcoded coordinates for each dining hall,
/// to help you get a head start.
///
/// To use each of these coordinates, you can access the corresponding
/// property on `CLLocationCoordinate2D` like so:
/// ```swift
/// let coords = CLLocationCoordinate2D.commons
/// ```
/// Or, if the Swift compiler can infer the type:
/// ```swift
/// let coords: CLLocationCoordinate2D = .commons
/// ```
///
/// We don't recommend you use this directly in your app's logic - instead,
/// embed them into whatever larger data structure you use to keep track
/// of dining halls as a whole, so you can store them alongside details such
/// as name and current state.
///
/// You can copy and paste this as a file in your project. As always, let
/// us know if you have questions or need help!
public extension CLLocationCoordinate2D {
    /// 1920 Commons
    static let commons = Self(latitude: 39.95248, longitude: -75.19938)
    
    /// Accenture Café
    static let accenture = Self(latitude: 39.95202, longitude: -75.19135)
    
    /// Falk at Penn Hillel
    static let falk = Self(latitude: 39.95314, longitude: -75.20015)
    
    /// Hill House
    static let hill = Self(latitude: 39.95300, longitude: -75.19071)
    
    /// Houston Market
    static let houston = Self(latitude: 39.95091, longitude: -75.19388)
    
    /// Joe's Café
    static let joes = Self(latitude: 39.95156, longitude: -75.19652)
    
    /// Kings Court English House
    static let kceh = Self(latitude: 39.95416, longitude: -75.19418)
    
    /// Lauder House
    static let lauder = Self(latitude: 39.95382, longitude: -75.19108)
    
    /// McClelland (now Penn Dining Sushi Spot)
    static let mcclelland = Self(latitude: 39.95107, longitude: -75.19839)
    
    /// Pret a Manger (Locust Walk)
    static let pret = Self(latitude: 39.95263, longitude: -75.19848)
    
    /// Quaker Kitchen
    static let quaker = Self(latitude: 39.95354, longitude: -75.20198)
}
