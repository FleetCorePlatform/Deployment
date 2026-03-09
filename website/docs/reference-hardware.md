---
sidebar_position: 6
---

# Reference Hardware

This page describes a conceptual hardware stack that the FleetCore onboard agent is designed towards.

---

## Flight Platform

### [Holybro X500 v2 PX4 Development Kit](https://holybro.com/collections/x500-kits/products/px4-development-kit-x500-v2)

The X500 v2 is the reference airframe for FleetCore drone units. It ships as a complete kit including the Pixhawk 6C flight controller, motors, ESCs, and frame.

- **Airframe:** X500 v2 quadcopter (500mm wheelbase)
- **Flight Controller:** Pixhawk 6C (PX4 stack)
- **Communication:** MAVSDK over UART/USB serial to companion computer

---

## Companion Computer

### [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/)

The onboard agent runs on the Raspberry Pi 5, acting as the bridge between the PX4 flight controller, AWS IoT Core, and the video streaming pipeline.

- **Recommended config:** 8GB RAM
- **OS:** Raspberry Pi OS Lite (64-bit)
- **Interfaces used:**
    - UART (flight controller)
    - CSI-2 (camera), USB-C (power)

---

## Connectivity

### [Sixfab 5G Development Kit](https://sixfab.com/product/raspberry-pi-5g-development-kit-5g-hat/)

Provides cellular connectivity for telemetry uplink and IoT Core communication in the field, where Wi-Fi infrastructure is unavailable.

- **Form factor:** Raspberry Pi HAT (compatible with Pi 5 via USB 3.0)
- **Modem:** Quectel RM502Q-AE
- **Connectivity:** 5G Sub-6GHz / 4G LTE-A fallback
- **Antennas:** Internal antenna design

---

## Camera

### [Raspberry Pi HQ Camera (IMX477)](https://www.raspberrypi.com/products/raspberry-pi-high-quality-camera/)

The recommended imaging sensor for survey operations. Native CSI-2 connection to the Pi 5 ensures low-latency capture and full compatibility with the GStreamer pipeline used by the onboard agent.

- **Sensor:** Sony IMX477, 12.3MP
- **Interface:** CSI-2 (direct Pi 5 connection)
- **Lens:** 6mm wide-angle CS-mount (recommended for aerial coverage)
- **Driver support:** `libcamera`, GStreamer `libcamerasrc`

---

## Full Bill of Materials

| Component | Model | Role | Est. Price (USD) |
| :--- | :--- | :--- | :--- |
| Airframe & FC | Holybro X500 v2 PX4 Dev Kit | Flight platform | ~$508 |
| Companion Computer | Raspberry Pi 5 (8GB) | Onboard agent host | ~$80 |
| Cellular HAT | Sixfab 5G Development Kit | Field connectivity | ~$195 |
| Camera | Raspberry Pi HQ Camera + 6mm lens | Survey imaging & WebRTC stream | ~$75 |
| **Total** | | | **~$858** |