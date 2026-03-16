import Foundation

struct AircraftProfile: Codable, Equatable {
    var tailNumber: String = ""
    var makeModel: String = "Cirrus SR20"
    var aircraftCategory: AircraftCategory = .singleEngineLand

    // Performance
    var cruiseSpeedKnots: Int = 140
    var maxAltitude: Int = 17500 // service ceiling in feet
    var usableAltitude: Int = 12500 // practical limit (e.g., no oxygen)
    var hasOxygen: Bool = false
    var fuelEnduranceHours: Double = 4.5
    var rangeNM: Int = 600

    // Equipment
    var hasAutopilot: Bool = true
    var hasDeIcing: Bool = false
    var isIFRCertified: Bool = true
    var hasGPS: Bool = true
    var hasADSB: Bool = true

    // Limitations
    var maxCrosswindComponent: Int = 20 // knots, per POH
    var maxDemonstratedCrosswind: Int = 15 // knots
    var minRunwayLength: Int = 2500 // feet

    enum AircraftCategory: String, Codable, CaseIterable, Identifiable {
        case singleEngineLand = "Single-Engine Land"
        case multiEngineLand = "Multi-Engine Land"
        case singleEngineSea = "Single-Engine Sea"

        var id: String { rawValue }
    }
}
