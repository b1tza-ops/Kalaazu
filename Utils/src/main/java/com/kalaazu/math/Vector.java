package com.kalaazu.math;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.random.RandomGenerator;

/**
 * Represents a 2D vector with integer components (x, y).
 *
 * This class is immutable; all modification methods return a new `Vector` instance
 * rather than changing the state of the current one. It provides a comprehensive
 * set of mathematical operations for vector manipulation, such as addition,
 * subtraction, scaling, and distance calculations.
 *
 * @example
 * ```java
 * Vector v1 = new Vector(10, 20);
 * Vector v2 = new Vector(5, 5);
 * Vector sum = v1.add(v2); // sum is a new Vector(15, 25)
 * System.out.println("Distance: " + v1.dst(v2));
 * ```
 *
 * @author manulaiko
 */
@Data
@AllArgsConstructor
public class Vector implements Serializable {
    public static final Vector ZERO = new Vector(0, 0);
    public static final Vector MARGIN = new Vector(1000, 1000);

    @Serial
    private static final long serialVersionUID = 913902788239530931L;

    /**
     * Generates a random vector within the bounds of a given `VectorRegion`.
     *
     * @param limit The region to generate the vector in.
     *
     * @return A new `Vector` with random coordinates within the specified region.
     *
     * @example
     * ```java
     * VectorRegion region = new VectorRegion(new Vector(0, 0), new Vector(100, 100));
     * Vector randomVec = Vector.random(region);
     * ```
     *
     * @see com.kalaazu.math.VectorRegion
     */
    public static Vector random(VectorRegion limit) {
        return random(limit.topLeft(), limit.bottomRight());
    }

    /**
     * Generates a random vector within a rectangular area defined by two corner vectors.
     *
     * @param from The starting corner of the bounding box (inclusive).
     * @param limit The ending corner of the bounding box (exclusive).
     *
     * @return A new `Vector` with random coordinates.
     *
     */
    public static Vector random(Vector from, Vector limit) {
        var r = RandomGenerator.getDefault();

        var x = r.nextInt(from.getX(), limit.getX());
        var y = r.nextInt(from.getY(), limit.getY());

        return new Vector(x, y);
    }

    /**
     * A static utility method to subtract one vector from another.
     *
     * @param from The vector to subtract from.
     * @param to   The vector to subtract.
     *
     * @return A new `Vector` representing the result of `from - to`.
     *
     * @example ```java
     * Vector v1 = new Vector(10, 10);
     * Vector v2 = new Vector(3, 7);
     * Vector result = Vector.sub(v1, v2); // result is (7, 3)
     * ```
     */
    public static Vector sub(Vector from, Vector to) {
        return from.sub(to);
    }

    /**
     * Subtracts the given vector from this vector.
     *
     * @param v The vector to subtract.
     *
     * @return A new `Vector` representing the result of the subtraction.
     *
     * @example
     * ```java
     * Vector v1 = new Vector(10, 10);
     * Vector v2 = new Vector(3, 7);
     * Vector result = v1.sub(v2); // result is (7, 3)
     * ```
     */
    public Vector sub(Vector v) {
        return new Vector(this.x - v.x, this.y - v.y);
    }

    /**
     * Calculates the magnitude (length) of a vector defined by its components.
     *
     * @param x The x-component.
     * @param y The y-component.
     *
     * @return The length of the vector.
     *
     * @example ```java
     * float length = Vector.len(3, 4); // length is 5.0f
     * ```
     */
    public static float len(float x, float y) {
        return (float) Math.sqrt(x * x + y * y);
    }

    /**
     * Calculates the squared magnitude (length) of a vector.
     * This is faster than `len()` as it avoids a square root, making it ideal for comparisons.
     *
     * @param x The x-component.
     * @param y The y-component.
     *
     * @return The squared length of the vector.
     *
     * @example
     * ```java
     * float lengthSq = Vector.len2(3, 4); // lengthSq is 25.0f
     * ```
     */
    public static float len2(float x, float y) {
        return x * x + y * y;
    }

