package com.kalaazu.server.game.v4;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Game packet
 * ===========
 * <p>
 * Represents a packet sent/received between the game server and the game client.
 *
 * @author manulaiko
 */
public class Packet implements com.kalaazu.server.game.Packet {
    private final StringBuilder out = new StringBuilder("0");
    private List<String> in = new ArrayList<>();

    private int position = -1;
    private boolean firstWrite = true;

    public Packet(String packet) {
        this.in = Arrays.stream(packet.split("\\|")).toList();
    }

    public Packet() {
    }

    @Override
    public void writeString(String argument) {
        if (!firstWrite) {
            this.out.append('|');
        }
        this.out.append(argument);
        firstWrite = false;
    }

    @Override
    public String readString() {
        this.position++;
        return this.in.get(this.position);
    }

    @Override
    public void writeInt(int i) {
        writeString(Integer.toString(i));
    }

    @Override
    public int readInt() {
        this.position++;
        return Integer.parseInt(this.in.get(this.position));
    }

    @Override
    public void writeShort(short s) {
        writeString(Short.toString(s));
    }

    @Override
    public void writeShort(int s) {
        writeString(Integer.toString(s));
    }

    @Override
    public short readShort() {
        this.position++;
        return Short.parseShort(this.in.get(this.position));
    }

    @Override
    public void writeLong(long l) {
        writeString(Long.toString(l));
    }

    @Override
    public long readLong() {
        this.position++;
        return Long.parseLong(this.in.get(this.position));
    }

    @Override
    public void writeBoolean(boolean b) {
        writeString(b ? "1" : "0");
    }

    @Override
    public boolean readBoolean() {
        this.position++;
        return Boolean.parseBoolean(this.in.get(this.position));
    }

    @Override
    public void writeByte(byte b) {
        writeString(Byte.toString(b));
    }

    @Override
    public byte readByte() {
        this.position++;
        return Byte.parseByte(this.in.get(this.position));
    }

    @Override
    public void writeDouble(double d) {
        writeString(Double.toString(d));
    }

    @Override
    public double readDouble() {
        this.position++;
        return Double.parseDouble(this.in.get(this.position));
    }

    @Override
    public void writeFloat(float f) {
        writeString(Float.toString(f));
    }

    @Override
    public double readFloat() {
        this.position++;

        return Float.parseFloat(this.in.get(this.position));
    }

    @Override
    public void reset() {
        this.position = -1;
    }

    @Override
    public void jump(int idx) {
        this.position = idx - 1;
    }

    @Override
    public byte[] getBytes() {
        return this.toString().getBytes();
    }

    @Override
    public int getSize() {
        return 0;
    }

    @Override
    public String toString() {
        // Check if anything was written to `out` beyond the initial "0"
        return out.length() > 1 ? out.toString() : String.join("|", this.in);
    }
}
