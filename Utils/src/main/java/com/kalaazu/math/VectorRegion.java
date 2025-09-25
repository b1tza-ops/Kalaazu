package com.kalaazu.math;

/**
 * Represents a rectangular region in a 2D space defined by two vectors.
 *
 * This class encapsulates a rectangular area using a top-left and a bottom-right
 * `Vector` to define its boundaries. It provides utility methods for checking if a
 * point is within the region, clamping a point to the region's bounds, and
 * creating a new region with an added margin.
 *
 * @author manulaiko <manulaiko@gmail.com>
 * @example ```java
 * Vector topLeft = new Vector(0, 0);
 * Vector bottomRight = new Vector(21000, 13100);
 * VectorRegion mapBounds = new VectorRegion(topLeft, bottomRight);
 *
 * Vector playerPosition = new Vector(1000, 2500);
 * if (mapBounds.isWithin(playerPosition)) {
 * System.out.println("Player is within the map bounds.");
 * }
 * ```
 * @see Vector
 */
public record VectorRegion(Vector topLeft, Vector bottomRight) {
    /**
     * Constructs a `VectorRegion` by parsing a string representation.
     *
     * The expected format is two vector strings separated by a pipe character (`|`),
     * where each vector string is a comma-separated pair of coordinates (e.g., "x1,y1|x2,y2").
     *
     * @param region The string representation of the region.
     *
     * @example ```java
     * String regionData = "0,0|1024,768";
     * VectorRegion screenRegion = new VectorRegion(regionData);
     * ```
     */
    public VectorRegion(String region) {
        var str = region.split("\\|");

        this(new Vector(str[0]), new Vector(str[1]));
    }

    /**
     * Checks if a given vector is located within the boundaries of this region.
     *
     * The check is inclusive, meaning a vector lying on the edge of the region
     * is considered to be within it.
     *
     * @param vector Vector to check.
     *
     * @return Whether vector is in this region or not.
     *
     * @example ```java
     * VectorRegion region = new VectorRegion(new Vector(0, 0), new Vector(100, 100));
     * boolean isInside = region.isWithin(new Vector(50, 50)); // true
     * boolean isOutside = region.isWithin(new Vector(150, 50)); // false
     * ```
     */
    public boolean isWithin(Vector vector) {
        var x = vector.getX();
        var y = vector.getY();
        var tX = topLeft.getX();
        var tY = topLeft.getY();
        var bX = bottomRight.getX();
        var bY = bottomRight.getY();

        return (x >= tX && x <= bX) && (y >= tY && x <= bY);
    }

    /**
     * Clamps a vector to the boundaries of this region.
     *
     * If the vector is already inside the region, the original vector is returned.
     * If it is outside, a new `Vector` is created with its coordinates adjusted
     * to the nearest point on the region's edge.
     *
     * @param vector The vector to clamp.
     *
     * @return A new `Vector` instance that is guaranteed to be within the region.
     *
     * @example ```java
     * VectorRegion bounds = new VectorRegion(new Vector(0, 0), new Vector(100, 100));
     * Vector outsidePoint = new Vector(150, -20);
     * Vector clampedPoint = bounds.clamp(outsidePoint); // returns a new Vector(100, 0)
     * ```
     */
    public Vector clamp(Vector vector) {
        var x = Math.max(topLeft.getX(), Math.min(bottomRight.getX(), vector.getX()));
        var y = Math.max(topLeft.getY(), Math.min(bottomRight.getY(), vector.getY()));

        if (x == vector.getX() && y == vector.getY()) {
            return vector;
        }

        return new Vector(x, y);
    }

    /**
     * Creates a new `VectorRegion` with an inward margin applied.
     *
     * This method applies a positive margin to the top-left corner and a negative
     * margin to the bottom-right corner, effectively shrinking the region.
     *
     * @return A new, smaller `VectorRegion`.
     *
     * @example ```java
     * VectorRegion original = new VectorRegion(new Vector(0, 0), new Vector(100, 100));
     * VectorRegion withMargin = original.margin(); // e.g., new VectorRegion(new Vector(10, 10), new Vector(90, 90))
     * ```
     * @see Vector#addMargin()
     * @see Vector#subMargin()
     */
    public VectorRegion margin() {
        return new VectorRegion(topLeft.addMargin(), bottomRight.subMargin());
    }

    /**
     * Returns a string representation of the region.
     * The format is "topLeft.toString()|bottomRight.toString()".
     */
    @Override
    public String toString() {
        return topLeft + "|" + bottomRight;
    }
}