    /**
     * Calculates the dot product of two vectors defined by their components.
     *
     * @param x1 The x-component of the first vector.
     * @param y1 The y-component of the first vector.
     * @param x2 The x-component of the second vector.
     * @param y2 The y-component of the second vector.
     *
     * @return The dot product.
     *
     * @example
     * ```java
     * float dotProduct = Vector.dot(1, 2, 3, 4); // dotProduct is 1*3 + 2*4 = 11.0f
     * ```
     */
    public static float dot(float x1, float y1, float x2, float y2) {
        return x1 * x2 + y1 * y2;
    }

    /**
     * Calculates the distance between two points.
     *
     * @param x1 The x-coordinate of the first point.
     * @param y1 The y-coordinate of the first point.
     * @param x2 The x-coordinate of the second point.
     * @param y2 The y-coordinate of the second point.
     *
     * @return The distance between the two points.
     *
     * @example
     * ```java
     * float distance = Vector.dst(0, 0, 3, 4); // distance is 5.0f
     * ```
     */
    public static float dst(float x1, float y1, float x2, float y2) {
        final float x_d = x2 - x1;
        final float y_d = y2 - y1;

        return (float) Math.sqrt(x_d * x_d + y_d * y_d);
    }

    /**
     * Calculates the squared distance between two points.
     * This is faster than `dst()` as it avoids a square root, making it ideal for comparisons.
     *
     * @param x1 The x-coordinate of the first point.
     * @param y1 The y-coordinate of the first point.
     * @param x2 The x-coordinate of the second point.
     * @param y2 The y-coordinate of the second point.
     *
     * @return The squared distance between the two points.
     *
     * @example
     * ```java
     * float distanceSq = Vector.dst2(0, 0, 3, 4); // distanceSq is 25.0f
     * ```
     */
    public static float dst2(float x1, float y1, float x2, float y2) {
        final float x_d = x2 - x1;
        final float y_d = y2 - y1;

        return x_d * x_d + y_d * y_d;
    }

    /**
     * Generates a random vector on the circumference of a circle.
     * The resulting vector's coordinates are adjusted if they exceed the specified limit,
     * which may result in a point not perfectly on the circumference.
     *
     * @param center The center of the circle.
     * @param radius The radius of the circle.
     * @param limit A limiting vector for the coordinates.
     *
     * @return A new `Vector` representing a point on or near the circle's circumference.
     *
     * @example
     * ```java
     * Vector randomPoint = Vector.randomRadius(new Vector(100, 100), 50, new Vector(200, 200));
     * ```
     */
    public static Vector randomRadius(Vector center, int radius, Vector limit) {
        var dest = Vector.random(limit);
        var t = dest.angle();

        var x = radius * Math.cos(t) + center.getX();
        var y = radius * Math.sin(t) + center.getY();

        if (x > limit.getX()) {
            x = center.getX() - x * 2;
        }
        if (y > limit.getY()) {
            y = center.getY() - y * 2;
        }

        return new Vector((int) x, (int) y);
    }

    /**
     * Generates a random vector between `(0,0)` and the given limit vector.
     *
     * @param limit The exclusive upper bound for the random coordinates.
     *
     * @return A new `Vector` with random coordinates.
     *
     * @example
     * ```java
     * Vector randomVec = Vector.random(new Vector(800, 600));
     * ```
     */
    public static Vector random(Vector limit) {
        return random(ZERO, limit);
    }

    /**
     * Calculates the angle of this vector in degrees.
     * The angle is measured counter-clockwise from the positive x-axis, in the range [0, 360).
     *
     * @return The angle in degrees.
     *
     */
    public float angle() {
        float angle = (float) Math.atan2(y, x) * MathUtils.radiansToDegrees;
        if (angle < 0) {
            angle += 360;
        }

        return angle;
    }

    private final int x;
    private final int y;


    /**
     * Constructs a vector from a comma-separated string (e.g., "100,200").
     *
     * @param s The string containing the coordinates.
     *
     * @throws NumberFormatException if the string is not formatted correctly.
     * @example ```java
     * Vector v = new Vector("100,200");
     * ```
     */
    public Vector(String s) {
        String[] coordinates = s.split(",");

        this.x = Integer.parseInt(coordinates[0]);
        this.y = Integer.parseInt(coordinates[1]);
    }

