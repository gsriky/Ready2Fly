import Foundation
import SwiftUI

@MainActor
class FlightPlannerViewModel: ObservableObject {
    @Published var departureAirport = ""
    @Published var destinationAirport = ""
    @Published var departureDate = Date()
    @Published var departureTime = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var decision: GoNoGoDecision?

    @AppStorage("pilotProfile") private var pilotProfileData: Data = Data()
    @AppStorage("aircraftProfile") private var aircraftProfileData: Data = Data()

    private let weatherService = WeatherService.shared
    private let goNoGoEngine = GoNoGoEngine()

    var canCheck: Bool {
        departureAirport.count >= 3 && destinationAirport.count >= 3
    }

    var currentFlightPlan: FlightPlan {
        FlightPlan(
            departureAirport: departureAirport,
            destinationAirport: destinationAirport,
            departureDate: departureDate,
            departureTime: departureTime
        )
    }

    func checkFlight() async {
        guard canCheck else { return }

        isLoading = true
        errorMessage = nil

        do {
            let depWx = try await weatherService.fetchWeather(for: departureAirport)
            let destWx = try await weatherService.fetchWeather(for: destinationAirport)

            let pilotProfile = loadPilotProfile()
            let aircraftProfile = loadAircraftProfile()

            let result = goNoGoEngine.evaluate(
                departureWeather: depWx,
                destinationWeather: destWx,
                pilotProfile: pilotProfile,
                aircraftProfile: aircraftProfile,
                flightPlan: currentFlightPlan
            )

            decision = result
        } catch {
            errorMessage = "Unable to fetch weather data. Check airport codes and try again. (\(error.localizedDescription))"
        }

        isLoading = false
    }

    private func loadPilotProfile() -> PilotProfile {
        if let decoded = try? JSONDecoder().decode(PilotProfile.self, from: pilotProfileData) {
            return decoded
        }
        return PilotProfile()
    }

    private func loadAircraftProfile() -> AircraftProfile {
        if let decoded = try? JSONDecoder().decode(AircraftProfile.self, from: aircraftProfileData) {
            return decoded
        }
        return AircraftProfile()
    }
}
