---
sidebar_position: 3
---
# FleetCore Components

The FleetCore ecosystem consists of three primary active components that work together to manage drone fleets.

---

## 1. FleetCoreServer (Java/Quarkus) {#fleetcore-server}

The central "Brain" of the operation. It manages the persistent state of the entire fleet.

### Key Responsibilities:
- **Drone Onboarding:** Registers new drones and provisions AWS IoT Certificates and Kinesis Video Signaling Channels.
- **Mission Orchestration:** Uses `FleetCoreLib` to generate mission bundles and dispatches them via AWS IoT Jobs.
- **Data Persistence:** Stores telemetry, detection events, and mission history in a PostGIS-enabled PostgreSQL database.
- **Auth Proxy:** Validates operator JWTs from Cognito and provides a secure REST API for the Desktop client.

---

### FleetCore Server Dashboard (Conceptual)
![Server Dashboard Placeholder](https://placehold.co/800x400/png?text=FleetCore+Server+Dashboard+Placeholder)
*Figure 1: [PLACEHOLDER] - To be replaced with a screenshot of the platform operator dashboard showing fleet status.*

---

### Tech Stack:
- **Framework:** [Quarkus](https://quarkus.io/)
- **Database:** PostgreSQL + [PostGIS](https://postgis.net/)
- **ORM:** [MyBatis Plus](https://mybatis.plus/en/)
- **API:** REST (OpenAPI/Swagger included)

---

## Database Schema Design

The `Quarkus` (Java) backend manages a PostGIS-enabled PostgreSQL database. The schema is designed to handle geospatial drone data, mission logs, fleet maintenance, and other required records.

![Database Schema Diagram](/img/db_diagram.svg)

---

## 2. FleetCoreDesktop (Tauri/React) {#fleetcore-desktop}

The Ground Control Station (GCS) used by operators to plan missions and control drones in real-time.

### Key Responsibilities:
- **Mission Planning:** Geospatial interface for defining survey boundaries and drone home positions.
- **Real-time Monitoring:** Low-latency WebRTC video feed streamed directly from the active drone.
- **Manual Control:** Integrated support for gamepads to allow manual override of drone flight.
- **Secure Bridge:** Uses a Rust-based proxy to safely forward requests to the Server with Cognito identity headers.

---

### Desktop GCS Overview
![Desktop GCS Planning UI Placeholder](https://placehold.co/800x450/png?text=Desktop+GCS+Planning+UI+Placeholder)
*Figure 2: [PLACEHOLDER] - To be replaced with a screenshot of the Mission Planning interface showing polygons and waypoints.*

---

### Low-Latency Manual Control
![WebRTC & Manual Control UI Placeholder](https://placehold.co/800x450/png?text=WebRTC+and+Manual+Control+UI+Placeholder)
*Figure 3: [PLACEHOLDER] - To be replaced with a screenshot showing a live WebRTC drone stream and the manual control overlay.*

---

### Tech Stack:
- **Shell:** [Tauri v2](https://tauri.app/) (Rust)
- **Frontend:** [React](https://react.dev/) + [Tailwind CSS](https://tailwindcss.com/)
- **Streaming:** WebRTC (Amazon KVS SDK)

---

## 3. OnboardAgent (Python) {#onboard-agent}

The coordinator software of the drone, running on it's companion computer (`Raspberry Pi 5`).

### Key Responsibilities:
- **Flight Controller Bridge:** Communicates with the PX4 flight stack via **MAVSDK**.
- **Job Consumer:** Listens for AWS IoT Jobs, downloads mission bundles from S3, and executes them autonomously.
- **State Management:** Uses a dedicated **[State Machine](./onboard-agent-state-machine)** to track the drone's lifecycle.
- **Telemetry Provider:** Publishes real-time GPS, battery, and health data to AWS IoT Core.
- **Video Streamer:** Manages GStreamer pipelines to encode camera data and stream it via WebRTC.

---

### Onboard Agent Telemetry
![Onboard Agent Logs Placeholder](https://placehold.co/600x400/png?text=Onboard+Agent+Logs+Placeholder)
*Figure 4: [PLACEHOLDER] - To be replaced with a screenshot of the agent's telemetry log output or mission execution status.*

---

### Tech Stack:
- **Language:** Python 3.13+
- **Drone Link:** [MAVSDK](https://mavsdk.mavlink.io/main/en/), [MAVLink](https://mavlink.io/en/)
- **Streaming:** GStreamer + aiortc
- **Cloud:** AWS IoT SDK v2