    /**
     * Constructs a vector from a `long` value.
     * The upper 32 bits of the long are used for the x-coordinate, and the lower 32 bits for the y-coordinate.
     *
     * @param l The long value to decode.
     *
     * @example ```java
     * long packed = ((long)100 << 32) | (200 & 0xffffffffL);
     * Vector v = new Vector(packed); // v is (100, 200)
     * ```
     */
    public Vector(Long l) {
        this.x = (int) (l >> 32);
        this.y = l.intValue();
    }

    /**
     * Encodes this vector's coordinates into a single `long` value.
     * The x-coordinate is stored in the upper 32 bits, and the y-coordinate in the lower 32 bits.
     *
     * @return The packed long representation of this vector.
     *
     * @example ```java
     * Vector v = new Vector(100, 200);
     * long packed = v.toLong();
     * ```
     */
    public long toLong() {
        return ((long) this.x << 32) | (this.y & 0xffffffffL);
    }

    /**
     * Creates a copy of this vector.
     *
     * @return A new `Vector` instance with the same x and y values.
     *
     */
    public Vector cpy() {
        return new Vector(this.x, this.y);
    }

    /**
     * Subtracts the given coordinates from this vector.
     *
     * @param x The x-coordinate to subtract.
     * @param y The y-coordinate to subtract.
     *
     * @return A new `Vector` representing the result.
     *
     */
    public Vector sub(int x, int y) {
        return new Vector(this.x - x, this.y - y);
    }

    /**
     * Normalizes this vector, creating a new unit vector with the same direction.
     * If the vector has a length of zero, a zero vector is returned.
     *
     * @return A new normalized `Vector`.
     *
     */
    public Vector nor() {
        var len = len();
        var x = this.x;
        var y = this.y;

        if (len != 0) {
            x /= len;
            y /= len;
        }

        return new Vector(x, y);
    }

    /**
     * Calculates the magnitude (length) of this vector.
     *
     * @return The length of the vector as an integer.
     *
     */
    public int len() {
        return (int) Math.sqrt(x * x + y * y);
    }

    /**
     * Calculates the dot product between this vector and another specified by its components.
     *
     * @param ox The x-component of the other vector.
     * @param oy The y-component of the other vector.
     *
     * @return The dot product.
     *
     */
    public float dot(float ox, float oy) {
        return x * ox + y * oy;
    }

    /**
     * Scales this vector by a single scalar value.
     * Both x and y components are multiplied by the scalar.
     *
     * @param scalar The value to scale by.
     *
     * @return A new scaled `Vector`.
     *
     */
    public Vector scl(float scalar) {
        return scl(scalar, scalar);
    }

    /**
     * Scales this vector by different values for the x and y components.
     *
     * @param x The value to scale the x-component by.
     * @param y The value to scale the y-component by.
     *
     * @return A new scaled `Vector`.
     *
     */
    public Vector scl(float x, float y) {
        return new Vector((int) (this.x * x), (int) (this.y * y));
    }

    /**
     * Scales this vector by the components of another vector (component-wise multiplication).
     *
     * @param v The vector to scale by.
     *
     * @return A new scaled `Vector`.
     *
     */
    public Vector scl(Vector v) {
        return new Vector(this.x * v.x, this.y * v.y);
    }

    /**
     * Performs a multiply-add operation: `this + (vec * scalar)`.
     *
     * @param vec The vector to be scaled.
     * @param scalar The scalar to multiply `vec` by.
     *
     * @return A new `Vector` with the result.
     *
     */
    public Vector mulAdd(Vector vec, float scalar) {
        return this.add(vec.scl((int) scalar));
    }

    /**
     * Adds the given vector to this vector.
     *
     * @param v The vector to add.
     *
     * @return A new `Vector` representing the sum.
     *
     */
    public Vector add(Vector v) {
        return new Vector(this.x + v.x, this.y + v.y);
    }

    /**
     * Scales this vector by an integer scalar value.
     *
     * @param scalar The integer value to scale by.
     *
     * @return A new scaled `Vector`.
     *
     */
    public Vector scl(int scalar) {
        return new Vector(this.x * scalar, this.y * scalar);
    }

    /**
     * Performs a multiply-add operation with two vectors: `this + (vec * mulVec)`.
     * The multiplication is component-wise.
     *
     * @param vec    The first vector in the multiplication.
     * @param mulVec The second vector in the multiplication.
     *
     * @return A new `Vector` with the result.
     *
     */
    public Vector mulAdd(Vector vec, Vector mulVec) {
        var x = vec.x * mulVec.x;
        var y = vec.y * mulVec.y;

        return this.add(x, y);
    }

