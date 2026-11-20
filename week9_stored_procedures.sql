USE company;

-- 1. Prosedür: Ülkeye Göre Müşteri Listeleme
DROP PROCEDURE IF EXISTS SelectCustomerByCountry;
DELIMITER $$
CREATE PROCEDURE SelectCustomerByCountry(IN c VARCHAR(45))
BEGIN
    SELECT * FROM Customers
    WHERE Country = c;
END $$
DELIMITER ;

SET @country = 'Spain';
SELECT @country;
CALL SelectCustomerByCountry(@country);
SELECT @country;


-- 2. Prosedür: Kargo Firmasına Göre Sipariş Sayısı
DROP PROCEDURE IF EXISTS GetOrderCountByShipper;
DELIMITER $$
CREATE PROCEDURE GetOrderCountByShipper(IN shipper VARCHAR(45), OUT count INT)
BEGIN 
    SELECT COUNT(OrderID) INTO count
    FROM Orders 
    JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
    WHERE ShipperName = shipper; 
END $$
DELIMITER ;

SELECT ShipperName FROM Shippers;
SET @order_cnt = 0;
SELECT @order_cnt;
CALL GetOrderCountByShipper('United Package', @order_cnt);
SELECT @order_cnt;


-- 3. Prosedür: Müşteri Adı ve Toplam Satış Tutarı
DROP PROCEDURE IF EXISTS GetCustomerSalesOut;
DELIMITER $$
CREATE PROCEDURE GetCustomerSalesOut(
    IN inCustomerID INT,
    OUT outName VARCHAR(255),
    OUT outSales DECIMAL(10, 2)
)
BEGIN
    SELECT CustomerName INTO outName
    FROM Customers 
    WHERE CustomerID = inCustomerID;
    
    SELECT IFNULL(SUM(p.Price * od.Quantity), 0) INTO outSales
    FROM Orders o 
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    WHERE o.CustomerID = inCustomerID;
END $$
DELIMITER ;

CALL GetCustomerSalesOut(5, @name, @sales); 
SELECT @name, @sales;

CALL GetCustomerSalesOut(1, @name, @sales); 
SELECT @name, @sales;
