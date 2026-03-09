---
sidebar_position: 1
---

# Overview

FleetCore is a platform for coordinating autonomous drone fleets across large survey areas, handling mission planning, area partitioning, real-time monitoring, and live video feed with manual control through a unified desktop control station.

## Project Structure

The platform is composed of several key modules:

- **[FleetCoreServer](./components#fleetcore-server):** The central control plane built with Quarkus (Java). It orchestrates mission life-cycles, manages drone groups, and synchronizes telemetry with AWS.
- **[FleetCoreLib](./fleetcore-lib):** The shared algorithmic engine (Java) responsible for recursive area partitioning and coverage path generation.
- **[FleetCoreDesktop](./components#fleetcore-desktop):** A high-performance Ground Control Station (GCS) built with Tauri (Rust), and React. It handles resource management, mission planning, WebRTC video streaming, and manual drone control.
- **[OnboardAgent](./components#onboard-agent):** The Python bridge running on drone companion computers, linking the PX4 flight controller to AWS IoT Core.

## Ecosystem Workflow

1.  **Planning:** An operator defines a survey area in **FleetCoreDesktop**.
2.  **Partitioning:** The area is sent to **FleetCoreServer**, which utilizes **FleetCoreLib** to divide the area among available drones and generate waypoints.
3.  **Deployment:** Missions are distributed via **AWS IoT Jobs**.
4.  **Execution:** The **OnboardAgent** receives the job, downloads the mission bundle from **S3**, and executes it via **MAVSDK**.
5.  **Monitoring:** Telemetry is published to **IoT Core** (and buffered in **SQS**), while live video is streamed directly via **Kinesis Video WebRTC**.