    /**
     * Adds the given coordinates to this vector.
     *
     * @param x The x-coordinate to add.
     * @param y The y-coordinate to add.
     *
     * @return A new `Vector` representing the sum.
     *
     */
    public Vector add(int x, int y) {
        return new Vector(this.x + x, this.y + y);
    }

    /**
     * Calculates the distance between this vector and another vector.
     *
     * @param v The other vector.
     *
     * @return The distance.
     *
     */
    public float dst(Vector v) {
        final float x_d = v.x - x;
        final float y_d = v.y - y;

        return (float) Math.sqrt(x_d * x_d + y_d * y_d);
    }

    /**
     * Calculates the distance between this vector and a point defined by coordinates.
     *
     * @param x The x-coordinate of the point.
     * @param y The y-coordinate of the point.
     *
     * @return The distance.
     */
    public float dst(float x, float y) {
        final float x_d = x - this.x;
        final float y_d = y - this.y;

        return (float) Math.sqrt(x_d * x_d + y_d * y_d);
    }

    /**
     * Calculates the squared distance between this vector and another vector.
     * Faster than `dst()` as it avoids a square root.
     *
     * @param v The other vector.
     *
     * @return The squared distance.
     */
    public float dst2(Vector v) {
        final float x_d = v.x - x;
        final float y_d = v.y - y;

        return x_d * x_d + y_d * y_d;
    }

    /**
     * Calculates the squared distance between this vector and a point defined by coordinates.
     * Faster than `dst()` as it avoids a square root.
     *
     * @param x The x-coordinate of the point.
     * @param y The y-coordinate of the point.
     *
     * @return The squared distance.
     */
    public float dst2(float x, float y) {
        final float x_d = x - this.x;
        final float y_d = y - this.y;

        return x_d * x_d + y_d * y_d;
    }

    /**
     * Limits the magnitude of this vector to a maximum value.
     *
     * @param limit The maximum length.
     *
     * @return A new `Vector` with the limited magnitude, or this vector if it's already within the limit.
     *
     */
    public Vector limit(float limit) {
        return limit2(limit * limit);
    }

    /**
     * Limits the squared magnitude of this vector to a maximum value.
     *
     * @param limit2 The maximum squared length.
     *
     * @return A new `Vector` with the limited magnitude, or this vector if it's already within the limit.
     */
    public Vector limit2(float limit2) {
        var len2 = len2();
        if (len2 > limit2) {
            return scl((int) Math.sqrt(limit2 / len2));
        }

        return this;
    }

    /**
     * Calculates the squared magnitude (length) of this vector.
     *
     * @return The squared length.
     *
     */
    public float len2() {
        return x * x + y * y;
    }

    /**
     * Clamps this vector's magnitude to be within a given range.
     *
     * @param min The minimum length.
     * @param max The maximum length.
     *
     * @return A new `Vector` with the clamped magnitude, or this vector if it's already in range.
     */
    public Vector clamp(float min, float max) {
        final float len2 = len2();
        if (len2 == 0f) {
            return this;
        }

        float max2 = max * max;
        if (len2 > max2) {
            return scl((int) Math.sqrt(max2 / len2));
        }

        float min2 = min * min;
        if (len2 < min2) {
            return scl((int) Math.sqrt(min2 / len2));
        }

        return this;
    }

    /**
     * Sets the magnitude of this vector to a new value.
     *
     * @param len The new length.
     *
     * @return A new `Vector` with the specified length.
     *
     */
    public Vector setLength(float len) {
        return setLength2(len * len);
    }

    /**
     * Sets the squared magnitude of this vector to a new value.
     *
     * @param len2 The new squared length.
     *
     * @return A new `Vector` with the specified squared length.
     */
    public Vector setLength2(float len2) {
        float oldLen2 = len2();
        if (oldLen2 == 0 || oldLen2 == len2) {
            return this;
        }

        return scl((int) Math.sqrt(len2 / oldLen2));
    }

    /**
     * Returns a string representation of the vector in "x,y" format.
     *
     * @return The string representation.
     *
     */
    public String toString() {
        return x + "," + y;
    }

