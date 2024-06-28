ALTER DATABASE myDB READ ONLY = 1; --to make the database readonly, can not drop this kind of db
ALTER DATABASE myDB READ ONLY = 0; --to revert it back

RENAME TABLE employees TO workers;

--to move the email column after the last_name column
ALTER TABLE employees
MODIFY email VARCHAR(100)
AFTER last_name;

--to move the email column to the first column
ALTER TABLE employees
MODIFY email VARCHAR(100)
FIRST;

ALTER TABLE employees
DROP COLUMN email;

-- #4 How to insert rows into a table
INSERT INTO employees
VALUES (1, "Mark", "John", 34.5, "2024-05-03")

--assume we want to add only few column. Then use this way
INSERT INTO employees(employee_id, first_name, last_name)
VALUES (1, "Mark", "John")

-- #5 How to update data from a table
-- updating multiple column.
UPDATE employees
SET hourly_pay = 10.25.
    hire_date = "2023-01-07"
WHERE employee_id = 5;

--if we do not define the WHERE clause, above query will update all the columns

DELETE FROM employees; --This will delete all the rows

DELETE FROM employees;
WHERE employee_id = 6;

--#7 Autocommit, commit, rollback

SET Autocommit = OFF --By default autocommit is on

--Then delete all the rows
DELETE FROM employees;
-- if auto commit is off, we can get those again using below command.
ROLLBACK;

--When auto commit is OFF we need to commit in order to actually happen in the db
DELETE FROM employees;
COMMIT;

--#8 getting current date and current time in mysql

CREATE TABLE test(
    my_date DATE,
    my_time TIME,
    my_datetime DATETIME
);

INSERT INTO test
VALUES(CURRENT_DATE(), CURRENT_TIME(), NOW());

SELECT * FROM test;

INSERT INTO test
VALUES(CURRENT_DATE() + 1, CURRENT_TIME(), NOW()); -- -1 also possible

-- #9 unique constraint   - "Constraint No - 1"
CREATE TABLE products(
    product_id INT,
    product_name VARCHAR(25) UNIQUE,
    price DECIMAL(4, 2) --maximum of 4 digits and 2 decimal places
);
-- Since we have added unique constraints to the product_name, we can not add duplicate product_names

--If we forgot to add the unique constraint at the time of table creation, no worries.
--we can add it later as follows too.
ALTER TABLE products
ADD CONSTRAINT
UNIQUE(product_name);

--#10 NOT NULL constraint    "Constraint No - 2"
CREATE TABLE products(
    product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2) NOT NULL
);

--If we forgot to add the not null constraint at the time of table creation, no worries.
--we can add it later as follows too.
ALTER TABLE products
MODIFY price DECIMAL(4, 2) NOT NULL;

--now lets try to add a null value to products
INSERT INTO products VALUES (104, "cookie", NULL); --this will give an error due to not null constraint
INSERT INTO products VALUES (104, "cookie", 0); -- So we need to give a value

--#11 check constraint    "Constraint No - 3"

--check constraint is used to check what values can be present in a column
--assume when entering data to the employees table, the hourly_pay should be greater that 10.
--we can do it as follows

CREATE TABLE employees(
    employee_id INT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    hourly_pay DECIMAL(4, 2),
    hire_date DATE,
    CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00)
);

-- to add the check constraint to already created table, user below query
ALTER TABLE employees
ADD CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00);

--now if we run below query we will get an error saying violation of check constraint
INSERT INTO employees
VALUES (6, "Mark", "John", 5.00, "2024-05-03")

--we can drop the inserted check constraint as follows
ALTER TABLE employees
DROP CHECK chk_hourly_pay;

--#12 Default constraint -        "Constraint No - 4"
-- when inserting new rows, if we do not specify a value, we can add a default value to it
INSERT INTO products
VALUES
(104, "cookie", 0);
(105, "cake", 0);
(106, "soap", 0);
(107, "towel", 0);

--in the above query price value is always 0;

--we can add a default value to this.
CREATE TABLE products(
    product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2) DEFAULT 0
);

--If we forgot to add the default constraint at the time of table creation, no worries.
--we can add it later as follows too.
ALTER TABLE products
ALTER price SET DEFAULT 0;

