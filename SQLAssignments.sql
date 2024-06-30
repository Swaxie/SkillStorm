USE demo;
GO
USE master;
DROP TABLE users;
GO
-- E01

CREATE TABLE users (
    user_id INT IDENTITY PRIMARY KEY,
    user_first_name VARCHAR(30) NOT NULL,
    user_last_name VARCHAR(30) NOT NULL,
    user_email_id VARCHAR(50) NOT NULL,
    user_email_validated BIT DEFAULT 0,
    user_password VARCHAR(200),
    user_role VARCHAR(1) NOT NULL DEFAULT 'U', --U and A
    is_active BIT DEFAULT 0,
    created_dt DATE DEFAULT GETDATE()
);

-- E02
-- Exercise 1 - Create Table

CREATE TABLE courses (
	course_id INT IDENTITY,
	course_name VARCHAR(60) NOT NULL,
	course_author VARCHAR(40) NOT NULL,
	course_status VARCHAR(10) NOT NULL,
	course_published_dt DATE
);

ALTER TABLE courses
ADD CONSTRAINT pk_courses_course_id PRIMARY KEY CLUSTERED (course_id),
	CONSTRAINT check_course_status CHECK (course_status = 'published' OR course_status = 'draft' OR course_status = 'inactive');

SELECT * FROM courses

-- Exercise 2 - Inserting Data
INSERT INTO courses
	(course_name, course_author, course_status, course_published_dt)
VALUES
	('Programming using Python', 'Bob Dillon', 'published', CONVERT(DATE,'2020-09-30')),
	('Data Engineering using Python', 'Bob Dillon', 'published', CONVERT(DATE, '2020-07-15')),
	('Data Engineering using Scala', 'Elvis Presley', 'draft', NULL),
	('Programming using Scala', 'Elvis Presley', 'published', CONVERT(DATE, '2020-07-15')),
	('Programming using Java', 'Mike Jack', 'inactive', CONVERT(DATE, '2020-08-10')),
	('Web Applications - Python Flask', 'Bob Dillon', 'inactive', CONVERT(DATE, '2020-07-20')),
	('Web Applications - Java Spring', 'Mike Jack', 'draft', NULL),
	('Pipeline Orchestration - Python', 'Bob Dillon', 'draft', NULL),
	('Streaming Pipelines - Python', 'Bob Dillon', 'published', CONVERT(DATE, '2020-10-05')),
	('Web Applications - Scala Play', 'Elivs Presley', 'inactive', CONVERT(DATE, '2020-09-30')),
	('Web Applications - Python Django', 'Bob Dillon', 'published', CONVERT(DATE, '2020-06-23')),
	('Server Automation - Ansible', 'Uncle Sam', 'published', CONVERT(DATE, '2020-07-05'));
GO

SELECT * FROM courses
-- Exercise 3 - Updating Data
BEGIN TRAN publish_py_scala;

UPDATE courses
SET course_status = 'published',
	course_published_dt = GETDATE()
WHERE (course_name LIKE '%Python%'
	OR course_name LIKE '%Scala%')
	AND course_status = 'draft';

ROLLBACK TRAN publish_py_scala;
COMMIT;

-- Exercise 4 - Deleting Data
BEGIN TRAN delete_inactive
DELETE FROM courses WHERE (course_status != 'published' AND course_status != 'draft')

ROLLBACK TRAN delete_inactive
COMMIT;

-- E03
USE retail_db;

-- Exercise 1 - Customer order count
SELECT orders.order_customer_id, customers.customer_fname, customers.customer_lname, COUNT(1) AS customer_order_count
FROM orders JOIN customers ON orders.order_customer_id = customers.customer_id
GROUP BY orders.order_customer_id, customers.customer_fname, customers.customer_lname, FORMAT(orders.order_date, 'yyyy-MM')
HAVING FORMAT(orders.order_date, 'yyyy-MM') = '2014-01'
ORDER BY customer_order_count desc,orders.order_customer_id;

-- Exercise 2 - Dormant Customers
SELECT c.*
FROM customers c WHERE c.customer_id NOT IN
	(SELECT o.order_customer_id
	FROM orders o 
	GROUP BY o.order_customer_id, FORMAT(o.order_date, 'yyyy-MM')
	HAVING FORMAT(o.order_date, 'yyyy-MM') = '2014-01')
