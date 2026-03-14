import SwiftUI

struct AircraftProfileView: View {
    @AppStorage("aircraftProfile") private var profileData: Data = Data()
    @State private var profile = AircraftProfile()

    var body: some View {
        NavigationStack {
            Form {
                Section("Aircraft Info") {
                    TextField("Tail Number", text: $profile.tailNumber)
                        .textInputAutocapitalization(.characters)
                    TextField("Make & Model", text: $profile.makeModel)
                    Picker("Category", selection: $profile.aircraftCategory) {
                        ForEach(AircraftProfile.AircraftCategory.allCases) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                }

                Section("Performance") {
                    Stepper("Cruise Speed: \(profile.cruiseSpeedKnots) kts",
                            value: $profile.cruiseSpeedKnots, in: 60...300, step: 5)
                    Stepper("Service Ceiling: \(profile.maxAltitude) ft",
                            value: $profile.maxAltitude, in: 5000...45000, step: 500)
                    Stepper("Usable Altitude: \(profile.usableAltitude) ft",
                            value: $profile.usableAltitude, in: 5000...45000, step: 500)
                    Stepper("Fuel Endurance: \(String(format: "%.1f", profile.fuelEnduranceHours)) hrs",
                            value: $profile.fuelEnduranceHours, in: 1...12, step: 0.5)
                    Stepper("Range: \(profile.rangeNM) NM",
                            value: $profile.rangeNM, in: 100...3000, step: 50)
                }

                Section("Equipment") {
                    Toggle("Oxygen System", isOn: $profile.hasOxygen)
                    Toggle("Autopilot", isOn: $profile.hasAutopilot)
                    Toggle("De-Icing / Anti-Icing", isOn: $profile.hasDeIcing)
                    Toggle("IFR Certified", isOn: $profile.isIFRCertified)
                    Toggle("GPS", isOn: $profile.hasGPS)
                    Toggle("ADS-B", isOn: $profile.hasADSB)
                }

                Section("Limitations") {
                    Stepper("Max Crosswind: \(profile.maxCrosswindComponent) kts",
                            value: $profile.maxCrosswindComponent, in: 5...35)
                    Stepper("Demonstrated Crosswind: \(profile.maxDemonstratedCrosswind) kts",
                            value: $profile.maxDemonstratedCrosswind, in: 5...30)
                    Stepper("Min Runway: \(profile.minRunwayLength) ft",
                            value: $profile.minRunwayLength, in: 1000...8000, step: 500)
                }
            }
            .navigationTitle("Aircraft Profile")
            .onAppear { loadProfile() }
            .onChange(of: profile.tailNumber) { _, _ in saveProfile() }
            .onChange(of: profile.makeModel) { _, _ in saveProfile() }
            .onChange(of: profile.aircraftCategory) { _, _ in saveProfile() }
            .onChange(of: profile.cruiseSpeedKnots) { _, _ in saveProfile() }
            .onChange(of: profile.maxAltitude) { _, _ in saveProfile() }
            .onChange(of: profile.usableAltitude) { _, _ in saveProfile() }
            .onChange(of: profile.hasOxygen) { _, _ in saveProfile() }
            .onChange(of: profile.fuelEnduranceHours) { _, _ in saveProfile() }
            .onChange(of: profile.rangeNM) { _, _ in saveProfile() }
            .onChange(of: profile.hasAutopilot) { _, _ in saveProfile() }
            .onChange(of: profile.hasDeIcing) { _, _ in saveProfile() }
            .onChange(of: profile.isIFRCertified) { _, _ in saveProfile() }
            .onChange(of: profile.hasGPS) { _, _ in saveProfile() }
            .onChange(of: profile.hasADSB) { _, _ in saveProfile() }
            .onChange(of: profile.maxCrosswindComponent) { _, _ in saveProfile() }
            .onChange(of: profile.maxDemonstratedCrosswind) { _, _ in saveProfile() }
            .onChange(of: profile.minRunwayLength) { _, _ in saveProfile() }
        }
    }

    private func loadProfile() {
        if let decoded = try? JSONDecoder().decode(AircraftProfile.self, from: profileData) {
            profile = decoded
        }
    }

    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            profileData = encoded
        }
    }
}

#Preview {
    AircraftProfileView()
}
