import Foundation

struct PilotProfile: Codable {
    var name: String = ""
    var certificateLevel: CertificateLevel = .privatePilot
    var hasInstrumentRating: Bool = false

    // Personal minimums
    var minVisibility: Double = 5.0 // statute miles
    var minCeiling: Int = 3000 // feet AGL
    var maxCrosswind: Int = 15 // knots
    var maxHeadwind: Int = 25 // knots
    var maxTailwind: Int = 10 // knots
    var minRunwayLength: Int = 3000 // feet
    var maxTurbulence: TurbulenceLevel = .light

    // Night minimums (typically higher)
    var minVisibilityNight: Double = 8.0
    var minCeilingNight: Int = 5000

    // Custom checks
    var customChecks: [CustomCheck] = []

    enum CertificateLevel: String, Codable, CaseIterable, Identifiable {
        case studentPilot = "Student Pilot"
        case privatePilot = "Private Pilot"
        case commercialPilot = "Commercial Pilot"
        case airlineTransport = "ATP"

        var id: String { rawValue }
    }
}

struct CustomCheck: Codable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var isEnabled: Bool = true
}

enum TurbulenceLevel: String, Codable, CaseIterable, Identifiable {
    case none = "None"
    case light = "Light"
    case moderate = "Moderate"
    case severe = "Severe"

    var id: String { rawValue }

    var numericValue: Int {
        switch self {
        case .none: return 0
        case .light: return 1
        case .moderate: return 2
        case .severe: return 3
        }
    }
}
