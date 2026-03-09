---
sidebar_position: 4
---
# Algorithms

The `FleetCoreLib` project is the algorithmic core of the platform. It provides high-performance implementations for area partitioning and coverage path generation, which are essential for multi-drone survey missions.

## 1. Recursive Binary Space Partitioning (BSP)

The `PolygonPartitioner` class implements a recursive BSP algorithm to divide a large survey area (defined as a Polygon) into smaller sub-polygons, each assigned to an individual drone.

### How it works:
- **Axis-Aligned Bisection:** The algorithm identifies the longest axis of the polygon's bounding box (width vs. height).
- **Split Line Selection:** A split line is created at the midpoint of the longest axis.
- **Polygon Clipping:** Using a simplified **Sutherland-Hodgman** approach, the algorithm clips the polygon against the split line, creating two child polygons.
- **Recursion:** This process repeats recursively until the target number of partitions (matching the drone count) is reached, or until the sub-polygons fall below a minimum area threshold.

---

### BSP Partitioning Visualization
![BSP Partitioning Plot](/img/partitioning_visualization.png)
*Figure 1: Actual output of the BSP Partitioning algorithm, showing a survey area divided among multiple drones.*

---

## 2. Boustrophedon (Lawnmower) Path Generation

The `MowerSurveyAlgorithm` generates a continuous coverage path (zig-zag) for a given sub-polygon.

### How it works:
- **Sweep-Line Technique:** The algorithm iterates from the bottom to the top of the polygon's bounding box using a user-defined `spacing` (usually based on the camera's Field of View).
- **Intersection Calculation:** At each step, a horizontal sweep line intersects the polygon's edges.
- **Segment Sorting:** Intersections are sorted by their X-coordinate and paired to define "internal" segments.
- **Zig-Zag State:** To ensure a continuous path, the algorithm flips the direction of every alternate segment (left-to-right vs. right-to-left).

### Parameters:
- **Spacing:** The distance between consecutive sweep lines.
- **Altitude:** The target flight height (embedded in the generated waypoints).
- **ZigZag Initial State:** Whether to start the first segment from the left or right.

---

### Mower Path Visualization
![Mower Path Placeholder](https://placehold.co/600x400/png?text=Mower+Path+Visualization+Placeholder)
*Figure 2: [PLACEHOLDER] - To be replaced with a screenshot of a generated boustrophedon path over a survey sub-area.*

---

## Example Usage (Java)

```java
// Define the survey area
Polygon surveyArea = ...;

// Partition for 3 drones
PolygonPartitioner partitioner = new PolygonPartitioner();
List<Polygon> subAreas = partitioner.partition(surveyArea, 3);

// Generate mower path for the first sub-area
MowerSurveyAlgorithm mower = new MowerSurveyAlgorithm(spacing, altitude);
List<Point> path = mower.generatePath(subAreas.get(0));
```

---

## API Reference

For a complete list of classes and methods, see the [Full API Reference](https://fleetcoreplatform.github.io/FleetCoreLib).
