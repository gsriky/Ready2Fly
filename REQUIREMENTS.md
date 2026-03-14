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

### 3.1 Example Scenario

> **Flight:** KPAO (Palo Alto) → KHND (Henderson, Las Vegas)
> **Aircraft:** Cirrus SR20 (no oxygen system)
> **Departure:** Tomorrow morning, 9:00 AM

## 4. Pilot & Aircraft Profile

The app stores a persistent profile so the pilot doesn't have to re-enter this information each time:

### 4.1 Pilot Profile (Personal Minimums)
- Pilot's personal weather minimums (e.g., ceiling, visibility, crosswind limits)
- Pilot certification level and experience factors
- Any aeromedical factors relevant to risk assessment

### 4.2 Aircraft Profile
- Aircraft type and model the pilot usually flies (e.g., Cirrus SR20)
- Aircraft performance capabilities and limitations (e.g., ceiling, range, IFR capability)
- Known equipment (e.g., de-icing, autopilot, GPS/IFR-rated avionics)
- Oxygen system availability (affects max usable altitude)
- The profile is pre-configured so the app already knows the aircraft's constraints

The Go/No-Go decision is evaluated against these personal and aircraft minimums.

## 5. Pre-Flight Decision Checklist (Automated Steps)

The following is the step-by-step process the app automates — the same sequence a pilot would manually perform across ForeFlight, Windy, and GFA today:

### Step 1: Weather at Departure & Destination
- Retrieve **METAR** (current conditions) and **TAF** (forecast) for both the departure and destination airports
- Evaluate weather at the **planned departure time** and **estimated arrival time**
- This is the very first check — a quick sanity check before going deeper

### Step 2: Route & Preferred Routes
- Look up **preferred routes** between the two airports (equivalent to ForeFlight's preferred routes)
- Present the available preferred routes for the city pair
- Identify the **Victor Airways** along the preferred route

### Step 3: Altitude Selection
- Determine the best cruising altitude based on:
  - **Direction of flight** (hemispheric rule: odd/even thousands)
  - **Aircraft limitations** (e.g., SR20 with no oxygen — max 12,500 ft for extended cruise)
  - **Winds aloft** at various altitudes — pick the altitude with the most favorable winds
  - **Historical preferences** — what altitudes other pilots commonly fly on this route
  - **Terrain clearance** along the route (especially important for mountainous terrain like KPAO → KHND)

### Step 4: Instrument Approach Procedures (Backup)
- Even when planning a **VFR flight**, retrieve and present available **IFR approach procedures** at the destination airport
- This serves as a backup reference — in case conditions deteriorate and the pilot needs to:
  - Execute a real instrument approach
  - Practice an instrument approach
- Show approach types available (ILS, RNAV/GPS, VOR, etc.)

### Step 5: Weather Along the Route
*(To be detailed — icing, turbulence, convective activity, IMC/VFR along route segments)*

### Step 6: Risk Assessment & Go/No-Go Decision
*(To be detailed — comparison against personal minimums and aircraft capabilities)*

## 6. Automated Data & Analysis

Once the pilot enters the flight details, the app automatically retrieves and analyzes:

### 6.1 Weather Data
- **METAR** — current weather observations at departure and destination airports
- **TAF** — terminal area forecasts for both airports
- **Winds aloft** — wind speed and direction at various altitudes along the route
- **Icing forecasts** — risk of icing conditions along the route and at altitude
- **Turbulence forecasts** — expected turbulence levels along the route
- **IMC vs. VFR conditions** — instrument vs. visual meteorological conditions assessment
- **Graphical weather data** (equivalent to GFA / Windy) — precipitation, fronts, convective activity

### 6.2 Flight Planning Analysis
- **Preferred routes** between departure and destination airports
- **Victor Airways** along the route
- **Optimal altitude recommendation** based on winds, aircraft limits, terrain, and direction of flight
- **Estimated arrival time** at destination based on aircraft performance and winds
- **IFR approach procedures** available at destination (backup reference)
- **Route-level risk assessment** — evaluating the entire route, not just endpoints

### 6.3 Risk Management
- Comparison of forecast conditions against the pilot's **personal minimums**
- Comparison of forecast conditions against the **aircraft's capabilities** (e.g., no oxygen = altitude constraint)
- Aeromedical factor consideration
- Overall **Go / No-Go recommendation** with clear reasoning

## 7. User Roles

- **Primary User:** General aviation pilot (initially the app creator, personal use via TestFlight)
- **Future Users:** Friends and other GA pilots (via App Store)

## 8. Future Enhancements (Post-MVP)

*(To be defined as the Go/No-Go MVP is built out)*

---

*Document Status: In Progress*
*Last Updated: 2026-03-14*
