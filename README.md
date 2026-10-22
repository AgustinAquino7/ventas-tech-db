# 🛒 ventas-tech-db

> Base de datos relacional de ventas para una cadena de tiendas de tecnología, con consultas SQL de negocio y JOINs que alimentan el análisis y el dashboard.

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![SSMS](https://img.shields.io/badge/SSMS-0078D4?logo=microsoft&logoColor=white)
![Normalización](https://img.shields.io/badge/modelo-3NF-2ea44f)

## 📑 Contenido

- [Descripción](#-descripción)
- [Modelo de datos](#-modelo-de-datos)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Cómo ejecutarlo](#-cómo-ejecutarlo)
- [Consultas incluidas](#-consultas-incluidas)
- [Conexión con el brief inicial (M1)](#-conexión-con-el-brief-inicial-m1)

---

## 📌 Descripción

El proyecto crea la base **Ventas_Tech_DB** con un modelo normalizado hasta 3NF, la carga con 25 registros de ejemplo y la consulta con SQL para obtener métricas de negocio: facturación mensual, ranking de productos, clientes recurrentes y vistas que cruzan todas las tablas.

**Motor utilizado:** SQL Server, trabajado con SQL Server Management Studio (SSMS). Requiere SQL Server 2016 o superior, porque el script usa `DROP TABLE IF EXISTS`.

## 🗂️ Modelo de datos

```
categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes
```

| Tabla | Tipo | Qué guarda | Registros |
|---|---|---|---|
| `categorias` | Dimensión | Categorías de producto | 4 |
| `clientes` | Dimensión | Datos de los clientes (nombre, email, ciudad, fecha de registro) | 5 |
| `productos` | Dimensión | Catálogo con precio, stock y categoría | 6 |
| `ventas` | Hechos | Cada venta, con cliente, producto, cantidad y precio unitario | 10 |

## 📁 Estructura del repositorio

```
ventas-tech-db/
├── README.md
├── ventas_tech_db.sql          # crea las tablas y carga los datos
├── m4_consultas_negocio.sql    # métricas de negocio
└── m5_consultas_joins.sql      # consultas con JOINs
```

## ▶️ Cómo ejecutarlo

1. Descargá o cloná este repositorio.
2. Abrí SSMS y conectate a tu servidor (por ejemplo, `localhost` o `.\SQLEXPRESS`).
3. Creá la base de datos, una sola vez:
   ```sql
   CREATE DATABASE Ventas_Tech_DB;
   ```
4. Abrí `ventas_tech_db.sql` con *File → Open → File*.
5. En la lista desplegable de bases de la barra de herramientas, seleccioná **Ventas_Tech_DB**.
6. Ejecutá el script completo con **F5**.
7. Verificá que las cuatro consultas de validación devuelvan **4, 5, 6 y 10 filas**.
8. Ejecutá `m4_consultas_negocio.sql` y `m5_consultas_joins.sql` con **F5**.

> ℹ️ El script es repetible: la sección DROP elimina las tablas existentes antes de crearlas, así que se puede ejecutar todas las veces que haga falta sin errores.

## 🔍 Consultas incluidas

**`m4_consultas_negocio.sql`**

1. Resumen ejecutivo mensual: total facturado, cantidad de pedidos y ticket promedio.
2. Ranking de productos: top 5 por total facturado.
3. Clientes recurrentes: clientes con más de un pedido.
4. Meses por encima y por debajo del promedio mensual.

**`m5_consultas_joins.sql`**

1. Vista base del proyecto (`INNER JOIN`): cada venta con cliente, ciudad, producto y categoría.
2. Clientes sin ventas (`LEFT JOIN`).
3. Productos sin ventas (`LEFT JOIN`).
4. Consolidado por origen (`UNION ALL`).

Cada archivo cierra con hallazgos escritos en comentarios, que leen los resultados en términos de negocio.

## 🎯 Conexión con el brief inicial (M1)

Este repositorio es la base técnica del proyecto definido en el brief de M1. La pregunta estratégica del brief es:

> **¿Por qué cayeron las ventas de la región Norte en el último trimestre y qué categoría de producto lo explica?**

Cada pregunta de análisis del brief se apoya en consultas de este repositorio:

### 1. ¿Cuándo empezó la caída?
- **Consultas:** `m4_consultas_negocio.sql` (1 y 4).
- **Con los datos actuales:** el dataset cubre solo marzo de 2024, así que devuelve un único mes. La evolución mensual se podrá observar al ampliar el rango de fechas.

### 2. ¿Qué categoría lo explica?
- **Consulta:** `m5_consultas_joins.sql` (1), cuya vista trae la categoría de cada venta.
- **Con los datos actuales:** al agrupar por categoría, Computación explica el 76,8% de la facturación (4.950 de 6.444).

### 3. ¿Es solo el Norte?
- **Consulta:** `m5_consultas_joins.sql` (1), que incluye la ciudad del cliente.
- **Con los datos actuales:** el modelo no tiene una tabla de territorios, por lo que la ciudad funciona como aproximación geográfica. Buenos Aires y Tucumán concentran el 73,6% de lo facturado.

### 4. ¿Se perdieron clientes o bajó lo que compra cada uno?
- **Consultas:** `m4_consultas_negocio.sql` (1 y 3) y `m5_consultas_joins.sql` (2).
- **Con los datos actuales:** el ticket promedio es de 644,40; los 5 clientes compraron 2 veces y ninguno quedó sin compras.

> La vista base de `m5_consultas_joins.sql` (consulta 1) es la fuente de datos principal para el dashboard de Power BI.