ORDER BY c.customer_id;

-- Exercise 3 - Revenue Per Customer
SELECT TOP 10 * FROM orders;
SELECT TOP 10 * FROM order_items;

SELECT c.customer_id, c.customer_fname, c.customer_lname, SUM(oi.order_item_subtotal) AS [Revenue]
FROM customers c 
	LEFT OUTER JOIN
	(orders o JOIN order_items oi ON oi.order_item_order_id = o.order_id
	AND (o.order_status LIKE 'COMPLETE%' OR o.order_status LIKE 'CLOSED%')
	AND FORMAT(o.order_date, 'yyyy-MM') = '2014-01')
	ON c.customer_id = o.order_customer_id
GROUP BY c.customer_id, c.customer_fname, c.customer_lname, o.order_status, FORMAT(o.order_date, 'yyyy-MM')
ORDER BY [Revenue] DESC, c.customer_id;

-- Exercise 4 - Revenue Per Category
SELECT * FROM categories;
SELECT TOP 1 * FROM products;
SELECT TOP 1 * FROM orders;
SELECT TOP 1 * FROM order_items;

SELECT c.category_id, c.category_name, cast(SUM(oi.order_item_subtotal) AS DECIMAL(20,2)) [category_revenue]
FROM categories c 
	LEFT OUTER JOIN 
	(products p JOIN order_items oi ON p.product_id = oi.order_item_product_id
	JOIN orders o ON oi.order_item_order_id = o.order_id
	AND (o.order_status LIKE 'COMPLETE%' OR o.order_status LIKE 'CLOSED%')
	AND FORMAT(o.order_date, 'yyyy-MM') = '2014-01')
	ON c.category_id = p.product_category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_id;

SELECT * FROM products WHERE (product_category_id = 1) 

-- Exercise 5 - Product Count Per Department
SELECT d.department_id, d.department_name, SUM(1) [product_count]
FROM departments d
	LEFT OUTER JOIN
	categories c ON d.department_id = c.category_department_id
	LEFT OUTER JOIN
	products p ON p.product_category_id = c.category_department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id

