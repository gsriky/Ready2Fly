import Foundation

struct GoNoGoDecision {
    let recommendation: Recommendation
    let factors: [DecisionFactor]
    let summary: String
    let departureWeather: AirportWeather?
    let destinationWeather: AirportWeather?

    enum Recommendation: String {
        case go = "GO"
        case marginal = "MARGINAL"
        case noGo = "NO-GO"

        var emoji: String {
            switch self {
            case .go: return "checkmark.circle.fill"
            case .marginal: return "exclamationmark.triangle.fill"
            case .noGo: return "xmark.circle.fill"
            }
        }

        var colorName: String {
            switch self {
            case .go: return "goGreen"
            case .marginal: return "marginalYellow"
            case .noGo: return "noGoRed"
            }
        }
    }
}

struct DecisionFactor: Identifiable {
    let id = UUID()
    let category: FactorCategory
    let title: String
    let detail: String
    let status: FactorStatus

    enum FactorCategory: String {
        case departureWeather = "Departure Weather"
        case destinationWeather = "Destination Weather"
        case enRouteWeather = "En Route Weather"
        case wind = "Wind"
        case visibility = "Visibility"
        case ceiling = "Ceiling"
        case aircraft = "Aircraft"
        case pilot = "Pilot"
        case notams = "NOTAMs"
        case custom = "Custom Check"
    }

    enum FactorStatus: String {
        case pass = "Pass"
        case caution = "Caution"
        case fail = "Fail"

        var iconName: String {
            switch self {
            case .pass: return "checkmark.circle.fill"
            case .caution: return "exclamationmark.triangle.fill"
            case .fail: return "xmark.circle.fill"
            }
        }

        var colorName: String {
            switch self {
            case .pass: return "goGreen"
            case .caution: return "marginalYellow"
            case .fail: return "noGoRed"
            }
        }
    }
}
