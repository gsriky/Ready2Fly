# Ready2Fly - Requirements Document

## 1. Project Overview

**App Name:** Ready2Fly

**Description:** A flight-planning decision-support app for general aviation pilots. Ready2Fly automates the pre-flight weather briefing and risk assessment process — replacing the manual steps a pilot would normally perform across multiple apps (ForeFlight, Windy, Graphical Area Forecast / GFA) — and delivers a simple **Go / No-Go** decision.

**Core Problem:** Today, before every flight a pilot manually checks multiple sources (ForeFlight, Windy, GFA) for weather, icing, turbulence, IMC/VFR conditions, and more. This is time-consuming and error-prone. Ready2Fly consolidates all of that into a single, streamlined experience.

## 2. Platform & Distribution

- **Platform:** iOS (iPhone)
- **Initial Distribution:** Apple TestFlight (private, personal use)
- **Future Distribution:** Apple App Store (for sharing with friends and wider audience)
- **Technology:** Native iOS app (Swift / SwiftUI)

## 3. Core User Flow

The primary interface is intentionally simple. The pilot provides:

1. **Departure airport** (origin)
2. **Destination airport**
3. **Departure date**
4. **Departure time**

Then the app does the rest and presents a **Go / No-Go recommendation**.

## 4. Pilot & Aircraft Profile

The app stores a persistent profile so the pilot doesn't have to re-enter this information each time:

### 4.1 Pilot Profile (Personal Minimums)
- Pilot's personal weather minimums (e.g., ceiling, visibility, crosswind limits)
- Pilot certification level and experience factors
- Any aeromedical factors relevant to risk assessment

### 4.2 Aircraft Profile
- Aircraft type and model the pilot usually flies
- Aircraft performance capabilities and limitations (e.g., ceiling, range, IFR capability)
- Known equipment (e.g., de-icing, autopilot, GPS/IFR-rated avionics)

The Go/No-Go decision is evaluated against these personal and aircraft minimums.

## 5. Automated Data & Analysis

Once the pilot enters the flight details, the app automatically retrieves and analyzes:

### 5.1 Weather Data
- **METAR** — current weather observations at departure and destination airports
- **TAF** — terminal area forecasts for both airports
- **Winds aloft** — wind speed and direction at various altitudes along the route
- **Icing forecasts** — risk of icing conditions along the route and at altitude
- **Turbulence forecasts** — expected turbulence levels along the route
- **IMC vs. VFR conditions** — instrument vs. visual meteorological conditions assessment
- **Graphical weather data** (equivalent to GFA / Windy) — precipitation, fronts, convective activity

### 5.2 Flight Planning Analysis
- **Estimated arrival time** at destination based on aircraft performance and winds
- **Preferred altitude recommendation** based on winds, turbulence, icing, and terrain
- **Route-level risk assessment** — evaluating the entire route, not just endpoints

### 5.3 Risk Management
- Comparison of forecast conditions against the pilot's **personal minimums**
- Comparison of forecast conditions against the **aircraft's capabilities**
- Aeromedical factor consideration
- Overall **Go / No-Go recommendation** with clear reasoning

## 6. User Roles

- **Primary User:** General aviation pilot (initially the app creator, personal use via TestFlight)
- **Future Users:** Friends and other GA pilots (via App Store)

## 7. Future Enhancements (Post-MVP)

*(To be defined as the Go/No-Go MVP is built out)*

---

*Document Status: In Progress*
*Last Updated: 2026-03-14*
