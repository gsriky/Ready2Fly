import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FlightPlannerView()
                .tabItem {
                    Label("Plan Flight", systemImage: "airplane.departure")
                }

            PilotProfileView()
                .tabItem {
                    Label("Pilot", systemImage: "person.fill")
                }

            AircraftProfileView()
                .tabItem {
                    Label("Aircraft", systemImage: "airplane")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