    /**
     * Parses a string to create a `Vector`.
     * The string must be in the format "(x,y)".
     *
     * @param v The string to parse.
     *
     * @return The new `Vector`.
     *
     * @throws RuntimeException if the string is malformed.
     */
    public Vector fromString(String v) {
        int s = v.indexOf(',', 1);
        if (s != -1 && v.charAt(0) == '(' && v.charAt(v.length() - 1) == ')') {
            try {
                var x = Integer.parseInt(v.substring(1, s));
                var y = Integer.parseInt(v.substring(s + 1, v.length() - 1));

                return new Vector(x, y);
            } catch (NumberFormatException ex) {
                // Throw a GdxRuntimeException
            }
        }

        throw new RuntimeException("Malformed Vector2: " + v);
    }

    /**
     * Multiplies this vector by a 3x3 matrix.
     *
     * @param mat The matrix to multiply by.
     *
     * @return A new transformed `Vector`.
     */
    public Vector mul(Matrix3 mat) {
        var x = (int) (this.x * mat.val[0] + this.y * mat.val[3] + mat.val[6]);
        var y = (int) (this.x * mat.val[1] + this.y * mat.val[4] + mat.val[7]);

        return new Vector(x, y);
    }

    /**
     * Calculates the 2D cross product between this vector and another vector specified by components.
     *
     * @param x The x-component of the other vector.
     * @param y The y-component of the other vector.
     *
     * @return The cross product.
     */
    public float crs(float x, float y) {
        return this.x * y - this.y * x;
    }

    /**
     * Calculates the angle in degrees between this vector and a reference vector.
     *
     * @param reference The reference vector.
     *
     * @return The angle in degrees.
     */
    public float angle(Vector reference) {
        return (float) Math.atan2(crs(reference), dot(reference)) * MathUtils.radiansToDegrees;
    }

    /**
     * Calculates the 2D cross product between this vector and another vector.
     *
     * @param v The other vector.
     *
     * @return The cross product.
     */
    public float crs(Vector v) {
        return this.x * v.y - this.y * v.x;
    }

    /**
     * Calculates the dot product between this vector and another vector.
     *
     * @param v The other vector.
     *
     * @return The dot product.
     */
    public float dot(Vector v) {
        return x * v.x + y * v.y;
    }

    /**
     * Calculates the angle of this vector in radians.
     *
     * @return The angle in radians.
     */
    public float angleRad() {
        return (float) Math.atan2(y, x);
    }

    /**
     * Calculates the angle in radians between this vector and a reference vector.
     *
     * @param reference The reference vector.
     *
     * @return The angle in radians.
     */
    public float angleRad(Vector reference) {
        return (float) Math.atan2(crs(reference), dot(reference));
    }

    /**
     * Sets the angle of this vector to the given angle in degrees.
     *
     * @param degrees The new angle in degrees.
     *
     * @return A new `Vector` with the updated angle.
     */
    public Vector setAngle(float degrees) {
        return setAngleRad(degrees * MathUtils.degreesToRadians);
    }

    /**
     * Sets the angle of this vector to the given angle in radians.
     *
     * @param radians The new angle in radians.
     *
     * @return A new `Vector` with the updated angle.
     */
    public Vector setAngleRad(float radians) {
        return new Vector(len(), 0).rotateRad(radians);
    }

    /**
     * Rotates this vector by the given angle in radians.
     *
     * @param radians The angle in radians.
     *
     * @return A new rotated `Vector`.
     */
    public Vector rotateRad(float radians) {
        var cos = (int) Math.cos(radians);
        var sin = (int) Math.sin(radians);

        var x = this.x * cos - this.y * sin;
        var y = this.x * sin + this.y * cos;

        return new Vector(x, y);
    }

    /**
     * Rotates this vector around a reference point by a given angle in degrees.
     *
     * @param reference The point to rotate around.
     * @param degrees The angle in degrees.
     *
     * @return A new rotated `Vector`.
     */
    public Vector rotateAround(Vector reference, float degrees) {
        return this.sub(reference)
                .rotate(degrees)
                .add(reference);
    }

    /**
     * Rotates this vector by the given angle in degrees.
     *
     * @param degrees The angle in degrees.
     *
     * @return A new rotated `Vector`.
     */
    public Vector rotate(float degrees) {
        return rotateRad(degrees * MathUtils.degreesToRadians);
    }

