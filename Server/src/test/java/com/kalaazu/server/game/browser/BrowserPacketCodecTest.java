package com.kalaazu.server.game.browser;

import com.kalaazu.server.game.v4.Packet;
import io.netty.channel.embedded.EmbeddedChannel;
import io.netty.handler.codec.http.websocketx.TextWebSocketFrame;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class BrowserPacketCodecTest {
    @Test
    void decodesBrowserFrameAsV4Packet() {
        var channel = new EmbeddedChannel(new BrowserPacketCodec());

        channel.writeInbound(new TextWebSocketFrame("LOGIN|7|session|4.1\n\u0000"));
        Packet packet = channel.readInbound();

        assertThat(packet.readString()).isEqualTo("LOGIN");
        assertThat(packet.readInt()).isEqualTo(7);
        assertThat(packet.readString()).isEqualTo("session");
        assertThat(packet.readString()).isEqualTo("4.1");
        channel.finishAndReleaseAll();
    }

    @Test
    void encodesV4PacketAsBrowserFrame() {
        var channel = new EmbeddedChannel(new BrowserPacketCodec());
        var packet = new Packet();
        packet.writeString("I");
        packet.writeInt(7);

        channel.writeOutbound(packet);
        TextWebSocketFrame frame = channel.readOutbound();

        assertThat(frame.text()).isEqualTo("0|I|7");
        frame.release();
        channel.finishAndReleaseAll();
    }
}
