# To Create Tables

# For Table Products

use data_with_baraa;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Product VARCHAR(50) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);


INSERT INTO Products (ProductID, Product, Category, Price)
VALUES 
(101, 'Bottle', 'Accessories', 10.00),
(102, 'Tire', 'Accessories', 15.00),
(103, 'Socks', 'Clothing', 20.00),
(104, 'Caps', 'Clothing', 25.00),
(105, 'Gloves', 'Clothing', 30.00);

select * from products;

-- **************************************************************************************************************************************

# For Table OrdersArchive

CREATE TABLE OrdersArchive (
    OrderID INT,
    ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(20),
    ShipAddress VARCHAR(255),
    BillAddress VARCHAR(255),
    Quantity INT,
    Sales DECIMAL(10, 2),
    CreationTime time
);

drop table OrdersArchive;

INSERT INTO OrdersArchive (
    OrderID, ProductID, CustomerID, SalesPersonID, 
    OrderDate, ShipDate, OrderStatus, ShipAddress, 
    BillAddress, Quantity, Sales, CreationTime
)
VALUES 
(1, 101, 2, 3, '2024-04-01', '2024-04-05', 'Shipped', '123 Main St', '456 Billing St', 1, 10, '00:34:56'),
(2, 102, 3, 3, '2024-04-05', '2024-04-10', 'Shipped', '456 Elm St', '789 Billing St', 1, 15, '00:22:04'),
(3, 101, 1, 4, '2024-04-10', '2024-04-25', 'Shipped', '789 Maple St', '789 Maple St', 2, 20, '00:24:08'),
(4, 105, 1, 3, '2024-04-20', '2024-04-25', 'Shipped', '987 Victory Lane', NULL, 2, 60, '00:50:33'),
(4, 105, 1, 3, '2024-04-20', '2024-04-25', 'Delivered', '987 Victory Lane', NULL, 2, 60, '00:50:33'),
(5, 104, 2, 5, '2024-05-01', '2024-05-05', 'Shipped', '345 Oak St', '678 Pine St', 1, 25, '00:02:41'),
(6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered', '543 Belmont Rd.', NULL, 2, 50, '00:34:57'),
(6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered', '543 Belmont Rd.', '3768 Door Way', 2, 50, '00:22:05'),
(6, 101, 3, 5, '2024-05-05', '2024-05-10', 'Delivered', '543 Belmont Rd.', '3768 Door Way', 2, 50, '00:36:55'),
(7, 102, 3, 5, '2024-06-15', '2024-06-20', 'Shipped', '111 Main St', '222 Billing St', 0, 60, '00:25:15');

select * from OrdersArchive;


