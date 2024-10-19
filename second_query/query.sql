USE FetchRewards;

-- Check the created tables and columns in FetchRewards database
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS;

/* 
Closed-ended Questions: 
*/ 

/* 
	What are the top 5 brands by receipts scanned among users 21 and over?
	- CTE of users aged 21/+, then join with products and transactions for top 5 brands
*/ 
WITH users_over_21 AS (
	SELECT id, (YEAR(GETDATE()) - YEAR(birth_date)) as age
	FROM users
	WHERE (YEAR(GETDATE()) - YEAR(birth_date)) >= 21
)
SELECT TOP 5 p.brand, COUNT(t.receipt_id) as receipt_cnt
FROM users_over_21 u
JOIN transactions t ON t.user_id = u.id
JOIN products p ON p.barcode = t.barcode
WHERE p.brand is not null
GROUP BY p.brand
ORDER BY receipt_cnt DESC
;

/* 
	What are the top 5 brands by sales among users that have had their account for at least six months?	
*/ 
SELECT TOP 5 p.brand, SUM(t.final_sale) AS total_sales
FROM transactions t
JOIN users u ON t.user_id = u.id
JOIN products p ON t.barcode = p.barcode
WHERE DATEDIFF(MONTH, u.created_date, GETDATE()) >= 6
GROUP BY p.brand
ORDER BY total_sales DESC
;


/* 
Open-ended Questions: 
*/ 

/*  
	Who are Fetch’s power users?
	Assumption: Power users are defined as those who have the highest number of transactions.
	- CTE of receipts per used by joining users and transactions 
	- Filter CTE to top 3 users for number of receipts as power users
*/
WITH user_receipts AS (
	SELECT u.id, COUNT(t.receipt_id) as receipt_cnt, SUM(t.final_sale) as total_sales, DENSE_RANK() OVER (ORDER BY COUNT(t.receipt_id) DESC) as rank
	FROM users u
	JOIN transactions t ON u.id = t.user_id
	GROUP BY u.id
)
SELECT ur.id, u.state, u.gender, ur.receipt_cnt, ur.total_sales
FROM user_receipts ur
LEFT JOIN users u ON ur.id=u.id
WHERE ur.rank <= 3
ORDER BY ur.rank ASC
;

