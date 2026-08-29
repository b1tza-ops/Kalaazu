package com.kalaazu.server.game.browser;

import com.kalaazu.server.game.v4.Packet;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToMessageCodec;
import io.netty.handler.codec.http.websocketx.TextWebSocketFrame;

import java.util.List;

/**
 * Converts browser WebSocket text frames to and from V4 game packets.
 */
public class BrowserPacketCodec extends MessageToMessageCodec<TextWebSocketFrame, Packet> {
    @Override
    protected void encode(ChannelHandlerContext ctx, Packet packet, List<Object> out) {
        out.add(new TextWebSocketFrame(packet.toString()));
    }

    @Override
    protected void decode(ChannelHandlerContext ctx, TextWebSocketFrame frame, List<Object> out) {
        var payload = frame.text()
                .replace("\u0000", "")
                .trim();

        if (!payload.isEmpty()) {
            out.add(new Packet(payload));
        }
    }
}
