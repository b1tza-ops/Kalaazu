package com.kalaazu.server.game.v10;

import lombok.Getter;
import lombok.SneakyThrows;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;

/**
 * Game packet
 * ===========
 * <p>
 * Represents a packet sent/received between the game server and the game client.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public class Packet implements com.kalaazu.server.game.Packet {
    private final DataOutputStream out;
    private final ByteArrayOutputStream baos;

    private DataInputStream in;

    @Getter
    private int size;

    public Packet(byte[] bytes) {
        this();

        this.size = bytes.length;
        this.in = new DataInputStream(new ByteArrayInputStream(bytes));
    }

    /**
     * Server sent packet constructor, initializes the packet with 0
     */
    public Packet() {
        this.baos = new ByteArrayOutputStream();
        this.out = new DataOutputStream(this.baos);
    }

    @Override
    @SneakyThrows
    public void writeString(String argument) {
        out.writeUTF(argument);
    }

    @Override
    @SneakyThrows
    public String readString() {
        return in.readUTF();
    }

    @Override
    @SneakyThrows
    public void writeInt(int i) {
        out.writeInt(i);
    }

    @Override
    @SneakyThrows
    public int readInt() {
        return in.readInt();
    }

    @Override
    @SneakyThrows
    public void writeShort(short s) {
        out.writeShort(s);
    }

    @Override
    @SneakyThrows
    public void writeShort(int s) {
        writeShort((short) s);
    }

    @Override
    @SneakyThrows
    public short readShort() {
        return in.readShort();
    }

    @Override
    @SneakyThrows
    public void writeLong(long l) {
        out.writeLong(l);
    }

    @Override
    @SneakyThrows
    public long readLong() {
        return in.readLong();
    }

    @Override
    @SneakyThrows
    public void writeBoolean(boolean b) {
        out.writeBoolean(b);
    }

    @Override
    @SneakyThrows
    public boolean readBoolean() {
        return in.readBoolean();
    }

    @Override
    @SneakyThrows
    public void writeByte(byte b) {
        out.writeByte(b);
    }

    @Override
    @SneakyThrows
    public byte readByte() {
        return in.readByte();
    }

    @Override
    @SneakyThrows
    public void writeDouble(double d) {
        out.writeDouble(d);
    }

    @Override
    @SneakyThrows
    public double readDouble() {
        return in.readDouble();
    }

    @Override
    @SneakyThrows
    public void writeFloat(float f) {
        out.writeFloat(f);
    }

    @Override
    @SneakyThrows
    public double readFloat() {
        return in.readFloat();
    }

    /**
     * Resets the index to the beginning.
     */
    @Override
    @SneakyThrows
    public void reset() {
        in.reset();
    }

    /**
     * Jumps index to idx.
     * <p>
     * If the given index is bigger than current argument length do nothing.
     *
     * @param idx Index to jump to.
     */
    @Override
    @SneakyThrows
    public void jump(int idx) {
        in.reset();
        in.skip(idx);
    }

    /**
     * Returns the written bytes.
     *
     * @return written bytes.
     */
    @Override
    public byte[] getBytes() {
        return this.baos.toByteArray();
    }
}
