import Foundation

struct GoNoGoEngine {

    func evaluate(
        departureWeather: AirportWeather?,
        destinationWeather: AirportWeather?,
        pilotProfile: PilotProfile,
        aircraftProfile: AircraftProfile,
        flightPlan: FlightPlan
    ) -> GoNoGoDecision {
        var factors: [DecisionFactor] = []

        // Evaluate departure weather
        if let depWx = departureWeather {
            factors.append(contentsOf: evaluateAirportWeather(
                depWx,
                profile: pilotProfile,
                location: "Departure",
                categoryPrefix: .departureWeather
            ))
        }

        // Evaluate destination weather
        if let destWx = destinationWeather {
            factors.append(contentsOf: evaluateAirportWeather(
                destWx,
                profile: pilotProfile,
                location: "Destination",
                categoryPrefix: .destinationWeather
            ))
        }

        // Evaluate aircraft constraints
        factors.append(contentsOf: evaluateAircraftConstraints(
            aircraftProfile: aircraftProfile,
            departureWeather: departureWeather,
            destinationWeather: destinationWeather
        ))

        // Evaluate custom checks
        for check in pilotProfile.customChecks where check.isEnabled {
            factors.append(DecisionFactor(
                category: .custom,
                title: check.title,
                detail: check.description,
                status: .caution // Custom checks always show as caution for pilot review
            ))
        }

        // Determine overall recommendation
        let recommendation = determineRecommendation(from: factors)
        let summary = generateSummary(recommendation: recommendation, factors: factors)

        return GoNoGoDecision(
            recommendation: recommendation,
            factors: factors,
            summary: summary,
            departureWeather: departureWeather,
            destinationWeather: destinationWeather
        )
    }

    // MARK: - Weather Evaluation

    private func evaluateAirportWeather(
        _ weather: AirportWeather,
        profile: PilotProfile,
        location: String,
        categoryPrefix: DecisionFactor.FactorCategory
    ) -> [DecisionFactor] {
        var factors: [DecisionFactor] = []

        // Flight category
        let flightCat = weather.flightCategory
        let catStatus: DecisionFactor.FactorStatus
        switch flightCat {
        case .vfr: catStatus = .pass
        case .mvfr: catStatus = profile.hasInstrumentRating ? .caution : .fail
        case .ifr: catStatus = profile.hasInstrumentRating ? .caution : .fail
        case .lifr: catStatus = .fail
        case .unknown: catStatus = .caution
        }
        factors.append(DecisionFactor(
            category: categoryPrefix,
            title: "\(location) Flight Category",
            detail: "\(flightCat.rawValue) conditions reported",
            status: catStatus
        ))

        // Visibility
        let vis = weather.visibility
        let visStatus: DecisionFactor.FactorStatus
        if vis >= profile.minVisibility {
            visStatus = .pass
        } else if vis >= profile.minVisibility * 0.75 {
            visStatus = .caution
        } else {
            visStatus = .fail
        }
        factors.append(DecisionFactor(
            category: .visibility,
            title: "\(location) Visibility",
            detail: String(format: "%.1f SM (minimum: %.1f SM)", vis, profile.minVisibility),
            status: visStatus
        ))

        // Ceiling
        if let ceiling = weather.ceiling {
            let ceilStatus: DecisionFactor.FactorStatus
            if ceiling >= profile.minCeiling {
                ceilStatus = .pass
            } else if ceiling >= Int(Double(profile.minCeiling) * 0.75) {
                ceilStatus = .caution
            } else {
                ceilStatus = .fail
            }
            factors.append(DecisionFactor(
                category: .ceiling,
                title: "\(location) Ceiling",
                detail: "\(ceiling) ft AGL (minimum: \(profile.minCeiling) ft)",
                status: ceilStatus
            ))
        }

        // Wind
        let windSpeed = weather.windSpeed
        let gustSpeed = weather.windGust ?? windSpeed
        let windStatus: DecisionFactor.FactorStatus
        if gustSpeed <= profile.maxCrosswind {
            windStatus = .pass
        } else if gustSpeed <= profile.maxCrosswind + 5 {
            windStatus = .caution
        } else {
            windStatus = .fail
        }
        let windDetail: String
        if let gust = weather.windGust {
            windDetail = "\(weather.windDirection)° at \(windSpeed) kts, gusting \(gust) kts"
        } else {
            windDetail = "\(weather.windDirection)° at \(windSpeed) kts"
        }
        factors.append(DecisionFactor(
            category: .wind,
            title: "\(location) Wind",
            detail: windDetail,
            status: windStatus
        ))

        // Sky condition
        factors.append(DecisionFactor(
            category: categoryPrefix,
            title: "\(location) Sky",
            detail: weather.skyConditionDescription,
            status: catStatus // Matches flight category assessment
        ))

        return factors
    }

    // MARK: - Aircraft Evaluation

    private func evaluateAircraftConstraints(
        aircraftProfile: AircraftProfile,
        departureWeather: AirportWeather?,
        destinationWeather: AirportWeather?
    ) -> [DecisionFactor] {
        var factors: [DecisionFactor] = []

        // IFR capability check
        if let depWx = departureWeather {
            let needsIFR = depWx.flightCategory == .ifr || depWx.flightCategory == .lifr
            if needsIFR && !aircraftProfile.isIFRCertified {
                factors.append(DecisionFactor(
                    category: .aircraft,
                    title: "Aircraft IFR Capability",
                    detail: "IFR conditions but aircraft is not IFR certified",
                    status: .fail
                ))
            }
        }

        if let destWx = destinationWeather {
            let needsIFR = destWx.flightCategory == .ifr || destWx.flightCategory == .lifr
            if needsIFR && !aircraftProfile.isIFRCertified {
                factors.append(DecisionFactor(
                    category: .aircraft,
                    title: "Aircraft IFR at Destination",
                    detail: "IFR conditions at destination but aircraft is not IFR certified",
                    status: .fail
                ))
            }
        }

        // De-icing check
        if !aircraftProfile.hasDeIcing {
            factors.append(DecisionFactor(
                category: .aircraft,
                title: "De-Icing Equipment",
                detail: "Aircraft has no de-icing — avoid known icing conditions",
                status: .caution
            ))
        }

        // Oxygen / altitude check
        if !aircraftProfile.hasOxygen {
            factors.append(DecisionFactor(
                category: .aircraft,
                title: "Oxygen System",
                detail: "No oxygen — limited to \(aircraftProfile.usableAltitude) ft for extended cruise",
                status: .caution
            ))
        }

        return factors
    }

    // MARK: - Recommendation

    private func determineRecommendation(from factors: [DecisionFactor]) -> GoNoGoDecision.Recommendation {
        let hasFailure = factors.contains { $0.status == .fail }
        let hasCaution = factors.contains { $0.status == .caution }

        if hasFailure {
            return .noGo
        } else if hasCaution {
            return .marginal
        } else {
            return .go
        }
    }

    private func generateSummary(recommendation: GoNoGoDecision.Recommendation, factors: [DecisionFactor]) -> String {
        let failCount = factors.filter { $0.status == .fail }.count
        let cautionCount = factors.filter { $0.status == .caution }.count
        let passCount = factors.filter { $0.status == .pass }.count

        switch recommendation {
        case .go:
            return "All \(passCount) checks passed. Conditions are within your personal minimums and aircraft capabilities."
        case .marginal:
            return "\(cautionCount) factor(s) require attention. Review caution items carefully before making your final decision."
        case .noGo:
            return "\(failCount) factor(s) exceed your personal minimums or aircraft capabilities. Flight is not recommended."
        }
    }
}