-- E06
-- Exercise 1
CREATE TABLE users (
    user_id int PRIMARY KEY IDENTITY,
    user_first_name VARCHAR(30),
    user_last_name VARCHAR(30),
    user_email_id VARCHAR(50),
    user_gender VARCHAR(1),
    user_unique_id VARCHAR(15),
    user_phone_no VARCHAR(20),
    user_dob DATE,
    created_ts DATETIME
);
insert into users (
    user_first_name, user_last_name, user_email_id, user_gender, 
    user_unique_id, user_phone_no, user_dob, created_ts
) VALUES
    ('Giuseppe', 'Bode', 'gbode0@imgur.com', 'M', '88833-8759', 
     '+86 (764) 443-1967', '1973-05-31', '2018-04-15 12:13:38'),
    ('Lexy', 'Gisbey', 'lgisbey1@mail.ru', 'N', '262501-029', 
     '+86 (751) 160-3742', '2003-05-31', '2020-12-29 06:44:09'),
    ('Karel', 'Claringbold', 'kclaringbold2@yale.edu', 'F', '391-33-2823', 
     '+62 (445) 471-2682', '1985-11-28', '2018-11-19 00:04:08'),
    ('Marv', 'Tanswill', 'mtanswill3@dedecms.com', 'F', '1195413-80', 
     '+62 (497) 736-6802', '1998-05-24', '2018-11-19 16:29:43'),
    ('Gertie', 'Espinoza', 'gespinoza4@nationalgeographic.com', 'M', '471-24-6869', 
     '+249 (687) 506-2960', '1997-10-30', '2020-01-25 21:31:10'),
    ('Saleem', 'Danneil', 'sdanneil5@guardian.co.uk', 'F', '192374-933', 
     '+63 (810) 321-0331', '1992-03-08', '2020-11-07 19:01:14'),
    ('Rickert', 'O''Shiels', 'roshiels6@wikispaces.com', 'M', '749-27-47-52', 
     '+86 (184) 759-3933', '1972-11-01', '2018-03-20 10:53:24'),
    ('Cybil', 'Lissimore', 'clissimore7@pinterest.com', 'M', '461-75-4198', 
     '+54 (613) 939-6976', '1978-03-03', '2019-12-09 14:08:30'),
    ('Melita', 'Rimington', 'mrimington8@mozilla.org', 'F', '892-36-676-2', 
     '+48 (322) 829-8638', '1995-12-15', '2018-04-03 04:21:33'),
    ('Benetta', 'Nana', 'bnana9@google.com', 'N', '197-54-1646', 
     '+420 (934) 611-0020', '1971-12-07', '2018-10-17 21:02:51'),
    ('Gregorius', 'Gullane', 'ggullanea@prnewswire.com', 'F', '232-55-52-58', 
     '+62 (780) 859-1578', '1973-09-18', '2020-01-14 23:38:53'),
    ('Una', 'Glayzer', 'uglayzerb@pinterest.com', 'M', '898-84-336-6', 
     '+380 (840) 437-3981', '1983-05-26', '2019-09-17 03:24:21'),
    ('Jamie', 'Vosper', 'jvosperc@umich.edu', 'M', '247-95-68-44', 
     '+81 (205) 723-1942', '1972-03-18', '2020-07-23 16:39:33'),
    ('Calley', 'Tilson', 'ctilsond@issuu.com', 'F', '415-48-894-3', 
     '+229 (698) 777-4904', '1987-06-12', '2020-06-05 12:10:50'),
    ('Peadar', 'Gregorowicz', 'pgregorowicze@omniture.com', 'M', '403-39-5-869', 
     '+7 (267) 853-3262', '1996-09-21', '2018-05-29 23:51:31'),
    ('Jeanie', 'Webling', 'jweblingf@booking.com', 'F', '399-83-05-03', 
     '+351 (684) 413-0550', '1994-12-27', '2018-02-09 01:31:11'),
    ('Yankee', 'Jelf', 'yjelfg@wufoo.com', 'F', '607-99-0411', 
     '+1 (864) 112-7432', '1988-11-13', '2019-09-16 16:09:12'),
    ('Blair', 'Aumerle', 'baumerleh@toplist.cz', 'F', '430-01-578-5', 
     '+7 (393) 232-1860', '1979-11-09', '2018-10-28 19:25:35'),
    ('Pavlov', 'Steljes', 'psteljesi@macromedia.com', 'F', '571-09-6181', 
     '+598 (877) 881-3236', '1991-06-24', '2020-09-18 05:34:31'),
    ('Darn', 'Hadeke', 'dhadekej@last.fm', 'M', '478-32-02-87', 
     '+370 (347) 110-4270', '1984-09-04', '2018-02-10 12:56:00'),
    ('Wendell', 'Spanton', 'wspantonk@de.vu', 'F', null, 
     '+84 (301) 762-1316', '1973-07-24', '2018-01-30 01:20:11'),
    ('Carlo', 'Yearby', 'cyearbyl@comcast.net', 'F', null, 
     '+55 (288) 623-4067', '1974-11-11', '2018-06-24 03:18:40'),
    ('Sheila', 'Evitts', 'sevittsm@webmd.com', null, '830-40-5287',
     null, '1977-03-01', '2020-07-20 09:59:41'),
    ('Sianna', 'Lowdham', 'slowdhamn@stanford.edu', null, '778-0845', 
     null, '1985-12-23', '2018-06-29 02:42:49'),
    ('Phylys', 'Aslie', 'paslieo@qq.com', 'M', '368-44-4478', 
     '+86 (765) 152-8654', '1984-03-22', '2019-10-01 01:34:28');

-- Get all the number of users created per year
SELECT YEAR(created_ts) AS [created_year], SUM(1) AS [user_count] FROM users
GROUP BY YEAR(created_ts);

-- Exercise 2
-- Get the day name of the birth days for all the users born in the month of June
SELECT user_id, user_dob, user_email_id, DATENAME(dw,user_dob) AS user_day_of_birth FROM users
WHERE MONTH(user_dob) = 5
ORDER BY DAY(user_dob);

UPDATE orders
SET order_status = REPLACE(order_status, CHAR(13), '');

SELECT * FROM users
-- Exercise 3
-- Get the names and email ids of users added in year 2019
SELECT user_id, UPPER(CONCAT(user_first_name, ' ', user_last_name)) as [user_name], user_email_id, created_ts, YEAR(created_ts) AS created_year FROM users
WHERE YEAR(created_ts) = 2019
ORDER BY [user_name];

