import SwiftUI

extension GoNoGoDecision: Identifiable {
    var id: String { summary }
}

struct GoNoGoResultView: View {
    let decision: GoNoGoDecision
    let flightPlan: FlightPlan
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Go/No-Go Banner
                    recommendationBanner

                    // Flight Info
                    flightInfoCard

                    // Summary
                    Text(decision.summary)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Weather cards
                    if let depWx = decision.departureWeather {
                        WeatherCard(title: "Departure: \(depWx.airportId)", weather: depWx)
                    }
                    if let destWx = decision.destinationWeather {
                        WeatherCard(title: "Destination: \(destWx.airportId)", weather: destWx)
                    }

                    // Decision Factors
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Decision Factors")
                            .font(.headline)
                        ForEach(decision.factors) { factor in
                            FactorRow(factor: factor)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("Flight Assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var recommendationBanner: some View {
        VStack(spacing: 12) {
            Image(systemName: decision.recommendation.emoji)
                .font(.system(size: 64))
                .foregroundStyle(recommendationColor)

            Text(decision.recommendation.rawValue)
                .font(.system(size: 42, weight: .black))
                .foregroundStyle(recommendationColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(recommendationColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var flightInfoCard: some View {
        HStack {
            VStack {
                Text(flightPlan.departureAirport.uppercased())
                    .font(.title2.bold().monospaced())
                Text("Departure")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "airplane")
                .font(.title)
                .foregroundStyle(.blue)
            Spacer()
            VStack {
                Text(flightPlan.destinationAirport.uppercased())
                    .font(.title2.bold().monospaced())
                Text("Destination")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var recommendationColor: Color {
        switch decision.recommendation {
        case .go: return .green
        case .marginal: return .orange
        case .noGo: return .red
        }
    }
}

struct WeatherCard: View {
    let title: String
    let weather: AirportWeather

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                FlightCategoryBadge(category: weather.flightCategory)
            }

            Divider()

            WeatherRow(label: "Sky", value: weather.skyConditionDescription)
            WeatherRow(label: "Visibility", value: String(format: "%.1f SM", weather.visibility))

            if let ceiling = weather.ceiling {
                WeatherRow(label: "Ceiling", value: "\(ceiling) ft AGL")
            }

            let windText: String = {
                if let gust = weather.windGust {
                    return "\(weather.windDirection)° at \(weather.windSpeed) kts, gusting \(gust)"
                }
                return "\(weather.windDirection)° at \(weather.windSpeed) kts"
            }()
            WeatherRow(label: "Wind", value: windText)
            WeatherRow(label: "Temp/Dewpoint", value: String(format: "%.0f°C / %.0f°C", weather.temperature, weather.dewpoint))

            Divider()

            Text("Raw METAR")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text(weather.rawMetar)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct WeatherRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.subheadline)
        }
    }
}

struct FlightCategoryBadge: View {
    let category: FlightCategory

    var body: some View {
        Text(category.rawValue)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }

    private var badgeColor: Color {
        switch category {
        case .vfr: return .green
        case .mvfr: return .blue
        case .ifr: return .red
        case .lifr: return .purple
        case .unknown: return .gray
        }
    }
}

struct FactorRow: View {
    let factor: DecisionFactor

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: factor.status.iconName)
                .foregroundStyle(factorColor)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(factor.title)
                    .font(.subheadline.bold())
                Text(factor.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private var factorColor: Color {
        switch factor.status {
        case .pass: return .green
        case .caution: return .orange
        case .fail: return .red
        }
    }
}
