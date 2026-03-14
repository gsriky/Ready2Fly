import SwiftUI

struct FlightPlannerView: View {
    @StateObject private var viewModel = FlightPlannerViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue)
                        Text("Ready2Fly")
                            .font(.largeTitle.bold())
                        Text("Pre-flight Go/No-Go Decision")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 16)

                    // Flight Input Card
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            AirportInputField(
                                label: "FROM",
                                placeholder: "KPAO",
                                text: $viewModel.departureAirport
                            )
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .padding(.top, 20)
                            AirportInputField(
                                label: "TO",
                                placeholder: "KHND",
                                text: $viewModel.destinationAirport
                            )
                        }

                        DatePicker("Departure Date",
                                   selection: $viewModel.departureDate,
                                   displayedComponents: .date)
                        .datePickerStyle(.compact)

                        DatePicker("Departure Time",
                                   selection: $viewModel.departureTime,
                                   displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Check Flight Button
                    Button {
                        Task {
                            await viewModel.checkFlight()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "checkmark.shield.fill")
                            }
                            Text(viewModel.isLoading ? "Checking..." : "Check Flight")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canCheck ? Color.blue : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.canCheck || viewModel.isLoading)

                    // Error
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.callout)
                            .foregroundStyle(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .fullScreenCover(item: $viewModel.decision) { decision in
                GoNoGoResultView(decision: decision, flightPlan: viewModel.currentFlightPlan)
            }
        }
    }
}

struct AirportInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .font(.title2.monospaced().bold())
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    FlightPlannerView()
}
