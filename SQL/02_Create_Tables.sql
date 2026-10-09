
--USE DATABASE
USE RetailSalesDB;

--1.CREATE CUSTOMERS TABLE
CREATE TABLE Customers(
customer_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
city VARCHAR(50),
country VARCHAR(50),
signup_date DATE NOT NULL);

--2.CREATE PRODUCTS TABLE
CREATE TABLE Products(
product_id INT PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL,
price DECIMAL(10,2) NOT NULL);

--3.CREATE ORDERS TABLE
CREATE TABLE Orders(
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE NOT NULL,
order_status VARCHAR(30) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

--4.CREATE ORDER DEATILS TABLE
CREATE TABLE Order_Details(
order_detail_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (product_id) REFERENCES Products(product_id));

