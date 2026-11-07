<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes de pedidos</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 25px;
            color: #333;
        }

        .contenedor {
            max-width: 1100px;
            margin: auto;
        }

        h1, h2 {
            color: #24364b;
        }

        .seccion {
            background: white;
            padding: 22px;
            margin-bottom: 22px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }

        .resumen {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
            gap: 15px;
        }

        .indicador {
            background: #edf3fa;
            padding: 18px;
            border-radius: 7px;
        }

        .indicador strong {
            display: block;
            font-size: 23px;
            margin-top: 8px;
            color: #174a7e;
        }

        label {
            display: block;
            margin-top: 12px;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input {
            width: 100%;
            max-width: 350px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        button {
            display: block;
            margin-top: 15px;
            padding: 10px 18px;
            background: #245b91;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #173e65;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 11px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #eaf0f6;
        }

        .error {
            color: #a32121;
            background: #fceaea;
            padding: 10px;
            border-radius: 5px;
            margin-top: 12px;
        }

        .vacio {
            color: #666;
            margin-top: 12px;
        }

        @media (max-width: 650px) {
            body {
                padding: 12px;
            }

            .seccion {
                overflow-x: auto;
            }
        }
    </style>
</head>

<body>
<div class="contenedor">

    <h1>Reporte y consulta de pedidos</h1>
    <p>Panel de consulta y supervision de pedidos registrados.</p>

    <!-- RESUMEN GENERAL -->
    <section class="seccion">
        <h2>Resumen general</h2>

        <div class="resumen">
            <div class="indicador">
                Total de pedidos
                <strong><c:out value="${resumen.totalPedidos}"/></strong>
            </div>

            <div class="indicador">
                Total de unidades
                <strong><c:out value="${resumen.totalUnidades}"/></strong>
            </div>

            <div class="indicador">
                Importe acumulado
                <strong>S/ <c:out value="${resumen.importeAcumulado}"/></strong>
            </div>

            <div class="indicador">
                Ticket promedio
                <strong>S/ <c:out value="${resumen.ticketPromedio}"/></strong>
            </div>
        </div>
    </section>

    <!-- PRODUCTOS MAS VENDIDOS -->
    <section class="seccion">
        <h2>Productos mas vendidos</h2>

        <table>
            <thead>
                <tr>
                    <th>Codigo</th>
                    <th>Producto</th>
                    <th>Total pedidos</th>
                    <th>Total unidades</th>
                    <th>Importe acumulado</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="producto" items="${productos}">
                    <tr>
                        <td><c:out value="${producto.productoCodigo}"/></td>
                        <td><c:out value="${producto.productoNombre}"/></td>
                        <td><c:out value="${producto.totalPedidos}"/></td>
                        <td><c:out value="${producto.totalUnidades}"/></td>
                        <td>S/ <c:out value="${producto.importeAcumulado}"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty productos}">
                    <tr>
                        <td colspan="5">No hay productos registrados.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </section>

    <!-- BUSQUEDA AVANZADA -->
    <section class="seccion">
        <h2>Busqueda avanzada de pedidos</h2>
        <p>Busca pedidos por nombre del cliente y monto minimo.</p>

        <form method="get"
              action="${pageContext.request.contextPath}/reportes/pedidos">

            <label for="cliente">Nombre del cliente</label>
            <input type="text"
                   id="cliente"
                   name="cliente"
                   value="<c:out value='${cliente}'/>"
                   placeholder="Ingrese el nombre del cliente">

            <label for="totalMinimo">Monto minimo (S/)</label>
            <input type="number"
                   id="totalMinimo"
                   name="totalMinimo"
                   min="0"
                   step="0.01"
                   value="<c:out value='${totalMinimo}'/>"
                   placeholder="Ejemplo: 100.00">

            <button type="submit">Buscar pedidos</button>
        </form>

        <c:if test="${not empty mensajeErrorBusqueda}">
            <div class="error">
                <c:out value="${mensajeErrorBusqueda}"/>
            </div>
        </c:if>

        <h3>Resultados de la busqueda</h3>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Total</th>
                    <th>Fecha</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="pedido" items="${pedidosEncontrados}">
                    <tr>
                        <td><c:out value="${pedido.id}"/></td>
                        <td><c:out value="${pedido.cliente}"/></td>
                        <td><c:out value="${pedido.productoNombre}"/></td>
                        <td><c:out value="${pedido.cantidad}"/></td>
                        <td>S/ <c:out value="${pedido.total}"/></td>
                        <td><c:out value="${pedido.fecha}"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty pedidosEncontrados}">
                    <tr>
                        <td colspan="6">No hay pedidos para mostrar.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </section>

    <!-- CLIENTES FRECUENTES -->
    <section class="seccion">
        <h2>Clientes frecuentes</h2>
        <p>Consulta los clientes que tienen como minimo cierta cantidad de pedidos.</p>

        <form method="get"
              action="${pageContext.request.contextPath}/reportes/pedidos">

            <label for="minPedidos">Cantidad minima de pedidos</label>
            <input type="number"
                   id="minPedidos"
                   name="minPedidos"
                   min="1"
                   step="1"
                   value="<c:out value='${minPedidos}'/>"
                   placeholder="Ejemplo: 2">

            <button type="submit">Buscar clientes frecuentes</button>
        </form>

        <c:if test="${not empty mensajeErrorFrecuentes}">
            <div class="error">
                <c:out value="${mensajeErrorFrecuentes}"/>
            </div>
        </c:if>

        <h3>Resultados</h3>

        <table>
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Total pedidos</th>
                    <th>Total unidades</th>
                    <th>Importe acumulado</th>
                    <th>Ticket promedio</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="clienteFrecuente" items="${clientesFrecuentes}">
                    <tr>
                        <td><c:out value="${clienteFrecuente.cliente}"/></td>
                        <td><c:out value="${clienteFrecuente.totalPedidos}"/></td>
                        <td><c:out value="${clienteFrecuente.totalUnidades}"/></td>
                        <td>S/ <c:out value="${clienteFrecuente.importeAcumulado}"/></td>
                        <td>S/ <c:out value="${clienteFrecuente.ticketPromedio}"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty clientesFrecuentes}">
                    <tr>
                        <td colspan="5">No hay clientes frecuentes para mostrar.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </section>

</div>
</body>
</html>
