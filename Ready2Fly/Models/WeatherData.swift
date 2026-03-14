import Foundation

// MARK: - METAR

struct MetarResponse: Codable {
    let icaoId: String?
    let reportTime: String?
    let temp: Double?
    let dewp: Double?
    let wdir: String?
    let wspd: Int?
    let wgst: Int?
    let visib: String?
    let altim: Double?
    let fltcat: String? // VFR, MVFR, IFR, LIFR
    let rawOb: String?
    let clouds: [CloudLayer]?

    struct CloudLayer: Codable {
        let cover: String? // FEW, SCT, BKN, OVC
        let base: Int? // AGL in feet
    }
}

// MARK: - TAF

struct TafResponse: Codable {
    let icaoId: String?
    let rawTAF: String?
    let validTimeFrom: Int?
    let validTimeTo: Int?
}

// MARK: - Parsed Weather

struct AirportWeather {
    let airportId: String
    let metar: MetarResponse?
    let taf: TafResponse?

    var flightCategory: FlightCategory {
        guard let cat = metar?.fltcat else { return .unknown }
        return FlightCategory(rawValue: cat) ?? .unknown
    }

    var visibility: Double {
        guard let vis = metar?.visib else { return 0 }
        if vis == "10+" { return 10.0 }
        return Double(vis) ?? 0
    }

    var ceiling: Int? {
        guard let clouds = metar?.clouds else { return nil }
        for layer in clouds {
            if let cover = layer.cover, let base = layer.base,
               cover == "BKN" || cover == "OVC" {
                return base
            }
        }
        return nil
    }

    var windSpeed: Int {
        metar?.wspd ?? 0
    }

    var windGust: Int? {
        metar?.wgst
    }

    var windDirection: Int {
        guard let dir = metar?.wdir else { return 0 }
        return Int(dir) ?? 0
    }

    var temperature: Double {
        metar?.temp ?? 0
    }

    var dewpoint: Double {
        metar?.dewp ?? 0
    }

    var rawMetar: String {
        metar?.rawOb ?? "Not available"
    }

    var rawTaf: String {
        taf?.rawTAF ?? "Not available"
    }

    var skyConditionDescription: String {
        guard let clouds = metar?.clouds, !clouds.isEmpty else { return "Clear" }
        return clouds.compactMap { layer in
            guard let cover = layer.cover, let base = layer.base else { return nil }
            let coverName: String
            switch cover {
            case "FEW": coverName = "Few"
            case "SCT": coverName = "Scattered"
            case "BKN": coverName = "Broken"
            case "OVC": coverName = "Overcast"
            case "CLR", "SKC": coverName = "Clear"
            default: coverName = cover
            }
            return "\(coverName) at \(base) ft"
        }.joined(separator: ", ")
    }
}

enum FlightCategory: String {
    case vfr = "VFR"
    case mvfr = "MVFR"
    case ifr = "IFR"
    case lifr = "LIFR"
    case unknown = "Unknown"

    var color: String {
        switch self {
        case .vfr: return "green"
        case .mvfr: return "blue"
        case .ifr: return "red"
        case .lifr: return "purple"
        case .unknown: return "gray"
        }
    }
}
