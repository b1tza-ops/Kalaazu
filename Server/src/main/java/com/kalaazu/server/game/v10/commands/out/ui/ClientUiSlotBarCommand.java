package com.kalaazu.server.game.v10.commands.out.ui;

import com.kalaazu.server.game.v10.commands.OutCommand;
import com.kalaazu.server.game.Packet;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * @author manulaiko <manulaiko@gmail.com>
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClientUiSlotBarCommand extends OutCommand {
    private final short id = 30741;

    public String layoutId;
    public String slotBarId;
    public String position;
    public List<ClientUiSlotBarItemCommand> items;
    public boolean visible;

    @Override
    public void write(Packet packet) {
        packet.writeShort(id);

        packet.writeBoolean(this.visible);
        packet.writeString(this.position);
        packet.writeShort(0);
        packet.writeString(this.slotBarId);
        packet.writeInt(this.items.size());
        items.forEach(i -> i.write(packet));
        packet.writeShort(0);
        packet.writeString(this.layoutId);
    }
}
