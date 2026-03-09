---
sidebar_position: 2
---
# Infrastructure & AWS Integration

The FleetCore platform relies on a distributed AWS infrastructure to handle secure communication, data storage, and real-time streaming. This page explains **how** these components interact and **why** they were chosen.

## System Architecture Design

Below is the current architecture design for the FleetCore platform. 

![FleetCore Architecture](/img/fleetcore_architecture.svg)

---

## Key AWS Components

### 1. AWS IoT Core
IoT Core handles the secure, bidirectional communication between the `FleetCoreServer` and the `OnboardAgent`.
- **How it works:** Each drone is provisioned as an "IoT Thing" with unique X.509 certificates.
- **Why IoT Jobs?** We use **IoT Jobs** to deploy missions. This ensures that even if a drone is temporarily offline, it will receive the mission command as soon as it reconnects. The job lifecycle (PENDING -> IN_PROGRESS -> SUCCEEDED) provides built-in status tracking.

### 2. Kinesis Video Streams & WebRTC
Enables low-latency video streaming and manual control from the `FleetCoreDesktop` app to the drone.
- **How it works:** KVS Signaling Channels are used to perform the WebRTC handshake. Once the handshake is complete, a Peer-to-Peer (P2P) connection is established.
- **Why WebRTC?** It bypasses the server entirely for video data, ensuring the lowest possible latency for manual flight operations.

### 3. SQS & Lambda
Telemetry and detections are handled asynchronously to ensure system stability.
- **SQS (FleetCoreTelemetry):** Acting as a buffer, it decouples the high-frequency telemetry incoming from the drones from the processing speed of the Quarkus server.
- **Lambda (process-detection):** Triggered by the AWS IoT routing engine when a drone publishes a detection message. It populates the database with the detection metadata and S3 image reference, ensuring the main `FleetCoreServer` remains stateless by offloading database writes.

### 4. Amazon Cognito
Manages the authentication for platform operators (Coordinators).
- **How it works:** `FleetCoreDesktop` authenticates with Cognito to receive a JWT. This token is then used to authorize REST API calls to the `FleetCoreServer`.
