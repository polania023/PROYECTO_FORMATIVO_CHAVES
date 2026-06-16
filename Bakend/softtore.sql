DROP DATABASE IF EXISTS SOFTTORE;
CREATE DATABASE SOFTTORE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE SOFTTORE;

CREATE TABLE Rol (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    tipoIdUsuario VARCHAR(20),
    numIdUsuario BIGINT,
    nombreUsuario VARCHAR(50),
    apellido VARCHAR(50),
    correoUsuario VARCHAR(100) UNIQUE,
    claveUsuario VARCHAR(100),
    estadoUsuario VARCHAR(20),
    idRol INT,
    FOREIGN KEY (idRol) REFERENCES Rol(idRol)
) ENGINE=InnoDB;

CREATE TABLE Administrador (
    idAdmin INT AUTO_INCREMENT PRIMARY KEY,
    tipoContrato VARCHAR(20),
    edad INT,
    idUsuario INT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    ciudad VARCHAR(50),
    idUsuario INT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

CREATE TABLE Proveedor (
    idProveedor INT AUTO_INCREMENT PRIMARY KEY,
    tipoId VARCHAR(20),
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    edad INT,
    idUsuario INT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Producto (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    precio DECIMAL(10,2),
    stock INT DEFAULT 0,
    idProveedor INT,
    idCategoria INT,
    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor),
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
) ENGINE=InnoDB;

CREATE TABLE MetodoPago (
    idMetodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Venta (
    idVenta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    idCliente INT,
    idMetodo INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idMetodo) REFERENCES MetodoPago(idMetodo)
) ENGINE=InnoDB;

CREATE TABLE DetalleVenta (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    idProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precioUnitario) STORED,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
) ENGINE=InnoDB;

CREATE TABLE Inventario (
    idInventario INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT,
    tipoMovimiento VARCHAR(20) NOT NULL,
    cantidad INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
) ENGINE=InnoDB;

CREATE TABLE Factura (
    idFactura INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT UNIQUE,
    total DECIMAL(10,2),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
) ENGINE=InnoDB;

CREATE TABLE Envio (
    idEnvio INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT UNIQUE,
    direccion VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
) ENGINE=InnoDB;

CREATE TABLE Devolucion (
    idDevolucion INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    idProducto INT,
    cantidad INT,
    motivo VARCHAR(200),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
) ENGINE=InnoDB;

