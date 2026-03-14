import Foundation

actor WeatherService {
    static let shared = WeatherService()

    private let baseURL = "https://aviationweather.gov/api/data"

    func fetchWeather(for airportId: String) async throws -> AirportWeather {
        let id = airportId.uppercased()
        async let metar = fetchMetar(for: id)
        async let taf = fetchTaf(for: id)

        let metarResult = try? await metar
        let tafResult = try? await taf

        return AirportWeather(
            airportId: id,
            metar: metarResult,
            taf: tafResult
        )
    }

    private func fetchMetar(for airportId: String) async throws -> MetarResponse {
        guard let url = URL(string: "\(baseURL)/metar?ids=\(airportId)&format=json") else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.serverError
        }

        let decoded = try JSONDecoder().decode([MetarResponse].self, from: data)
        guard let metar = decoded.first else {
            throw WeatherError.noData
        }
        return metar
    }

    private func fetchTaf(for airportId: String) async throws -> TafResponse {
        guard let url = URL(string: "\(baseURL)/taf?ids=\(airportId)&format=json") else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.serverError
        }

        let decoded = try JSONDecoder().decode([TafResponse].self, from: data)
        guard let taf = decoded.first else {
            throw WeatherError.noData
        }
        return taf
    }
}

enum WeatherError: LocalizedError {
    case invalidURL
    case serverError
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid weather API URL"
        case .serverError: return "Weather server error"
        case .noData: return "No weather data available"
        }
    }
}
