import Foundation

struct FlightPlan {
    var departureAirport: String = "" // ICAO code
    var destinationAirport: String = "" // ICAO code
    var departureDate: Date = Date()
    var departureTime: Date = Date()

    var departureDateTime: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: departureDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: departureTime)
        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute
        return calendar.date(from: combined) ?? Date()
    }

    func estimatedArrivalTime(cruiseSpeedKnots: Int, distanceNM: Int) -> Date {
        let flightTimeHours = Double(distanceNM) / Double(cruiseSpeedKnots)
        return departureDateTime.addingTimeInterval(flightTimeHours * 3600)
    }
}

struct RouteInfo {
    let preferredRoutes: [String]
    let distanceNM: Int
    let estimatedTimeEnRoute: TimeInterval // seconds
    let minimumEnRouteAltitude: Int // feet
    let suggestedAltitude: Int // feet
}
