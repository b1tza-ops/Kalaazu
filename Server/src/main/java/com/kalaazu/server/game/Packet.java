package com.kalaazu.server.game;

/**
 * An interface representing a data packet for communication between the server and the game client.
 * It provides a standardized way to read and write various data types (integers, strings, booleans, etc.)
 * from/to a byte stream. This abstraction is crucial for handling different game versions and their
 * specific packet structures.
 *
 * @example
 * ```java
 * // Obtain a new, empty packet instance for the current game version.
 * Packet myPacket = Packet.empty();
 *
 * // Write some data to the packet.
 * myPacket.writeInt(12345);
 * myPacket.writeString("Hello, World!");
 *
 * // The packet is now ready to be sent or processed.
 * byte[] data = myPacket.getBytes();
 * ```
 *
 * @author manulaiko
 */
public interface Packet {
    /**
     * A static factory method that returns a new, empty `Packet` instance.
     * The specific implementation of the packet is determined by the currently configured
     * game version within the `GameServer`. This is the preferred way to create new packets.
     *
     * @return An empty `Packet` instance appropriate for the current game version.
     *
     * @example
     * ```java
     * Packet newPacket = Packet.empty();
     * ```
     *
     * @see com.kalaazu.server.game.GameServer#getEmptyPacket()
     */
    static Packet empty() {
        return GameServer.getInstance().getEmptyPacket();
    }

    /**
     * Writes a string value to the packet's underlying byte buffer.
     *
     * @param argument The string to be written.
     *
     * @example ```java
     * Packet packet = Packet.empty();
     * packet.writeString("player_name");
     * ```
     */
    void writeString(String argument);

    /**
     * Reads a string value from the packet's current position.
     *
     * @return The string read from the buffer.
     *
     * @example
     * ```java
     * String username = incomingPacket.readString();
     * ```
     */
    String readString();

    /**
     * Writes a 32-bit integer value to the packet's underlying byte buffer.
     *
     * @param i The integer to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeInt(1024);
     * ```
     */
    void writeInt(int i);

    /**
     * Reads a 32-bit integer value from the packet's current position.
     *
     * @return The integer read from the buffer.
     *
     * @example
     * ```java
     * int score = incomingPacket.readInt();
     * ```
     */
    int readInt();

    /**
     * Writes a 16-bit short value to the packet's underlying byte buffer.
     *
     * @param s The short to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeShort((short) 255);
     * ```
     */
    void writeShort(short s);

    /**
     * Writes an integer value as a 16-bit short to the packet's underlying byte buffer.
     * This is an overload for convenience, casting the integer to a short.
     *
     * @param s The integer to be written as a short.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeShort(255); // Implicitly cast to short
     * ```
     */
    void writeShort(int s);

    /**
     * Reads a 16-bit short value from the packet's current position.
     *
     * @return The short read from the buffer.
     *
     * @example
     * ```java
     * short entityType = incomingPacket.readShort();
     * ```
     */
    short readShort();

    /**
     * Writes a 64-bit long value to the packet's underlying byte buffer.
     *
     * @param l The long to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeLong(1234567890123L);
     * ```
     */
    void writeLong(long l);

    /**
     * Reads a 64-bit long value from the packet's current position.
     *
     * @return The long read from the buffer.
     *
     * @example
     * ```java
     * long timestamp = incomingPacket.readLong();
     * ```
     */
    long readLong();

    /**
     * Writes a boolean value to the packet's underlying byte buffer.
     *
     * @param b The boolean to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeBoolean(true);
     * ```
     */
    void writeBoolean(boolean b);

    /**
     * Reads a boolean value from the packet's current position.
     *
     * @return The boolean read from the buffer.
     *
     * @example
     * ```java
     * boolean isPremium = incomingPacket.readBoolean();
     * ```
     */
    boolean readBoolean();

    /**
     * Writes a single byte value to the packet's underlying byte buffer.
     *
     * @param b The byte to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeByte((byte) 1);
     * ```
     */
    void writeByte(byte b);

    /**
     * Reads a single byte value from the packet's current position.
     *
     * @return The byte read from the buffer.
     *
     * @example
     * ```java
     * byte status = incomingPacket.readByte();
     * ```
     */
    byte readByte();

    /**
     * Writes a 64-bit double-precision floating-point value to the packet's underlying byte buffer.
     *
     * @param d The double to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeDouble(3.14159);
     * ```
     */
    void writeDouble(double d);

    /**
     * Reads a 64-bit double-precision floating-point value from the packet's current position.
     *
     * @return The double read from the buffer.
     *
     * @example
     * ```java
     * double coordinate = incomingPacket.readDouble();
     * ```
     */
    double readDouble();

    /**
     * Writes a 32-bit single-precision floating-point value to the packet's underlying byte buffer.
     *
     * @param f The float to be written.
     *
     * @example
     * ```java
     * Packet packet = Packet.empty();
     * packet.writeFloat(9.81f);
     * ```
     */
    void writeFloat(float f);

    /**
     * Reads a 32-bit single-precision floating-point value from the packet's current position.
     * Note: The return type is `double` to maintain consistency with `readDouble`.
     *
     * @return The float read from the buffer, promoted to a double.
     *
     * @example
     * ```java
     * double velocity = incomingPacket.readFloat();
     * ```
     */
    double readFloat();

    /**
     * Resets the packet's internal position to the beginning.
     * This is useful for re-reading a packet that has already been processed.
     *
     * @example
     * ```java
     * packet.readInt(); // Read the first integer
     * packet.reset();   // Go back to the start
     * int firstIntAgain = packet.readInt(); // Read it again
     * ```
     */
    void reset();

    /**
     * Jumps to a specific index (position) within the packet's byte buffer.
     *
     * @param idx The absolute position to jump to.
     *
     * @example
     * ```java
     * // Jump to the 10th byte in the packet
     * packet.jump(10);
     * ```
     */
    void jump(int idx);

    /**
     * Returns the complete content of the packet as a byte array.
     *
     * @return A byte array representing the packet's data.
     *
     * @example
     * ```java
     * byte[] rawData = packet.getBytes();
     * ```
     */
    byte[] getBytes();

    /**
     * Returns the total size of the packet's content in bytes.
     *
     * @return The size of the packet.
     *
     * @example
     * ```java
     * int packetSize = packet.getSize();
     * ```
     */
    int getSize();
}
