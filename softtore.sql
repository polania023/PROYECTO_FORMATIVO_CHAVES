/*CREAR LA BASE DE DATOS DE LA TIENDA LA ECONOMIA*/
CREATE DATABASE SOFTTORE;
USE SOFTTORE;

-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LAS TABLAS */

CREATE TABLE Rol (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

INSERT INTO Rol (descripcion) VALUES 
('Administrador'),
('Cliente'),
('Proveedor');

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

INSERT INTO Usuario 
(tipoIdUsuario, numIdUsuario, nombreUsuario, apellido, correoUsuario, claveUsuario, estadoUsuario, idRol)
VALUES
('C.C',1099874372,'Juan','Polania','jp08@softtore.com','JP123456','Activo',1),
('C.C',1098768576,'Duban','Bolívar','db31@softtore.com','DB123456','Activo',1),
('C.C',1287654353,'Catalina','Hernandez','cata58@gmail.com','CA123456','Activo',2),
('C.C',1063958412,'Natalia','Castilla','na56@gmail.com','NA123456','Inactivo',2),
('C.C',1028697254,'Diego','Ronaldo','dinaldo@gmail.com','DI123456','Activo',3),
('C.C',1259842158,'Ana','Martinez','ana@gmail.com','AN123456','Inactivo',3);

CREATE TABLE Administrador (
    idAdmin INT AUTO_INCREMENT PRIMARY KEY,
    tipoContrato VARCHAR(20),
    edad INT,
    idUsuario INT UNIQUE,

    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

INSERT INTO Administrador (tipoContrato, edad, idUsuario) VALUES
('Indefinido',15,1),
('Indefinido',16,2);

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    ciudad VARCHAR(50),
    idUsuario INT UNIQUE,

    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

INSERT INTO Cliente (direccion, telefono, ciudad, idUsuario) VALUES
('Kra 11 #9-37','3112455677','Medellin',3),
('Kra 21 #83-27','3139678531','Bogotá',4);

CREATE TABLE Proveedor (
    idProveedor INT AUTO_INCREMENT PRIMARY KEY,
    tipoId VARCHAR(20),
    direccion VARCHAR(100),
    telefono VARCHAR(15),
    edad INT,
    idUsuario INT UNIQUE,

    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
) ENGINE=InnoDB;

INSERT INTO Proveedor (tipoId, direccion, telefono, edad, idUsuario) VALUES
('C.C','CLL 70 SUR #15 50 ESTE','3112289509',40,5);

CREATE TABLE Producto (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    precio DECIMAL(10,2),
    stock INT,
    idProveedor INT,

    FOREIGN KEY (idProveedor) REFERENCES Proveedor(idProveedor)
) ENGINE=InnoDB;

INSERT INTO Producto (descripcion, precio, stock, idProveedor) VALUES
('Galletas Ramo de Limón',20000,50,1),
('Jet',7500,100,1),
('Bon Bon Bum Sour',15000,80,1),
('Doritos',8500,60,1);

CREATE TABLE Venta (
    idVenta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    idCliente INT,

    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
) ENGINE=InnoDB;

CREATE TABLE DetalleVenta (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    idProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),

    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
) ENGINE=InnoDB;

INSERT INTO DetalleVenta (idVenta, idProducto, cantidad, precioUnitario) VALUES
(1,1,2,20000),
(1,2,1,7500),
(2,3,3,15000),
(2,4,2,10000),
(3,5,1,24000),
(3,6,2,8500),
(4,7,5,2500);

INSERT INTO Venta (idCliente) VALUES (1);

INSERT INTO DetalleVenta (idVenta, idProducto, cantidad, precioUnitario) VALUES
(1,1,2,20000),
(1,2,3,7500);

CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO Categoria (nombre) VALUES
('Snacks'),
('Bebidas'),
('Frutas'),
('Verduras'),
('Carnes'),
('Aseo');

ALTER TABLE Producto
ADD idCategoria INT,
ADD FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria);

CREATE TABLE Inventario (
    idInventario INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT,
    tipoMovimiento VARCHAR(20), -- entrada/salida
    cantidad INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

INSERT INTO Inventario (idProducto, tipoMovimiento, cantidad) VALUES
(1,'entrada',50),
(1,'salida',2),
(2,'entrada',100),
(2,'salida',1),
(3,'entrada',80),
(3,'salida',3),
(4,'entrada',60),
(4,'salida',2);

CREATE TABLE MetodoPago (
    idMetodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

INSERT INTO MetodoPago (nombre) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia'),
('Nequi'),
('Daviplata');

ALTER TABLE Venta
ADD idMetodo INT,
ADD FOREIGN KEY (idMetodo) REFERENCES MetodoPago(idMetodo);

CREATE TABLE Factura (
    idFactura INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    total DECIMAL(10,2),
    fecha DATETIME,

    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
);

INSERT INTO Factura (idVenta, total, fecha) VALUES
(1,47500,NOW()),
(2,65000,NOW()),
(3,41000,NOW()),
(4,12500,NOW());


CREATE TABLE Envio (
    idEnvio INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    direccion VARCHAR(100),
    estado VARCHAR(20),

    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
);

INSERT INTO Envio (idVenta, direccion, estado) VALUES
(1,'Kra 11 #9-37','En camino'),
(2,'Kra 21 #83-27','Entregado'),
(3,'Cll 45 #10-20','Pendiente'),
(4,'Av 30 #15-80','En camino');