--After one of the above query lets try to execute an insert query.
INSERT INTO products(product_id, product_name)
VALUES
(104, "cookie");
(105, "cake");
(106, "soap");
(107, "towel");
--Above query will set 0.00 to price column by default

--eg: Every time when a record is inserted to this table, the transaction_date will be save as now.
CREATE TABLE transactions(
    transaction_id INT,
    amount DECIMAL(5, 2),
    transaction_date DATETIME DEFAULT NOW()
);

INSERT INTO transactions(transaction_id, amount)
VALUES (3, 8.37);


--#13 Primary Key constraint -        "Constraint No - 5"
--A table can only have one primary key

--Here is how we can add the primary key at the time of table creation.
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY,
    amount DECIMAL(5, 2)
);

--If we forgot to add the default constraint at the time of table creation, no worries.
--we can add it later as follows too.
ALTER TABLE transactions
ADD CONSTRAINT
PRIMARY KEY(transaction_id);

--if we tried to add multiple primary keys to the same table by executing below query,
--db engine will give the error saying "multiple primary key defined"
ALTER TABLE transactions
ADD CONSTRAINT
PRIMARY KEY(amount);

--Here is how we can insert data.
INSERT INTO transactions VALUES (100, 3.54);
INSERT INTO transactions VALUES (101, 4.25);
INSERT INTO transactions VALUES (101, 2.31);  -- this line will give an error saying "Duplicate entry"
INSERT INTO transactions VALUES (NULL, 2.31);  -- this line will give an error saying "Column transaction_id can not be null"
--each value that set for primary key column can not be null

--#14 Auto -increment attribute

--Here is how we can add the auto increment attribute at the time of table creation.
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2)
);

--Here is how we can insert data.
INSERT INTO transactions(amount) VALUES (3.54); --since we do not add all the fields
-- we need to specify which fields we are adding
--after executing above query we can see transaction_id it automatically set to 1.

--if we want we can specify the starting value of auto increment
ALTER TABLE transactions
AUTO_INCREMENT = 1000;
-- after this query, every time we insert data transaction_id will start increment from 1000.
--note: if there were transaction_ids as 1, 2, 3, 4. after executing above alter query and inserting data
--new id of 1000 will appear at the bottom of the table.

--#15 Foreign Key constraint -        "Constraint No - 6"

-- MySQL supports foreign keys, which permit cross-referencing related data across tables.
-- they help to keep the related data consistent.

-- Primary key of one table appears in another table as foreign key. By using this we can establish a link between two tables.

-- 1. let's create a new table as customers
CREATE TABLE customers(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
-- 2. populate the customer table
INSERT INTO customers(first_name, last_name)
VALUES ("Fred", "Fish"),
       ("Larry", "Lobster"),
       ("Bubble", "Bass");

-- 3. recreate the transactions table with foreign key
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

--If we forgot to add the foreign key constraint at the time of table creation, no worries.
--we can add it later as follows too.
ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id);

SELECT * FROM transactions;

-- 4. if we want to drop the foreign key, then use below query
ALTER TABLE transactions
DROP FOREIGN KEY transactions_ibfk_1;

-- 5. Now let's add data to transactions
INSERT INTO transactions (amount, customer_id)
VALUES (4.99, 3),
       (6.42, 2),
       (1.73, 3),
       (9.33, 1);

-- 6. Now if you try to delete a record in customer, it will not allowed due to foreign key constraint


--#16 JOINS

SELECT *
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;

-- will display all the rows in left table
SELECT *
FROM transactions LEFT JOIN customers
ON transactions.customer_id = customers.customer_id;

-- will display all the rows in right table
SELECT *
FROM transactions RIGHT JOIN customers
ON transactions.customer_id = customers.customer_id;

--#17 functions in sql

SELECT COUNT(amount)
FROM transactions;

SELECT COUNT(amount) AS "today's transactions"
FROM transactions;

SELECT MAX(amount) AS "maximum"
FROM transactions;

SELECT MIN(amount) AS "minimum"
FROM transactions;

SELECT AVG(amount) AS "average"
FROM transactions;

SELECT SUM(amount) AS "sum"
FROM transactions;

SELECT CONCAT(first_name, " ", last_name) AS "full_name"
FROM employees;

--#18 MySQL Logical operators

