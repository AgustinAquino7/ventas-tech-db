# ventas-tech-db
Descripción:
Base de datos relacional Ventas_Tech_DB para las operaciones de venta de una cadena de tiendas de tecnología. El modelo está normalizado hasta 3NF y se compone de cuatro tablas: tres de dimensión (categorias, clientes, productos) y una de hechos (ventas).

categorias (1) ──── (N) productos (1) ──── (N) ventas (N) ──── (1) clientes

El repositorio incluye el script que crea y carga la base (25 registros de ejemplo) y un conjunto de consultas SQL de negocio que extraen métricas clave de la tabla ventas.

Motor de base de datos:

SQL Server, trabajado con SQL Server Management Studio (SSMS).

Requiere SQL Server 2016 o superior, porque el script usa DROP TABLE IF EXISTS.
Archivos

Archivo	Contenido:
ventas_tech_db.sql	
Crea las tablas y carga los datos. Tiene cuatro secciones: DROP, CREATE, INSERT y VALIDACIÓN.

m4_consultas_negocio.sql	Cuatro consultas de negocio (resumen mensual, ranking de productos, clientes recurrentes y meses vs. promedio) y tres hallazgos en comentarios.

Pasos para ejecutar el script:

Descargá o cloná este repositorio.

Abrí SSMS y conectate a tu servidor (por ejemplo, localhost o .\SQLEXPRESS).

Creá la base de datos, una sola vez:
  sql
     CREATE DATABASE Ventas_Tech_DB;

Abrí ventas_tech_db.sql con File → Open → File.

En la lista desplegable de bases de datos de la barra de herramientas, seleccioná Ventas_Tech_DB.

Ejecutá el script completo con F5.

Verificá en la pestaña de resultados que las cuatro consultas de validación devuelvan 4, 5, 6 y 10 filas (categorias, clientes, productos y ventas).

Para obtener las métricas de negocio, abrí m4_consultas_negocio.sql y ejecutalo con F5.

El script es repetible: la sección DROP elimina las tablas existentes antes de crearlas, por lo que se puede ejecutar todas las veces que haga falta sin errores.
