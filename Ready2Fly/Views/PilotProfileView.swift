import SwiftUI

struct PilotProfileView: View {
    @AppStorage("pilotProfile") private var profileData: Data = Data()
    @State private var profile = PilotProfile()
    @State private var newCheckTitle = ""
    @State private var newCheckDescription = ""
    @State private var showingAddCheck = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Pilot Info") {
                    TextField("Name", text: $profile.name)
                    Picker("Certificate", selection: $profile.certificateLevel) {
                        ForEach(PilotProfile.CertificateLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    Toggle("Instrument Rating", isOn: $profile.hasInstrumentRating)
                }

                Section("Day VFR Minimums") {
                    Stepper("Visibility: \(String(format: "%.1f", profile.minVisibility)) SM",
                            value: $profile.minVisibility, in: 1...10, step: 0.5)
                    Stepper("Ceiling: \(profile.minCeiling) ft",
                            value: $profile.minCeiling, in: 500...10000, step: 500)
                    Stepper("Max Crosswind: \(profile.maxCrosswind) kts",
                            value: $profile.maxCrosswind, in: 5...30)
                    Stepper("Max Headwind: \(profile.maxHeadwind) kts",
                            value: $profile.maxHeadwind, in: 10...50)
                    Stepper("Max Tailwind: \(profile.maxTailwind) kts",
                            value: $profile.maxTailwind, in: 0...15)
                    Picker("Max Turbulence", selection: $profile.maxTurbulence) {
                        ForEach(TurbulenceLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }

                Section("Night Minimums") {
                    Stepper("Visibility: \(String(format: "%.1f", profile.minVisibilityNight)) SM",
                            value: $profile.minVisibilityNight, in: 1...15, step: 0.5)
                    Stepper("Ceiling: \(profile.minCeilingNight) ft",
                            value: $profile.minCeilingNight, in: 1000...15000, step: 500)
                }

                Section {
                    ForEach($profile.customChecks) { $check in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Toggle(isOn: $check.isEnabled) {
                                    Text(check.title)
                                        .font(.subheadline.bold())
                                }
                            }
                            Text(check.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        profile.customChecks.remove(atOffsets: indexSet)
                    }

                    Button {
                        showingAddCheck = true
                    } label: {
                        Label("Add Custom Check", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Custom Pre-Flight Checks")
                } footer: {
                    Text("Add your personal go-to checks that you always perform before a flight.")
                }
            }
            .navigationTitle("Pilot Profile")
            .onAppear { loadProfile() }
            .onChange(of: profile.name) { _, _ in saveProfile() }
            .onChange(of: profile.certificateLevel) { _, _ in saveProfile() }
            .onChange(of: profile.hasInstrumentRating) { _, _ in saveProfile() }
            .onChange(of: profile.minVisibility) { _, _ in saveProfile() }
            .onChange(of: profile.minCeiling) { _, _ in saveProfile() }
            .onChange(of: profile.maxCrosswind) { _, _ in saveProfile() }
            .onChange(of: profile.maxHeadwind) { _, _ in saveProfile() }
            .onChange(of: profile.maxTailwind) { _, _ in saveProfile() }
            .onChange(of: profile.maxTurbulence) { _, _ in saveProfile() }
            .onChange(of: profile.minVisibilityNight) { _, _ in saveProfile() }
            .onChange(of: profile.minCeilingNight) { _, _ in saveProfile() }
            .onChange(of: profile.customChecks.count) { _, _ in saveProfile() }
            .sheet(isPresented: $showingAddCheck) {
                addCheckSheet
            }
        }
    }

    private var addCheckSheet: some View {
        NavigationStack {
            Form {
                TextField("Check Title", text: $newCheckTitle)
                TextField("Description", text: $newCheckDescription, axis: .vertical)
                    .lineLimit(3...6)
            }
            .navigationTitle("New Custom Check")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newCheckTitle = ""
                        newCheckDescription = ""
                        showingAddCheck = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let check = CustomCheck(
                            title: newCheckTitle,
                            description: newCheckDescription
                        )
                        profile.customChecks.append(check)
                        newCheckTitle = ""
                        newCheckDescription = ""
                        showingAddCheck = false
                        saveProfile()
                    }
                    .disabled(newCheckTitle.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func loadProfile() {
        if let decoded = try? JSONDecoder().decode(PilotProfile.self, from: profileData) {
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
    PilotProfileView()
}
