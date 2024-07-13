-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.9.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para northwind
CREATE DATABASE IF NOT EXISTS `northwind` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `northwind`;

-- Volcando estructura para procedimiento northwind.ActualizarEmpleado
DELIMITER //
CREATE PROCEDURE `ActualizarEmpleado`(
    IN p_EmployeeID INTEGER,
    IN p_LastName VARCHAR(15),
    IN p_FirstName VARCHAR(15),
    IN p_BirthDate DATETIME,
    IN p_Photo VARCHAR(25),
    IN p_Notes VARCHAR(1024)
)
BEGIN
    UPDATE Employees
    SET 
        LastName = p_LastName,
        FirstName = p_FirstName,
        BirthDate = p_BirthDate,
        Photo = p_Photo,
        Notes = p_Notes
    WHERE EmployeeID = p_EmployeeID;
END//
DELIMITER ;

-- Volcando estructura para procedimiento northwind.BorrarEmpleado
DELIMITER //
CREATE PROCEDURE `BorrarEmpleado`(
    IN p_EmployeeID INTEGER
)
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = p_EmployeeID;
END//
DELIMITER ;

-- Volcando estructura para procedimiento northwind.BuscarPorID
DELIMITER //
CREATE PROCEDURE `BuscarPorID`(
	IN `p_EmployeeID` INTEGER
)
BEGIN
    SELECT 
        EmployeeID, 
        LastName, 
        FirstName, 
        BirthDate, 
        Photo, 
        notes
    FROM Employees
    WHERE EmployeeID = p_EmployeeID;
END//
DELIMITER ;

-- Volcando estructura para tabla northwind.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `CategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(25) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla northwind.customers
CREATE TABLE IF NOT EXISTS `customers` (
  `CustomerID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerName` varchar(50) DEFAULT NULL,
  `ContactName` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `City` varchar(20) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento northwind.DetalleEmpleado
DELIMITER //
CREATE PROCEDURE `DetalleEmpleado`()
BEGIN
	 select
	    EmployeedID,
	    LastName,
	    FirstName,
	    photo
   FROM employees; 
END//
DELIMITER ;

-- Volcando estructura para procedimiento northwind.DetalleEmpleados
DELIMITER //
CREATE PROCEDURE `DetalleEmpleados`()
BEGIN
    SELECT 
    EmployeeID,
    LastName,
    FirstName,
    photo
    FROM employees;
END//
DELIMITER ;

-- Volcando estructura para tabla northwind.employees
CREATE TABLE IF NOT EXISTS `employees` (
  `EmployeeID` int(11) NOT NULL AUTO_INCREMENT,
  `LastName` varchar(15) DEFAULT NULL,
  `FirstName` varchar(15) DEFAULT NULL,
  `BirthDate` datetime DEFAULT NULL,
  `Photo` varchar(25) DEFAULT NULL,
  `Notes` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento northwind.InsertarDatos
DELIMITER //
CREATE PROCEDURE `InsertarDatos`(
    IN p_LastName VARCHAR(15),
    IN p_FirstName VARCHAR(15),
    IN p_BirthDate DATETIME,
    IN p_Photo VARCHAR(25),
    IN p_Notes VARCHAR(1024)
)
BEGIN
    INSERT INTO Employees (LastName, FirstName, BirthDate, Photo, Notes)
    VALUES (p_LastName, p_FirstName, p_BirthDate, p_Photo, p_Notes);
END//
DELIMITER ;

-- Volcando estructura para tabla northwind.orderdetails
CREATE TABLE IF NOT EXISTS `orderdetails` (
  `OrderDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`OrderDetailID`),
  KEY `OrderID` (`OrderID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla northwind.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `ShipperID` int(11) DEFAULT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `EmployeeID` (`EmployeeID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `ShipperID` (`ShipperID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`ShipperID`) REFERENCES `shippers` (`ShipperID`)
) ENGINE=InnoDB AUTO_INCREMENT=10444 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla northwind.products
CREATE TABLE IF NOT EXISTS `products` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(50) DEFAULT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `Unit` varchar(25) DEFAULT NULL,
  `Price` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`ProductID`),
  KEY `CategoryID` (`CategoryID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`CategoryID`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento northwind.ReallCategories
DELIMITER //
CREATE PROCEDURE `ReallCategories`()
BEGIN
	 select
	    CategoryID,
	    CategoryName,
	    Description
   FROM categories; 
END//
DELIMITER ;

-- Volcando estructura para tabla northwind.shippers
CREATE TABLE IF NOT EXISTS `shippers` (
  `ShipperID` int(11) NOT NULL AUTO_INCREMENT,
  `ShipperName` varchar(25) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ShipperID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla northwind.suppliers
CREATE TABLE IF NOT EXISTS `suppliers` (
  `SupplierID` int(11) NOT NULL AUTO_INCREMENT,
  `SupplierName` varchar(50) DEFAULT NULL,
  `ContactName` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `City` varchar(20) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