-- Exercise 4
-- Get the number of users by gender
SELECT user_gender = CASE user_gender
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		WHEN 'N' THEN 'Non-Binary'
		ELSE 'Not Specified'
		END,
		COUNT(1) AS user_count FROM users
GROUP BY user_gender
ORDER BY user_count DESC;

-- Exercise 5
-- Get last 4 digits of unique ids
SELECT user_id, user_unique_id, 
	user_unique_id_last4 = CASE
		WHEN LEN(REPLACE(user_unique_id,'-','')) < 9 THEN 'Invalid Unique Id'
		WHEN user_unique_id IS NULL THEN 'Not Specified'
		ELSE RIGHT(REPLACE(user_unique_id,'-',''),4)
	END
FROM users;

-- Exercise 6
-- Get the count of users based up on country code
SELECT CAST(REPLACE(SUBSTRING(user_phone_no, 1, LEN(user_phone_no) - 15),'+','') AS INT) AS country_code, COUNT(1) FROM users
GROUP BY REPLACE(SUBSTRING(user_phone_no, 1, LEN(user_phone_no) - 15),'+','')
HAVING CAST(REPLACE(SUBSTRING(user_phone_no, 1, LEN(user_phone_no) - 15),'+','') AS INT) IS NOT NULL
ORDER BY country_code;

-- Exercise 7
SELECT COUNT(1) as [count] FROM order_items
WHERE ROUND(order_item_quantity * order_item_product_price, 2) != order_item_subtotal;

-- Exercise 8
-- Get number of orders placwd on weekdays and weekends in the month of Januray 2014
SELECT IIF(DATENAME(dw, order_date) IN ('Saturday', 'Sunday'), 'Weekend days', 'Week days') AS day_type ,COUNT(1) as order_count FROM orders
WHERE FORMAT(order_date, 'yyyy-MM') LIKE '2014-01%'
GROUP BY IIF(DATENAME(dw, order_date) IN ('Saturday', 'Sunday'), 'Weekend days', 'Week days')
ORDER BY order_count;

-- E07
-- Exercise 1
-- Retrieve the names of categories that have more than 5 products
SELECT TOP 5 * FROM categories;
SELECT TOP 5 * FROM order_items;

SELECT c.category_name, pc.prod_count FROM 
	(SELECT p.product_category_id, COUNT(1) as prod_count FROM products p
	GROUP BY p.product_category_id HAVING COUNT(1) > 5) pc 
	JOIN categories c on c.category_id = pc.product_category_id
	ORDER BY pc.prod_count, category_name;

-- Exercise 2: Subquery in WHERE Clause
SELECT c.customer_fname [First Name], c.customer_lname [Last Name], o.purchases_made [Purchases Made] 
FROM (SELECT o.order_customer_id, COUNT(1) AS purchases_made FROM orders o
GROUP BY o.order_customer_id) o JOIN customers c ON o.order_customer_id = c.customer_id
WHERE o.purchases_made > 10 ORDER BY o.purchases_made;

-- Exercise 3: Subquery in SELECT Clause
-- Display the product names along with the average price of all products that were ordered in October 2013
SELECT DISTINCT p.product_name, 
	(SELECT AVG(oi.order_item_product_price)
		FROM order_items oi JOIN orders o
		ON oi.order_item_order_id = o.order_id
		GROUP BY FORMAT(o.order_date,'yyyy-MM') 
		HAVING FORMAT(o.order_date, 'yyyy-MM') LIKE '2013-10'
	) [Average Price]
FROM products p 
	JOIN order_items oi 
	ON p.product_id = oi.order_item_product_id
	JOIN orders o
	ON oi.order_item_order_id = o.order_id
WHERE FORMAT(o.order_date, 'yyyy-MM') LIKE '2013-10%'
GROUP BY p.product_name;

-- Exercise 4: Subquery with Aggregate Functions
-- List the orders that have a total amount greater than the average order

SELECT o.order_id, SUM(oi.order_item_subtotal) AS [Total Amount]
INTO order_totals
FROM orders o 
JOIN order_items oi 
	ON o.order_id = oi.order_item_order_id
GROUP BY o.order_id;
GO

SELECT ot.order_id FROM order_totals ot
	WHERE ot.[Total Amount] > (SELECT AVG(order_totals.[Total Amount]) FROM order_totals);
GO

DROP TABLE order_totals;
GO

-- Exercise 5: Basic Common Table Expressions (CTE)