SELECT *
FROM employees
WHERE hire_date < "2024-01-05" AND job = "cook";

SELECT *
FROM employees
WHERE job = "cook" OR job = "cashier";

SELECT *
FROM employees
WHERE NOT job = "cook";

SELECT *
FROM employees
WHERE NOT job = "cook" AND
NOT job = "manager";

--BETWEEN is used for a single column
SELECT *
FROM employees
WHERE hire_date BETWEEN "2023-04-23" AND "2023-05-23";

SELECT *
FROM employees
WHERE job IN ("cook", "cashier", "manager");

--#19 MySQL wild cards

-- wild card characters % _
-- used to substitute one or more characters in a string
SELECT *
FROM employees
WHERE first_name LIKE 's%';

SELECT *
FROM employees
WHERE hire_date LIKE '____-01-__';

-- to get employees whose first_name having 'a' as the second character
SELECT *
FROM employees
WHERE first_name LIKE '_a%';


--#20 MySQL ORDER BY clause
-- Sort the results either in ascending or descending order
SELECT *
FROM employees
ORDER BY last_name ASC;

SELECT *
FROM employees
ORDER BY last_name DESC;

--if a column has two similar values we can give another column to order by in asc or desc
SELECT *
FROM transactions
ORDER BY amount ASC, customer_id DESC;


--#21 MySQL LIMIT clause
-- used to limit the number of records that are queried.
SELECT * FROM customers
LIMIT 4;

SELECT * FROM customers
LIMIT 4, 4; -- the first number represent the offset. second number is the number of records that will be displayed.
--This query will return the rows of 5, 6, 7, 8

--eg: Assume a page should show 10 records.
-- 1st 10 records can be queries by below command
SELECT * FROM customers LIMIT 0, 10;

-- 2nd 10 records can be queries by below command
SELECT * FROM customers LIMIT 10, 10;

-- 3rd 10 records can be queries by below command
SELECT * FROM customers LIMIT 20, 10;


SELECT * FROM customers
ORDER BY last_name LIMIT 4;


--#22 MySQL UNIONS operator
-- This operator combines the results of two or more SELECT statements

-- NOTE. UNION Operator join rows
-- JOIN Operator join columns

--In order to get use of UNION operator there should be same number of column in both select queries.
SELECT first_name, last_name FROM employees
UNION --this operator merge duplicates records and show only unique results
SELECT first_name, last_name FROM customers;

SELECT first_name, last_name FROM employees
UNION ALL --this operator does not merge duplicates. It shows the result as it is
SELECT first_name, last_name FROM customers;


--#23 MySQL SELF JOINS
-- join another copy of a table to itself
-- used to compare rows of the same table
-- helps to display a hierarchy of data
SELECT a.customer_id, a.first_name, a.last_name,
       CONCAT(b.first_name, " ", b.last_name) AS "referred_by"
FROM customers AS a
INNER JOIN customers AS b
ON a.referral_id = b.customer_id;

SELECT a.first_name, a.last_name,
       CONCAT(b.first_name, " ", b.last_name) AS "reports to"
FROM employees AS a
LEFT JOIN employees AS b
ON a.supervisor_id = b.employee_id;

--#24 MySQL VIEWS
-- a virtual table based on the result-set of an SQL statement
-- The fields in a view are fields from one or more real tables in the database
-- They are not real tables, but can be interacted with as if they were
-- View get updated automatically with real table data.

CREATE VIEW employee_email AS
SELECT email
FROM employees; --this view has only emails. we can use it at any where

CREATE VIEW employee_attendance AS
SELECT first_name, last_name
FROM employees;
--After executing above we can see a view is created under views section of the schema.

--to see the view
SELECT * FROM employee_attendance;

--to drop a view
DROP VIEW employee_attendance;


--#25 MySQL INDEXES
-- its a binary tree data structure
-- They are used to find values within a specific column more quickly
-- MySQL normally searches sequentially through a column
-- The longer the column, the more expensive the operation is
-- by applying index to a column UPDATE takes more time, SELECT takes less time

SHOW indexes FROM customers; -- by default the primary key column of every table is the indexed

-- use below query to create indexes
CREATE INDEX last_name_idx
ON customers(last_name);

--we can create indexes by combining two or more columns
CREATE INDEX last_name_first_name_idx
ON customers(last_name, first_name);