    /**
     * Rotates this vector around a reference point by a given angle in radians.
     *
     * @param reference The point to rotate around.
     * @param radians   The angle in radians.
     *
     * @return A new rotated `Vector`.
     */
    public Vector rotateAroundRad(Vector reference, float radians) {
        return this.sub(reference)
                .rotateRad(radians)
                .add(reference);
    }

    /**
     * Rotates this vector by 90 degrees in a specified direction.
     *
     * @param dir The direction to rotate (>= 0 for counter-clockwise, < 0 for clockwise).
     *
     * @return A new rotated `Vector`.
     */
    @SuppressWarnings("SuspiciousNameCombination")
    public Vector rotate90(int dir) {
        var x = this.x;
        var y = this.y;

        if (dir >= 0) {
            x = -y;
            y = this.x;
        } else {
            x = y;
            y = -this.x;
        }

        return new Vector(x, y);
    }

    /**
     * Linearly interpolates between this vector and a target vector using a specific interpolation function.
     *
     * @param target The target vector.
     * @param alpha The interpolation alpha value, typically in the range [0,1].
     * @param interpolation The interpolation function to apply to alpha.
     *
     * @return A new interpolated `Vector`.
     */
    public Vector interpolate(Vector target, float alpha, Interpolation interpolation) {
        return lerp(target, interpolation.apply(alpha));
    }

    /**
     * Linearly interpolates between this vector and a target vector.
     *
     * @param target The target vector.
     * @param alpha  The interpolation alpha value, typically in the range [0,1].
     *
     * @return A new interpolated `Vector`.
     */
    public Vector lerp(Vector target, float alpha) {
        var invAlpha = 1.0 - alpha;

        var x = (int) ((this.x * invAlpha) + (target.x * alpha));
        var y = (int) ((this.y * invAlpha) + (target.y * alpha));

        return new Vector(x, y);
    }

    /**
     * Creates a new unit vector pointing in a random direction.
     *
     * @return A new random unit `Vector`.
     */
    public Vector setToRandomDirection() {
        float theta = MathUtils.random(0f, MathUtils.PI2);

        return new Vector((int) MathUtils.cos(theta), (int) MathUtils.sin(theta));
    }

    /**
     * Compares this vector with another for equality using a default epsilon.
     *
     * @param other The other vector.
     *
     * @return `true` if the vectors are approximately equal.
     */
    public boolean epsilonEquals(final Vector other) {
        return epsilonEquals(other, MathUtils.FLOAT_ROUNDING_ERROR);
    }

    /**
     * Compares this vector with another for equality using a specified epsilon.
     *
     * @param other   The other vector.
     * @param epsilon The tolerance for the comparison.
     *
     * @return `true` if the vectors are approximately equal.
     */
    public boolean epsilonEquals(Vector other, float epsilon) {
        if (other == null) {
            return false;
        }
        if (Math.abs(other.x - x) > epsilon) {
            return false;
        }
        return !(Math.abs(other.y - y) > epsilon);
    }

    /**
     * Compares this vector with coordinates for equality using a default epsilon.
     *
     * @param x The x-coordinate to compare.
     * @param y The y-coordinate to compare.
     *
     * @return `true` if the components are approximately equal.
     */
    public boolean epsilonEquals(float x, float y) {
        return epsilonEquals(x, y, MathUtils.FLOAT_ROUNDING_ERROR);
    }

    /**
     * Compares this vector with coordinates for equality using a specified epsilon.
     *
     * @param x       The x-coordinate to compare.
     * @param y       The y-coordinate to compare.
     * @param epsilon The tolerance for the comparison.
     *
     * @return `true` if the components are approximately equal.
     */
    public boolean epsilonEquals(float x, float y, float epsilon) {
        if (Math.abs(x - this.x) > epsilon) {
            return false;
        }
        return !(Math.abs(y - this.y) > epsilon);
    }

    /**
     * Checks if this is a unit vector (length is approximately 1).
     *
     * @return `true` if this is a unit vector.
     */
    public boolean isUnit() {
        return isUnit(0.000000001f);
    }

    /**
     * Checks if this is a unit vector within a given tolerance.
     *
     * @param margin The tolerance.
     *
     * @return `true` if this is a unit vector.
     */
    public boolean isUnit(final float margin) {
        return Math.abs(len2() - 1f) < margin;
    }

