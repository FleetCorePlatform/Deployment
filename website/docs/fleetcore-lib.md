---
sidebar_position: 4
---
# Algorithms

The `FleetCoreLib` project is the algorithmic core of the platform. It provides high-performance implementations for area partitioning and coverage path generation, which are essential for multi-drone survey missions.

## 1. Recursive Binary Space Partitioning (BSP)

The [`PolygonPartitioner`](https://fleetcoreplatform.github.io/FleetCoreLib/io/fleetcoreplatform/Algorithms/PolygonPartitioner.html) class implements a recursive BSP algorithm to divide a large survey area (defined as a Polygon) into smaller sub-polygons, each assigned to an individual drone.

### How it works:
- **Axis-Aligned Bisection:** The algorithm identifies the longest axis of the polygon's bounding box (width vs. height).
- **Split Line Selection:** A split line is created at the midpoint of the longest axis.
- **Polygon Clipping:** Using a simplified **Sutherland-Hodgman** approach, the algorithm clips the polygon against the split line, creating two child polygons.
- **Recursion:** This process repeats recursively until the target number of partitions (matching the drone count) is reached, or until the sub-polygons fall below a minimum area threshold.

---

## 2. Boustrophedon (Lawnmower) Path Generation

The [`MowerSurveyAlgorithm`](https://fleetcoreplatform.github.io/FleetCoreLib/io/fleetcoreplatform/Algorithms/MowerSurveyAlgorithm.html) generates a continuous coverage path (zig-zag) for a given sub-polygon.

### How it works:
- **Sweep-Line Technique:** The algorithm iterates from the bottom to the top of the polygon's bounding box using a predefined spacing
- **Intersection Calculation:** At each step, a horizontal sweep line intersects the polygon's edges.
- **Segment Sorting:** Intersections are sorted by their X-coordinate and paired to define "internal" segments.
- **Zig-Zag State:** To ensure a continuous path, the algorithm flips the direction of every alternate segment (left-to-right vs. right-to-left).

---

### BSP Partitioning with Survey Path Generation
![BSP Partitioning Plot](/img/partitioning_visualization.png)
*Figure 1: BSP partitioning output with computed lawnmower survey paths for multi-drone coverage.*

---

## API Reference

For a complete list of classes and methods, see the [Full API Reference](https://fleetcoreplatform.github.io/FleetCoreLib/).