WITH pc AS (
	SELECT c.category_id, c.category_name, COUNT(1) as prod_count 
	FROM products p 
	JOIN categories c
		ON p.product_category_id = c.category_id
	GROUP BY c.category_id, c.category_name
	)

SELECT TOP 3 * FROM pc ORDER BY pc.prod_count DESC;

-- Exercise 6: Nested CTEs

WITH dec_cust AS(SELECT o.order_customer_id, SUM(oi.order_item_subtotal) as total_spent
FROM orders o JOIN order_items oi ON o.order_id = oi.order_item_order_id
AND MONTH(o.order_date) = 12
GROUP BY o.order_customer_id)

SELECT c.customer_id, c.customer_fname, c.customer_lname, dec_cust.total_spent
FROM customers c JOIN dec_cust ON dec_cust.order_customer_id = c.customer_id
WHERE dec_cust.total_spent > (
	SELECT AVG(dec_cust.total_spent) FROM dec_cust)
;

-- E08
-- Exercise 1
-- Get all the employees who are making more than average salary within each department
-- employees and departments tables
USE hr_db;
GO

SELECT e.employee_id, d.department_name, e.salary, e.avg_salary_expense 
FROM (
	SELECT *, 
	CAST(ROUND(AVG(e.salary) OVER 
	(PARTITION BY e.department_id), 2) 
	AS DECIMAL (18,2)) avg_salary_expense 
	FROM employees e
) e JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > e.avg_salary_expense
ORDER BY d.department_id, e.salary DESC;

-- Exercise 2
-- Get cumulative salary within each department for Finance and IT department along wiht department name
-- employees and departments
SELECT e.employee_id, d.department_name, e.salary, 
	SUM(e.salary) OVER (
		PARTITION BY e.department_id 
		ORDER BY e.salary
	) cum_salary_expense
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name IN ('Finance', 'IT')
ORDER BY d.department_name, e.salary;

-- Exercise 3
-- Get top 3 paid employees within each department by salary (use dense_rank)
-- employees and departments
SELECT e.employee_id, e.department_id, d.department_name, e.salary, e.employee_rank 
FROM (SELECT *, 
		DENSE_RANK() OVER (
			PARTITION BY e.department_id
			ORDER BY e.salary DESC
			) employee_rank
	FROM employees e
) e JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_rank <= 3;

-- Exercise 4
-- Get top 3 products sold in the month of 2014 January by revenue
-- orders, order_items, products
USE retail_db;
GO

SELECT TOP 3 p.product_id, p.product_name, oi.revenue,
DENSE_RANK() OVER(ORDER BY oi.revenue DESC) product_rank
FROM (SELECT oi.order_item_product_id, CAST(SUM(oi.order_item_subtotal) AS DECIMAL(18,2)) revenue
	FROM order_items oi JOIN orders o 
	ON o.order_id = oi.order_item_order_id
	AND FORMAT(o.order_date, 'yyyy-MM') LIKE '2014-01'
	AND o.order_status IN ('COMPLETE', 'CLOSED')
	GROUP BY oi.order_item_product_id) oi JOIN products p
ON oi.order_item_product_id = p.product_id
ORDER BY oi.revenue DESC;

-- Exercise 5
-- Get top 3 products sold in the month of 2014 January under selected categories by revenue
-- Cardio Equipment and Strength Training

SELECT * FROM (
	SELECT c.category_id, c.category_name, p.product_id, p.product_name,
	SUM(oi.order_item_subtotal) revenue, 
	DENSE_RANK() OVER (PARTITION BY c.category_id ORDER BY SUM(oi.order_item_subtotal) DESC) product_rank
	FROM categories c JOIN products p ON c.category_id = p.product_category_id
	JOIN order_items oi ON p.product_id = oi.order_item_product_id
	JOIN orders o on oi.order_item_order_id = o.order_id
	AND FORMAT(o.order_date, 'yyyy-MM') LIKE '2014-01'
	AND o.order_status IN ('COMPLETE', 'CLOSED')
	AND (c.category_name LIKE 'Cardio Equipment%' OR c.category_name LIKE 'Strength Training%')
	GROUP BY p.product_id, c.category_id, c.category_name, p.product_id, p.product_name
	) r 
WHERE r.product_rank <= 3
ORDER BY r.category_id, r.revenue DESC;