    /**
     * Checks if this is a zero vector (both components are 0).
     *
     * @return `true` if this is a zero vector.
     */
    public boolean isZero() {
        return x == 0 && y == 0;
    }

    /**
     * Checks if this vector is near zero (length is less than a margin).
     *
     * @param margin The tolerance.
     *
     * @return `true` if the vector's length is close to zero.
     */
    public boolean isZero(final float margin) {
        return len2() < margin;
    }

    /**
     * Checks if this vector is collinear with another vector and points in the same direction.
     *
     * @param other The other vector.
     * @param epsilon The tolerance for the on-line check.
     *
     * @return `true` if the vectors are collinear.
     */
    public boolean isCollinear(Vector other, float epsilon) {
        return isOnLine(other, epsilon) && dot(other) > 0f;
    }

    /**
     * Checks if this vector is on the same line as another vector.
     *
     * @param other The other vector.
     * @param epsilon The tolerance for the check.
     *
     * @return `true` if the vectors are on the same line.
     */
    public boolean isOnLine(Vector other, float epsilon) {
        return MathUtils.isZero(x * other.y - y * other.x, epsilon);
    }

    /**
     * Checks if this vector is collinear with another vector and points in the same direction.
     *
     * @param other The other vector.
     *
     * @return `true` if the vectors are collinear.
     */
    public boolean isCollinear(Vector other) {
        return isOnLine(other) && dot(other) > 0f;
    }

    /**
     * Checks if this vector is on the same line as another vector.
     *
     * @param other The other vector.
     *
     * @return `true` if the vectors are on the same line.
     */
    public boolean isOnLine(Vector other) {
        return MathUtils.isZero(x * other.y - y * other.x);
    }

    /**
     * Checks if this vector is collinear with another vector and points in the opposite direction.
     *
     * @param other   The other vector.
     * @param epsilon The tolerance for the on-line check.
     *
     * @return `true` if the vectors are collinear and opposite.
     */
    public boolean isCollinearOpposite(Vector other, float epsilon) {
        return isOnLine(other, epsilon) && dot(other) < 0f;
    }

    /**
     * Checks if this vector is collinear with another vector and points in the opposite direction.
     *
     * @param other The other vector.
     *
     * @return `true` if the vectors are collinear and opposite.
     */
    public boolean isCollinearOpposite(Vector other) {
        return isOnLine(other) && dot(other) < 0f;
    }

    /**
     * Checks if this vector is perpendicular to another vector.
     *
     * @param vector The other vector.
     *
     * @return `true` if they are perpendicular.
     */
    public boolean isPerpendicular(Vector vector) {
        return MathUtils.isZero(dot(vector));
    }

    /**
     * Checks if this vector is perpendicular to another vector within a tolerance.
     *
     * @param vector The other vector.
     * @param epsilon The tolerance.
     *
     * @return `true` if they are perpendicular.
     */
    public boolean isPerpendicular(Vector vector, float epsilon) {
        return MathUtils.isZero(dot(vector), epsilon);
    }

    /**
     * Checks if this vector has the same direction as another vector.
     *
     * @param vector The other vector.
     *
     * @return `true` if they have the same general direction.
     */
    public boolean hasSameDirection(Vector vector) {
        return dot(vector) > 0;
    }

    /**
     * Checks if this vector has the opposite direction of another vector.
     *
     * @param vector The other vector.
     *
     * @return `true` if they have opposite general directions.
     */
    public boolean hasOppositeDirection(Vector vector) {
        return dot(vector) < 0;
    }

    /**
     * Divides this vector's components by an integer value.
     *
     * @param v The divisor.
     *
     * @return A new `Vector` with the result, or this vector if the divisor is 0.
     */
    public Vector div(int v) {
        if (v == 0) {
            return this;
        }

        var x = this.x / v;
        var y = this.y / v;

        return new Vector(x, y);
    }

    /**
     * Subtracts the default margin vector from this vector.
     *
     * @return A new `Vector` with the result.
     */
    public Vector subMargin() {
        return this.sub(MARGIN);
    }

    /**
     * Adds the default margin vector to this vector.
     *
     * @return A new `Vector` with the result.
     */
    public Vector addMargin() {
        return this.add(MARGIN);
    }
}
