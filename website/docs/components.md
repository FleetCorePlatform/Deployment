---
sidebar_position: 2
---
# Components

The FleetCore ecosystem consists of three primary active components that work together to manage drone fleets.

---

## 1. Backend Server (Java/Quarkus) {#fleetcore-server}

Central coordination server. Manages persistent state and configuration for the entire fleet.

### Key Responsibilities:
- **Drone Onboarding:** Registers new drones and provisions AWS IoT Certificates and Kinesis Video Signaling Channels.
- **Mission Orchestration:** Uses `FleetCoreLib` to generate mission bundles and dispatches them via AWS IoT Jobs.
- **Data Persistence:** Stores telemetry, detection events, and mission history in a PostGIS-enabled PostgreSQL database.
- **Auth Proxy:** Validates operator JWTs from Cognito and provides a secure REST API for the Desktop client.

---

### Tech Stack:
- **Framework:** [Quarkus](https://quarkus.io/)
- **Database:** PostgreSQL + [PostGIS](https://postgis.net/)
- **ORM:** [MyBatis Plus](https://mybatis.plus/en/)
- **API:** REST (OpenAPI/Swagger included)

---

## Database Schema Design

The backend manages a PostGIS-enabled PostgreSQL database. The schema is designed to handle geospatial drone data, mission logs, fleet maintenance, and other required records.

![Database Schema Diagram](/img/db_diagram.svg)

---

## 2. Desktop Client (Tauri/React) {#fleetcore-desktop}

The Ground Control Station (GCS) used by operators to plan missions and control drones in real-time.

### Key Responsibilities:
- **Mission Planning:** Geospatial interface for defining survey boundaries and drone home positions.
- **Real-time Monitoring:** Low-latency WebRTC video feed streamed directly from the active drone.
- **Manual Control:** Integrated support for gamepads to allow manual override of drone flight.
- **Secure Bridge:** Uses a Rust-based proxy to safely forward requests to the Server with Cognito identity headers.

---

### Desktop Home Page
![Desktop Home Page](/img/home_page.png)
*Figure 1: Landing page of the client*

---

### Desktop GCS Overview
![Desktop GCS Planning UI](/img/mission_creation.png)
*Figure 2: Mission planning screen*

---

### Low-Latency Manual Control
![WebRTC & Manual Control UI Placeholder](https://placehold.co/800x450/png?text=WebRTC+and+Manual+Control+UI+Placeholder) <br></br>
*Figure 3: [Screenshot W.I.P] Manual drone control interface*

---

### Tech Stack:
- **Shell:** [Tauri v2](https://tauri.app/) (Rust)
- **Frontend:** [React](https://react.dev/) + [Tailwind CSS](https://tailwindcss.com/)
- **Streaming:** WebRTC (Amazon KVS SDK)

---

## 3. Onboard Agent (Python) {#onboard-agent}

The coordinator software of the drone, running on it's companion computer (`Raspberry Pi 5`).

### Key Responsibilities:
- **Flight Controller Bridge:** Communicates with the PX4 flight stack via **MAVSDK**.
- **Job Consumer:** Listens for AWS IoT Jobs, downloads mission bundles from S3, and executes them autonomously.
- **State Management:** Uses a dedicated **[State Machine](./onboard-agent-state-machine)** to track the drone's lifecycle.
- **Telemetry Provider:** Publishes real-time GPS, battery, and health data to AWS IoT Core.
- **Video Streamer:** Manages GStreamer pipelines to encode camera data and stream it via WebRTC.

---

### Onboard Agent In Simulator
![Onboard Agent Simulator](/img/drone_simulation.png)
*Figure 4: The drone agent controlling a simulated drone in Gazebo Classic*

---

### Tech Stack:
- **Language:** Python 3.13+
- **Drone Link:** [MAVSDK](https://mavsdk.mavlink.io/main/en/), [MAVLink](https://mavlink.io/en/)
- **Streaming:** GStreamer + aiortc
- **Cloud:** AWS IoT SDK v2
