/*
	Create Database for Fetch - Data Analyst Take Home
	Tables:
		- Products
		- Transactions
		- Users
*/

CREATE DATABASE FetchRewards;
USE FetchRewards;

-- Check the tables and columns from the information schema (initially, only includes default system tables)
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS;

CREATE TABLE Users (
    id VARCHAR(50) PRIMARY KEY,
    created_date DATETIME,
    birth_date DATETIME,
    state VARCHAR(50),
    language VARCHAR(50),
    gender VARCHAR(50)
)
BULK INSERT Users
FROM 'C:\Users\ankur\Documents\Data Science\Projects\Interview\Fetch\Data Analyst\Fetch-Coding-Challenge-DA\output\users_clean.csv'
WITH (
    FIELDTERMINATOR = ',',  -- or the delimiter used in your CSV
    ROWTERMINATOR = '\n',   -- or '\r\n' depending on your CSV file
    FIRSTROW = 2,           -- Skip header row if it exists
    TABLOCK
);


CREATE TABLE Products (
    category_1 VARCHAR(100),
    category_2 VARCHAR(100),
    category_3 VARCHAR(100),
    category_4 VARCHAR(100),
    manufacturer VARCHAR(100),
    brand VARCHAR(100),
    barcode VARCHAR(50) PRIMARY KEY
)
BULK INSERT Products
FROM 'C:\Users\ankur\Documents\Data Science\Projects\Interview\Fetch\Data Analyst\Fetch-Coding-Challenge-DA\output\products_clean.csv'
WITH (
    FIELDTERMINATOR = ',',  -- or the delimiter used in your CSV
    ROWTERMINATOR = '\n',   -- or '\r\n' depending on your CSV file
    FIRSTROW = 2,           -- Skip header row if it exists
    TABLOCK
);


CREATE TABLE Transactions (
    receipt_id VARCHAR(50),
    purchase_date DATETIME,
    scan_date DATETIME,
    store_name VARCHAR(100),
    user_id VARCHAR(50) ,
    barcode VARCHAR(50),
    final_quantity NUMERIC(10, 2),
    final_sale NUMERIC(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (barcode) REFERENCES Products(barcode)
)
BULK INSERT Transactions
FROM 'C:\Users\ankur\Documents\Data Science\Projects\Interview\Fetch\Data Analyst\Fetch-Coding-Challenge-DA\output\transactions_clean.csv'
WITH (
    FIELDTERMINATOR = ',',  -- or the delimiter used in your CSV
    ROWTERMINATOR = '\n',   -- or '\r\n' depending on your CSV file
    FIRSTROW = 2,           -- Skip header row if it exists
    TABLOCK
);


-- Check the created tables and columns in FetchRewards database
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS;
