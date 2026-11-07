
-- ICN292 - Laboratorio 4 - Austral Editores--

-- ENTREGABLE 1: CREACIÓN DE LA BASE--

DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

CREATE TABLE colecciones (
    id_coleccion      INT          NOT NULL AUTO_INCREMENT,
    titulo            VARCHAR(120) NOT NULL,
    fecha_publicacion DATE         NOT NULL,
    PRIMARY KEY (id_coleccion)
);

CREATE TABLE autores (
    id_autor INT         NOT NULL AUTO_INCREMENT,
    nombre   VARCHAR(80) NOT NULL,
    pais     VARCHAR(60) NULL,
    genero   ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);

CREATE TABLE libros (
    id_libro           INT          NOT NULL AUTO_INCREMENT,
    id_autor           INT          NOT NULL,
    id_coleccion       INT          NULL,
    titulo             VARCHAR(120) NOT NULL,
    paginas            INT,
    ejemplares_vendidos INT,
    anio               INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_autor)     REFERENCES autores (id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones (id_coleccion)
);

CREATE TABLE pagos (
    id_pago    INT           NOT NULL AUTO_INCREMENT,
    id_autor   INT           NOT NULL,
    fecha_pago DATE          NOT NULL,
    monto      DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);


INSERT INTO autores (nombre, pais, genero) VALUES
    ('Elena Pizarro',     'Chile',          'Novela'),
    ('Harold Finch',      'Inglaterra',     'Ensayo'),
    ('Rodrigo Bahamonde', 'Chile',          'Poesía'),
    ('Valentina Correa',  'Argentina',      'Infantil'),
    ('Nora Keller',       'Estados Unidos', 'Novela'),
    ('Kenji Arakawa',     NULL,             'Cómic');


INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio) VALUES
    (1, 'Cielo de Enero',     210, 1500, 2024),
    (1, 'Marea Baja',         185,  800, 2023),
    (1, 'El Norte',           200, 2200, 2024),
    (2, 'Estrellas que Caen', 240, 3000, 2022),
    (2, 'Máquinas',           215,  450, 2024),
    (3, 'Luz Artificial',     300, 1200, 2024),
    (3, 'Ruido Blanco',       280,  600, 2023),
    (4, 'El Barrio de Lila',  190, 5000, 2024),
    (4, 'Antes del Amanecer', 205, 2700, 2024),
    (4, 'La Calle 8',         175,  900, 2023),
    (5, 'Flor de Hierro',     195, 4100, 2024),
    (5, 'Hora Dorada',        220, 1800, 2022);

-- ENTREGABLE 2: CONSULTAS--


-- Consulta 1
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

-- Consulta 2
SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;

-- Consulta 3
SELECT COUNT(*)                 AS total_libros,
       SUM(ejemplares_vendidos) AS total_ejemplares,
       AVG(paginas)             AS promedio_paginas,
       MIN(anio)                AS anio_mas_antiguo,
       MAX(ejemplares_vendidos) AS max_ejemplares_libro
FROM libros;

-- Consulta 4
SELECT DISTINCT genero
FROM autores
ORDER BY genero ASC;

-- Consulta 5
SELECT a.nombre, COUNT(*) AS libros_2024
FROM autores AS a
JOIN libros AS l ON l.id_autor = a.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

-- Consulta 6
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;


SET SQL_SAFE_UPDATES = 0;

-- Consulta 7
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES (3, 'Papel Mojado', 260, 50, 2024);

-- 7.a SELECT previo: la fila que se va a borrar
SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- 7.b DELETE
DELETE FROM libros WHERE titulo = 'Papel Mojado';

-- 7.c SELECT posterior: ya no está (0 filas)
SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- Consulta 8
-- 8.a SELECT previo
SELECT titulo, ejemplares_vendidos FROM libros WHERE titulo = 'Cielo de Enero';

-- 8.b UPDATE: calcula desde el valor actual
UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

-- 8.c SELECT posterior
SELECT titulo, ejemplares_vendidos FROM libros WHERE titulo = 'Cielo de Enero';

SET SQL_SAFE_UPDATES = 1;

-- Consulta 9
-- Filas de prueba: tres colecciones (títulos y fechas inventados para el laboratorio)
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
    ('Narrativa Austral',   '2024-10-07'),
    ('Pensamiento y Verso', '2024-11-20'),
    ('Austral Infantil',    '2024-12-02');

-- Asignación de los doce libros. Filtra por la clave primaria, así funciona con Safe Updates.
UPDATE libros SET id_coleccion = 1 WHERE id_libro IN (1, 2, 3, 11, 12);
UPDATE libros SET id_coleccion = 2 WHERE id_libro IN (4, 5, 6, 7);
UPDATE libros SET id_coleccion = 3 WHERE id_libro IN (8, 9, 10);

SELECT l.titulo AS libro,
       c.titulo AS coleccion,
       c.fecha_publicacion
FROM libros AS l
JOIN colecciones AS c ON l.id_coleccion = c.id_coleccion
ORDER BY c.fecha_publicacion, l.titulo;

-- Consulta 10

INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
    (1, '2025-01-15', 350000.00),
    (1, '2025-06-15', 275500.50),
    (2, '2025-01-20', 180000.00),
    (3, '2025-02-10', 120000.00),
    (4, '2025-03-05', 640000.75),
    (5, '2025-03-18', 410000.00),
    (6, '2025-04-02',  90000.00);

-- 10.a Listado de pagos
SELECT a.nombre, p.fecha_pago, p.monto
FROM pagos AS p
JOIN autores AS a ON p.id_autor = a.id_autor
ORDER BY p.fecha_pago;

-- 10.b Total pagado a cada autor
SELECT a.nombre, SUM(p.monto) AS total_pagado
FROM autores AS a
JOIN pagos AS p ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;
