package com.kalaazu.server.entities;

import com.kalaazu.math.Vector;
import com.kalaazu.persistence.entity.MapsEntity;
import com.kalaazu.persistence.entity.MapsStationsEntity;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * Station entity.
 * ===============
 * <p>
 * Represents a station in a map.
 *
 * @author manulaiko <manulaiko@gmail.com>
 */
@RequiredArgsConstructor
@Getter
@Setter
public class Station implements MapEntity {
    private final MapsStationsEntity station;
    private final MapsEntity map;

    private int id;
    private Vector position;
}
