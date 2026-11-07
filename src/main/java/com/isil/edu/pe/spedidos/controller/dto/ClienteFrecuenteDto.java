package com.isil.edu.pe.spedidos.controller.dto;

import com.isil.edu.pe.spedidos.service.domain.ClienteFrecuente;
import java.math.BigDecimal;

public record ClienteFrecuenteDto (
        String cliente,
        long totalPedidos,
        long totalUnidades,
        BigDecimal importeAcumulado,
        BigDecimal ticketPromedio
) {
    public static ClienteFrecuenteDto from(ClienteFrecuente item) {
        return new ClienteFrecuenteDto(
                item.cliente(),
                item.totalPedidos(),
                item.totalUnidades(),
                item.importeAcumulado(),
                item.ticketPromedio()
        );
    }
}