--The corresponding select query will be as follows
SELECT * FROM customers
WHERE last_name = "Puff" AND first_name = "Doe";


--we can drop an index from the table if its no longer needed
ALTER TABLE customers
DROP INDEX last_name_idx;


--#26 MySQL SUBQUERIES
--A query with another query
--query(subquery)

--eg1: select employees whose having salary greater than average salary
--step 1: query to get average of employees
SELECT AVG(hourly_pay) FROM employee;

--step 2: use the subquery in the outer query
SELECT first_name, last_name, hourly_pay
FROM employees
WHERE hourly_pay > (SELECT AVG(hourly_pay) FROM employee);

--eg2:

SELECT first_name, last_name
FROM customers
WHERE customer_id IN (1, 2, 3);

--this (1, 2, 3) value can be get by below query
SELECT DISTINCT customer_id
FROM transactions
WHERE customer_id IS NOT NULL;

--now combine both queries

SELECT first_name, last_name
FROM customers
WHERE customer_id IN
(SELECT DISTINCT customer_id
 FROM transactions
 WHERE customer_id IS NOT NULL);

--#27 MySQL GROUP BY
--aggregate all rows by a specific column often used with aggregate functions
-- eg: SUM(), MAX(), MIN(), AVG(), COUNT()
SELECT SUM(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT MAX(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT SUM(amount), customer_id
FROM transactions
GROUP BY customer_id;

--WHERE clause does not work with GROUP BY clause.
--instead there is HAVING clause.
SELECT COUNT(amount), customer_id
FROM transactions
GROUP BY customer_id
HAVING COUNT(amount)  1 AND customer_id IS NOT NULL;

--#28 MySQL ROLLUP clause

--This is an extension of the GROUP BY clause
--produces another row and shows the GRAND TOTAL. (super-aggregate value)

--eg: get the sum of amount and order_date which is group by order_date
SELECT SUM(amount), order_date
FROM transactions
GROUP BY order_date;

--what if we want to get the sum of amounts in above result.
--then we can use ROLLUP as follows
SELECT SUM(amount), order_date
FROM transactions
GROUP BY order_date
WITH ROLLUP;

SELECT COUNT(transaction_id), order_date
FROM transactions
GROUP BY order_date
WITH ROLLUP;

SELECT COUNT(transaction_id) AS "# of orders", customer_id
FROM transactions
GROUP BY customer_id
WITH ROLLUP; --we will see the grand total of "# of orders" with this ROLLUP clause

SELECT SUM(hourly_pay) AS "hourly pay", employee_id
FROM employees
GROUP BY employee_id
WITH ROLLUP; -- this gives the result of, if all of the employees are working we spend xx amount as the business


--#29 MySQL ON DELETE clause
--ON DELETE SET NULL = when a FK is deleted, replace FK with NULL
--ON DELETE CASCADE = when a FK is deleted, delete row

--if we try to execute below query it will fails due to foreign key constraint
DELETE FROM customers
WHERE customer_id = 4;

-- we can execute below query to get rid of foreign key checks
SET foreign_key_checks = 0;

--to enable to foreign key checks again
SET foreign_key_checks = 1;

--#29.1 ON DELETE SET NULL = when a FK is deleted, replace FK with NULL
CREATE TABLE transactions(
    transaction_id INT PRIMARY KEY,
    amount DECIMAL(5, 2),
    customer_id INT,
    order_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    ON DELETE SET NULL
);

--If we forgot to add the foreign key constraint with ON DELETE SET NULL, at the time of table creation, no worries.
--we can add it later as follows too.
--first delete the existing foreign_key
ALTER TABLE transactions DROP FOREIGN KEY fk_customer_id;

ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE SET NULL;

--now execute below command and it will not throw any error. instead we can see the foreign key 4 has been set to null
DELETE FROM customers
WHERE customer_id = 4;

--#29.2 ON DELETE CASCADE = when a FK is deleted, delete row
--now lets drop the above fk to test this
ALTER TABLE transactions DROP FOREIGN KEY fk_customer_id;

--Add the new foreign key constraint
ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE;

--now execute below command and it will not throw any error. instead we can see all
--the rows having foreign key 4 is deleted in transactions table
DELETE FROM customers
WHERE customer_id = 4;