CREATE TABLE LogAuditoria (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    tabla VARCHAR(50),
    operacion VARCHAR(20),
    idRegistro INT,
    detalle TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

INSERT INTO Rol (descripcion) VALUES
('Administrador'),('Cliente'),('Proveedor');

INSERT INTO Usuario (tipoIdUsuario,numIdUsuario,nombreUsuario,apellido,correoUsuario,claveUsuario,estadoUsuario,idRol) VALUES
('C.C',1099874372,'Juan','Polania','jp08@softtore.com','JP123456','Activo',1),
('C.C',1098768576,'Duban','Bolivar','db31@softtore.com','DB123456','Activo',1),
('C.C',1287654353,'Catalina','Hernandez','cata58@gmail.com','CA123456','Activo',2),
('C.C',1063958412,'Natalia','Castilla','na56@gmail.com','NA123456','Inactivo',2),
('C.C',1028697254,'Diego','Ronaldo','dinaldo@gmail.com','DI123456','Activo',3),
('C.C',1259842158,'Ana','Martinez','ana@gmail.com','AN123456','Inactivo',3);

INSERT INTO Administrador (tipoContrato,edad,idUsuario) VALUES
('Indefinido',28,1),('Indefinido',31,2);

INSERT INTO Cliente (direccion,telefono,ciudad,idUsuario) VALUES
('Kra 11 #9-37','3112455677','Medellin',3),
('Kra 21 #83-27','3139678531','Bogota',4);

INSERT INTO Proveedor (tipoId,direccion,telefono,edad,idUsuario) VALUES
('C.C','CLL 70 SUR #15 50 ESTE','3112289509',40,5);

INSERT INTO Categoria (nombre) VALUES
('Snacks'),('Bebidas'),('Frutas'),('Verduras'),('Carnes'),('Aseo');

INSERT INTO Producto (descripcion,precio,stock,idProveedor,idCategoria) VALUES
('Galletas Ramo de Limon',20000,50,1,1),
('Jet',7500,100,1,1),
('Bon Bon Bum Sour',15000,80,1,1),
('Doritos',8500,60,1,1);

INSERT INTO MetodoPago (nombre) VALUES
('Efectivo'),('Tarjeta'),('Transferencia'),('Nequi'),('Daviplata');

INSERT INTO Venta (idCliente,idMetodo) VALUES
(1,1),(2,2),(1,4),(2,1);

INSERT INTO DetalleVenta (idVenta,idProducto,cantidad,precioUnitario) VALUES
(1,1,2,20000),(1,2,1,7500),
(2,3,3,15000),(2,4,2,8500),
(3,1,1,20000),(3,3,2,15000),
(4,2,5,7500);

INSERT INTO Inventario (idProducto,tipoMovimiento,cantidad) VALUES
(1,'entrada',50),(1,'salida',2),
(2,'entrada',100),(2,'salida',1),
(3,'entrada',80),(3,'salida',3),
(4,'entrada',60),(4,'salida',2);

INSERT INTO Factura (idVenta,total,fecha) VALUES
(1,47500,NOW()),(2,62500,NOW()),(3,50000,NOW()),(4,37500,NOW());

INSERT INTO Envio (idVenta,direccion,estado) VALUES
(1,'Kra 11 #9-37','En camino'),
(2,'Kra 21 #83-27','Entregado'),
(3,'Kra 11 #9-37','Pendiente'),
(4,'Kra 21 #83-27','En camino');

CREATE OR REPLACE VIEW v_ResumenVentas AS
SELECT v.idVenta, v.fecha,
    CONCAT(u.nombreUsuario,' ',u.apellido) AS cliente,
    c.ciudad, mp.nombre AS metodoPago,
    f.total AS totalFactura, e.estado AS estadoEnvio
FROM Venta v
JOIN Cliente c ON v.idCliente=c.idCliente
JOIN Usuario u ON c.idUsuario=u.idUsuario
JOIN MetodoPago mp ON v.idMetodo=mp.idMetodo
LEFT JOIN Factura f ON v.idVenta=f.idVenta
LEFT JOIN Envio e ON v.idVenta=e.idVenta;

CREATE OR REPLACE VIEW v_DetalleVentas AS
SELECT dv.idVenta, v.fecha,
    CONCAT(u.nombreUsuario,' ',u.apellido) AS cliente,
    p.descripcion AS producto, cat.nombre AS categoria,
    dv.cantidad, dv.precioUnitario, dv.subtotal
FROM DetalleVenta dv
JOIN Venta v ON dv.idVenta=v.idVenta
JOIN Producto p ON dv.idProducto=p.idProducto
JOIN Categoria cat ON p.idCategoria=cat.idCategoria
JOIN Cliente c ON v.idCliente=c.idCliente
JOIN Usuario u ON c.idUsuario=u.idUsuario;

CREATE OR REPLACE VIEW v_StockProductos AS
SELECT p.idProducto, p.descripcion, cat.nombre AS categoria,
    p.precio, p.stock AS stockActual,
    CONCAT(u.nombreUsuario,' ',u.apellido) AS proveedor,
    prov.telefono AS telefonoProveedor,
    CASE
        WHEN p.stock=0 THEN 'Sin stock'
        WHEN p.stock<10 THEN 'Stock bajo'
        WHEN p.stock<30 THEN 'Stock medio'
        ELSE 'Stock OK'
    END AS alertaStock
FROM Producto p
JOIN Categoria cat ON p.idCategoria=cat.idCategoria
JOIN Proveedor prov ON p.idProveedor=prov.idProveedor
JOIN Usuario u ON prov.idUsuario=u.idUsuario;

CREATE OR REPLACE VIEW v_MovimientosInventario AS
SELECT i.idInventario, p.descripcion AS producto,
    i.tipoMovimiento, i.cantidad, i.fecha
FROM Inventario i
JOIN Producto p ON i.idProducto=p.idProducto;

CREATE OR REPLACE VIEW v_ClientesResumen AS
SELECT c.idCliente,
    CONCAT(u.nombreUsuario,' ',u.apellido) AS cliente,
    u.correoUsuario, c.ciudad, c.telefono, u.estadoUsuario,
    COUNT(DISTINCT v.idVenta) AS totalCompras,
    COALESCE(SUM(f.total),0) AS totalGastado
FROM Cliente c
JOIN Usuario u ON c.idUsuario=u.idUsuario
LEFT JOIN Venta v ON c.idCliente=v.idCliente
LEFT JOIN Factura f ON v.idVenta=f.idVenta
GROUP BY c.idCliente,u.nombreUsuario,u.apellido,u.correoUsuario,c.ciudad,c.telefono,u.estadoUsuario;

CREATE OR REPLACE VIEW v_ProductosMasVendidos AS
SELECT p.idProducto, p.descripcion AS producto, cat.nombre AS categoria,
    SUM(dv.cantidad) AS unidadesVendidas,
    SUM(dv.subtotal) AS ingresoTotal
FROM DetalleVenta dv
JOIN Producto p ON dv.idProducto=p.idProducto
JOIN Categoria cat ON p.idCategoria=cat.idCategoria
GROUP BY p.idProducto,p.descripcion,cat.nombre
ORDER BY unidadesVendidas DESC;

CREATE OR REPLACE VIEW v_EnviosPendientes AS
SELECT e.idEnvio, e.idVenta,
    CONCAT(u.nombreUsuario,' ',u.apellido) AS cliente,
    c.telefono, e.direccion, e.estado,
    f.total AS totalFactura
FROM Envio e
JOIN Venta v ON e.idVenta=v.idVenta
JOIN Cliente c ON v.idCliente=c.idCliente
JOIN Usuario u ON c.idUsuario=u.idUsuario
JOIN Factura f ON v.idVenta=f.idVenta
WHERE e.estado<>'Entregado';

DELIMITER $$

CREATE TRIGGER trg_ValidarStock
BEFORE INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    SELECT stock INTO v_stock FROM Producto WHERE idProducto=NEW.idProducto;
    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Stock insuficiente para completar la venta.';
    END IF;
END$$

CREATE TRIGGER trg_DescontarStock
AFTER INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    UPDATE Producto SET stock=stock-NEW.cantidad WHERE idProducto=NEW.idProducto;
    INSERT INTO Inventario (idProducto,tipoMovimiento,cantidad) VALUES (NEW.idProducto,'salida',NEW.cantidad);
END$$

CREATE TRIGGER trg_EntradaInventario
AFTER INSERT ON Inventario
FOR EACH ROW
BEGIN
    IF NEW.tipoMovimiento='entrada' THEN
        UPDATE Producto SET stock=stock+NEW.cantidad WHERE idProducto=NEW.idProducto;
    END IF;
END$$

CREATE TRIGGER trg_CrearEnvio
AFTER INSERT ON Venta
FOR EACH ROW
BEGIN
    DECLARE v_direccion VARCHAR(100);
    SELECT direccion INTO v_direccion FROM Cliente WHERE idCliente=NEW.idCliente;
    INSERT INTO Envio (idVenta,direccion,estado) VALUES (NEW.idVenta,v_direccion,'Pendiente');
END$$

CREATE TRIGGER trg_ReponerStockDevolucion
AFTER UPDATE ON Devolucion
FOR EACH ROW
BEGIN
    IF NEW.estado='Aprobada' AND OLD.estado<>'Aprobada' THEN
        UPDATE Producto SET stock=stock+NEW.cantidad WHERE idProducto=NEW.idProducto;
        INSERT INTO Inventario (idProducto,tipoMovimiento,cantidad) VALUES (NEW.idProducto,'entrada',NEW.cantidad);
    END IF;
END$$

CREATE TRIGGER trg_AuditarEnvio
AFTER UPDATE ON Envio
FOR EACH ROW
BEGIN
    IF OLD.estado<>NEW.estado THEN
        INSERT INTO LogAuditoria (tabla,operacion,idRegistro,detalle,idUsuario)
        VALUES ('Envio','UPDATE',NEW.idEnvio,CONCAT('Estado cambio de "',OLD.estado,'" a "',NEW.estado,'"'),NULL);
    END IF;
END$$

CREATE TRIGGER trg_AuditarEliminarProducto
BEFORE DELETE ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO LogAuditoria (tabla,operacion,idRegistro,detalle,idUsuario)
    VALUES ('Producto','DELETE',OLD.idProducto,CONCAT('Producto eliminado: ',OLD.descripcion,' | precio: ',OLD.precio),NULL);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_RegistrarVenta(
    IN p_idCliente INT,
    IN p_idMetodo INT,
    IN p_idProd1 INT,
    IN p_cant1 INT,
    IN p_idProd2 INT,
    IN p_cant2 INT,
    OUT p_idVenta INT,
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    DECLARE v_precio1 DECIMAL(10,2);
    DECLARE v_precio2 DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SET p_mensaje='Error: la transaccion fue revertida.'; END;
    START TRANSACTION;
    SELECT precio INTO v_precio1 FROM Producto WHERE idProducto=p_idProd1;
    SELECT precio INTO v_precio2 FROM Producto WHERE idProducto=p_idProd2;
    INSERT INTO Venta (idCliente,idMetodo) VALUES (p_idCliente,p_idMetodo);
    SET p_idVenta=LAST_INSERT_ID();
    IF p_idProd1 IS NOT NULL AND p_cant1>0 THEN
        INSERT INTO DetalleVenta (idVenta,idProducto,cantidad,precioUnitario) VALUES (p_idVenta,p_idProd1,p_cant1,v_precio1);
    END IF;
    IF p_idProd2 IS NOT NULL AND p_cant2>0 THEN
        INSERT INTO DetalleVenta (idVenta,idProducto,cantidad,precioUnitario) VALUES (p_idVenta,p_idProd2,p_cant2,v_precio2);
    END IF;
    SELECT COALESCE(SUM(subtotal),0) INTO v_total FROM DetalleVenta WHERE idVenta=p_idVenta;
    INSERT INTO Factura (idVenta,total) VALUES (p_idVenta,v_total);
    COMMIT;
    SET p_mensaje=CONCAT('Venta #',p_idVenta,' registrada. Total: $',v_total);
END$$

CREATE PROCEDURE sp_EntradaStock(
    IN p_idProducto INT,
    IN p_cantidad INT,
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    DECLARE v_desc VARCHAR(100);
    IF p_cantidad<=0 THEN
        SET p_mensaje='La cantidad debe ser mayor a 0.';
    ELSE
        SELECT descripcion INTO v_desc FROM Producto WHERE idProducto=p_idProducto;
        INSERT INTO Inventario (idProducto,tipoMovimiento,cantidad) VALUES (p_idProducto,'entrada',p_cantidad);
        SET p_mensaje=CONCAT('Entrada de ',p_cantidad,' unidades para "',v_desc,'" registrada.');
    END IF;
END$$

CREATE PROCEDURE sp_ConsultarStock(IN p_idProducto INT)
BEGIN
    SELECT p.idProducto, p.descripcion, cat.nombre AS categoria,
        p.stock AS stockActual, p.precio,
        CASE WHEN p.stock=0 THEN 'SIN STOCK' WHEN p.stock<10 THEN 'STOCK BAJO' ELSE 'DISPONIBLE' END AS estado
    FROM Producto p
    JOIN Categoria cat ON p.idCategoria=cat.idCategoria
    WHERE p.idProducto=p_idProducto;
END$$

CREATE PROCEDURE sp_ActualizarEnvio(
    IN p_idEnvio INT,
    IN p_estado VARCHAR(20),
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    IF FIND_IN_SET(p_estado,'Pendiente,En camino,Entregado,Cancelado')=0 THEN
        SET p_mensaje='Estado no valido. Use: Pendiente, En camino, Entregado o Cancelado.';
    ELSE
        UPDATE Envio SET estado=p_estado WHERE idEnvio=p_idEnvio;
        SET p_mensaje=CONCAT('Envio #',p_idEnvio,' actualizado a "',p_estado,'".');
    END IF;
END$$

CREATE PROCEDURE sp_ReporteVentas(IN p_fechaInicio DATETIME, IN p_fechaFin DATETIME)
BEGIN
    SELECT v.idVenta, v.fecha,
        CONCAT(u.nombreUsuario,' ',u.apellido) AS cliente,
        mp.nombre AS metodoPago, f.total, e.estado AS estadoEnvio
    FROM Venta v
    JOIN Cliente c ON v.idCliente=c.idCliente
    JOIN Usuario u ON c.idUsuario=u.idUsuario
    JOIN MetodoPago mp ON v.idMetodo=mp.idMetodo
    LEFT JOIN Factura f ON v.idVenta=f.idVenta
    LEFT JOIN Envio e ON v.idVenta=e.idVenta
    WHERE v.fecha BETWEEN p_fechaInicio AND p_fechaFin
    ORDER BY v.fecha DESC;
END$$

CREATE PROCEDURE sp_RegistrarDevolucion(
    IN p_idVenta INT,
    IN p_idProducto INT,
    IN p_cantidad INT,
    IN p_motivo VARCHAR(200),
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    SELECT COUNT(*) INTO v_existe FROM DetalleVenta
    WHERE idVenta=p_idVenta AND idProducto=p_idProducto AND cantidad>=p_cantidad;
    IF v_existe=0 THEN
        SET p_mensaje='No se encontro el producto en la venta o la cantidad supera la comprada.';
    ELSE
        INSERT INTO Devolucion (idVenta,idProducto,cantidad,motivo,estado)
        VALUES (p_idVenta,p_idProducto,p_cantidad,p_motivo,'Pendiente');
        SET p_mensaje=CONCAT('Devolucion registrada para producto #',p_idProducto,' de la venta #',p_idVenta,'. En revision.');
    END IF;
END$$

CREATE PROCEDURE sp_GestionarDevolucion(
    IN p_idDevolucion INT,
    IN p_decision VARCHAR(20),
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    IF p_decision NOT IN ('Aprobada','Rechazada') THEN
        SET p_mensaje='Decision no valida. Use Aprobada o Rechazada.';
    ELSE
        UPDATE Devolucion SET estado=p_decision WHERE idDevolucion=p_idDevolucion;
        SET p_mensaje=CONCAT('Devolucion #',p_idDevolucion,' marcada como "',p_decision,'".');
    END IF;
END$$

CREATE PROCEDURE sp_AlertaStockBajo(IN p_umbral INT)
BEGIN
    SELECT p.idProducto, p.descripcion, p.stock, p.precio,
        CONCAT(u.nombreUsuario,' ',u.apellido) AS proveedor,
        prov.telefono AS telProveedor
    FROM Producto p
    JOIN Proveedor prov ON p.idProveedor=prov.idProveedor
    JOIN Usuario u ON prov.idUsuario=u.idUsuario
    WHERE p.stock<=p_umbral
    ORDER BY p.stock ASC;
END$$

CREATE PROCEDURE sp_InactivarUsuario(IN p_idUsuario INT, OUT p_mensaje VARCHAR(200))
BEGIN
    DECLARE v_estado VARCHAR(20);
    SELECT estadoUsuario INTO v_estado FROM Usuario WHERE idUsuario=p_idUsuario;
    IF v_estado='Inactivo' THEN
        SET p_mensaje='El usuario ya se encuentra inactivo.';
    ELSE
        UPDATE Usuario SET estadoUsuario='Inactivo' WHERE idUsuario=p_idUsuario;
        SET p_mensaje=CONCAT('Usuario #',p_idUsuario,' inactivado correctamente.');
    END IF;
END$$

CREATE PROCEDURE sp_ReporteInventario()
BEGIN
    SELECT p.idProducto, p.descripcion,
        SUM(CASE WHEN i.tipoMovimiento='entrada' THEN i.cantidad ELSE 0 END) AS totalEntradas,
        SUM(CASE WHEN i.tipoMovimiento='salida' THEN i.cantidad ELSE 0 END) AS totalSalidas,
        p.stock AS stockActual
    FROM Producto p
    LEFT JOIN Inventario i ON p.idProducto=i.idProducto
    GROUP BY p.idProducto,p.descripcion,p.stock
    ORDER BY p.idProducto;
END$$

DELIMITER ;