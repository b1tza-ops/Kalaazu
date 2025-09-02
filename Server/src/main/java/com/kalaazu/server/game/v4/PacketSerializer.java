package com.kalaazu.server.game.v4;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToMessageCodec;

import java.util.List;

/**
 * Packet serializer.
 * ==================
 * <p>
 * Encoder and decoder for the packet format.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
public class PacketSerializer extends MessageToMessageCodec<String, Packet> {
    @Override
    protected void encode(ChannelHandlerContext ctx, Packet packet, List<Object> out) {
        out.add(packet.toString() + "\n\u0000");
    }

    @Override
    protected void decode(ChannelHandlerContext ctx, String msg, List<Object> out) {
        out.add(new Packet(msg));
    }
}
