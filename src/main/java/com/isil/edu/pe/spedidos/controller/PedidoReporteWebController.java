package com.isil.edu.pe.spedidos.controller;

import com.isil.edu.pe.spedidos.entity.Pedido;
import com.isil.edu.pe.spedidos.exception.PedidoException;
import com.isil.edu.pe.spedidos.service.PedidoReporteService;
import com.isil.edu.pe.spedidos.service.domain.ClienteFrecuente;
import com.isil.edu.pe.spedidos.service.domain.ProductoVendido;
import com.isil.edu.pe.spedidos.service.domain.ResumenPedidos;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/reportes")
public class PedidoReporteWebController {

    private final PedidoReporteService reporteService;
    public PedidoReporteWebController(
            PedidoReporteService reporteService) {
        this.reporteService = reporteService;
    }
    @GetMapping("/pedidos")
    public String mostrarReportes(
            @RequestParam(required = false) String cliente,
            @RequestParam(required = false) String totalMinimo,
            @RequestParam(required = false) String minPedidos,
            Model model) {

        ResumenPedidos resumen = reporteService.obtenerResumen();
        List<ProductoVendido> productos =
                reporteService.listarProductosMasVendidos();

        model.addAttribute("resumen", resumen);
        model.addAttribute("productos", productos);

        model.addAttribute("pedidosEncontrados", List.<Pedido>of());
        model.addAttribute(
                "clientesFrecuentes",
                List.<ClienteFrecuente>of()
        );

        model.addAttribute("cliente", cliente);
        model.addAttribute("totalMinimo", totalMinimo);
        model.addAttribute("minPedidos", minPedidos);

        boolean ingresoBusqueda =
                (cliente != null && !cliente.isBlank()) || (totalMinimo != null && !totalMinimo.isBlank());
        if (ingresoBusqueda) {
            try {
                if (cliente == null || cliente.isBlank()) {
                    throw new PedidoException("Debes ingresar el nombre del cliente.");
                }
                if (totalMinimo == null || totalMinimo.isBlank()) {
                    throw new PedidoException("Debes ingresar el monto mínimo.");
                }
                BigDecimal monto = new BigDecimal(totalMinimo.trim());
                List<Pedido> pedidos = reporteService.buscarPedidosPorClienteYTotalMinimo(cliente, monto);
                model.addAttribute("pedidosEncontrados", pedidos);

            } catch (NumberFormatException ex) {
                model.addAttribute("mensajeErrorBusqueda", "El monto mínimo debe ser un número válido.");
            } catch (PedidoException ex) {
                model.addAttribute("mensajeErrorBusqueda", ex.getMessage());
            }
        }

        if (minPedidos != null && !minPedidos.isBlank()) {
            try {
                int minimo = Integer.parseInt(minPedidos.trim());

                List<ClienteFrecuente> clientes =
                        reporteService.listarClientesFrecuentes(minimo);
                model.addAttribute("clientesFrecuentes", clientes);

            } catch (NumberFormatException ex) {
                model.addAttribute(
                        "mensajeErrorFrecuentes",
                        "El mínimo de pedidos debe ser un número entero.");
            } catch (PedidoException ex) {
                model.addAttribute("mensajeErrorFrecuentes", ex.getMessage());
            }
        }
        return "reportes-pedidos";
    }
}
