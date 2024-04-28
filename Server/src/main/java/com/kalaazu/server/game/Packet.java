package com.kalaazu.server.game;

import lombok.SneakyThrows;

/**
 * Packet interface.
 * =================
 *
 * Interface for the incoming packets from main.swf.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public interface Packet {
    /**
     * Returns a new instance of a packet for the current game version.
     *
     * @return Empty game version packet.
     */
    static Packet empty() {
        return GameServer.INSTANCE.getEmptyPacket();
    }

    @SneakyThrows
    void writeString(String argument);

    @SneakyThrows
    String readString();

    @SneakyThrows
    void writeInt(int i);

    @SneakyThrows
    int readInt();

    @SneakyThrows
    void writeShort(short s);

    @SneakyThrows
    void writeShort(int s);

    @SneakyThrows
    short readShort();

    @SneakyThrows
    void writeLong(long l);

    @SneakyThrows
    long readLong();

    @SneakyThrows
    void writeBoolean(boolean b);

    @SneakyThrows
    boolean readBoolean();

    @SneakyThrows
    void writeByte(byte b);

    @SneakyThrows
    byte readByte();

    @SneakyThrows
    void writeDouble(double d);

    @SneakyThrows
    double readDouble();

    @SneakyThrows
    void writeFloat(float f);

    @SneakyThrows
    double readFloat();

    @SneakyThrows
    void reset();

    @SneakyThrows
    void jump(int idx);

    byte[] getBytes();

    int getSize();
}
