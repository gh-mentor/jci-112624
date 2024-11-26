/*
This file contains a script of Transact SQL (T-SQL) command to interact with a database named 'Inventory'.
Requirements:
- referential integrity is enforced
- triggers are used to enforce business rules
- stored procedures are used to encapsulate business logic
- functions are used to return values
- views are used to display data
Steps:
- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
- Set the default database to 'Inventory'.
- Create a 'suppliers' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- address: 255 characters, nullable
-- city: 50 characters, not null
-- state: 2 characters, not null
- Create the 'categories' table with a one-to-many relation to the 'suppliers'. Use the following columns:
-- id:  integer, primary key
-- name: 50 characters, not null
-- description:  255 characters, nullable
-- supplier_id: int, foreign key references suppliers(id)
- Create the 'products' table with a one-to-many relation to the 'categories' table. Use the following columns:
-- id: integer, primary key
-- name: 50 characters, not null
-- price: decimal (10, 2), not null
-- category_id: int, foreign key references categories(id)
- Populate the 'suppliers' table with sample data.
- Populate the 'categories' table with sample data.
- Populate the 'products' table with sample data.
- Create a view named 'product_list' that displays the following columns:
-- product_id
-- product_name
-- category_name
-- supplier_name
- Create a stored procedure named 'get_product_list' that returns the product list view.
- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
- Create a function that returns the total number of products in a category.
- Create a function that returns the total number of products supplied by a supplier.
*/

-- Check if the database 'Inventory' exists, if it does exist, drop it and create a new one.
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Inventory')
BEGIN
    ALTER DATABASE Inventory SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Inventory;
END

CREATE DATABASE Inventory;
GO

-- Set the default database to 'Inventory'.
USE Inventory;
GO

-- Create a 'suppliers' table.
CREATE TABLE suppliers
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL
);
GO

-- Create the 'categories' table with a one-to-many relation to the 'suppliers'.
CREATE TABLE categories
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);
GO

-- Create the 'products' table with a one-to-many relation to the 'categories' table. 
CREATE TABLE products
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    -- add a description column max 255 characters
    description VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    -- add a created_at column with default value of current date
    created_at DATETIME DEFAULT GETDATE(),
    -- add an updated_at column with default value of current date
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- Populate the 'suppliers' table with sample data.
INSERT INTO suppliers (id, name, address, city, state)
VALUES (1, 'Supplier A', '123 Main St', 'City A', 'CA'),
       (2, 'Supplier B', '456 Elm St', 'City B', 'NY'),
       (3, 'Supplier C', '789 Oak St', 'City C', 'TX');

-- Populate the 'categories' table with sample data.
INSERT INTO categories (id, name, description, supplier_id)
VALUES (1, 'Category A', 'Description A', 1),
       (2, 'Category B', 'Description B', 2),
       (3, 'Category C', 'Description C', 3),
       (4, 'Category D', 'Description D', 1),
       (5, 'Category E', 'Description E', 2);

-- Populate the 'products' table with sample data.
INSERT INTO products (id, name, price, category_id, description)
VALUES (1, 'Product A', 10.99, 1, 'Product A Description'),
       (2, 'Product B', 20.99, 2, 'Product B Description'),
       (3, 'Product C', 30.99, 3, 'Product C Description'),
       (4, 'Product D', 40.99, 4, 'Product D Description'),
       (5, 'Product E', 50.99, 5, 'Product E Description');

-- Create a view named 'product_list' that displays the following columns:
CREATE VIEW product_list AS
SELECT p.id AS product_id, p.name AS product_name, c.name AS category_name, s.name AS supplier_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON c.supplier_id = s.id;

-- Create a stored procedure named 'get_product_list' that returns the product list view.
CREATE PROCEDURE get_product_list
AS
BEGIN
    SELECT * FROM product_list;
END;

-- Create a trigger that updates the 'products' table when a 'categories' record is deleted.
CREATE TRIGGER update_products_on_delete
ON categories
AFTER DELETE
AS
BEGIN
    DELETE FROM products WHERE category_id IN (SELECT id FROM deleted);
END;

-- Create a function that returns the total number of products in a category.
CREATE FUNCTION get_total_products_in_category (@category_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products WHERE category_id = @category_id;
    RETURN @total_products;
END;

-- Create a function that returns the total number of products supplied by a supplier.
CREATE FUNCTION get_total_products_supplied_by_supplier (@supplier_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_products INT;
    SELECT @total_products = COUNT(*) FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE c.supplier_id = @supplier_id;
    RETURN @total_products;
END;

-- End of inventory.sql






