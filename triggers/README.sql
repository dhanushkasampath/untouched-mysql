--When an event happens, do something
--ex. (INSERT, UPDATE, DELETE)
--is called Triggers.
--
--eg:
--if the hourly_pay column in a table updates, the salary column should be updated automatically.
--This can be done by triggers.

--Triggers are under table level
--Stored procedures are under schema level
SHOW TRIGGERS;
DROP TRIGGER before_hourly_pay_update;

--=======================================================================
--STEP 1:
--Creating a schema and insert values to employees table
CREATE schema `triggers-demo`;
USE `triggers-demo`;

-- create the employees table
CREATE TABLE employees(
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    hourly_pay DECIMAL(10, 2),
    salary DECIMAL(10, 2),
    job VARCHAR(20),
    hire_date DATE,
    supervisor_id INT
);

-- Insert some records to it
INSERT INTO employees
VALUES
(1, "David", "Peter", 10, null, "Janitor", "2023-01-07", 5),
(2, "Mark", "Selle", 5, null, "Clearer", "2023-01-04", 1),
(3, "Edward", "Jane", 6.7, null, "Bar tender", "2023-01-06", 5),
(4, "Tail", "Zinc", 13, null, "sales", "2023-01-07", 1),
(5, "Andrew", "Hudson", 7.6, null, "Janitor", "2023-01-05", 5);

-- update the salary column
UPDATE employees
SET salary = hourly_pay * 2080;
--by default updating is not allowed in workbench. we need to disable that feature
--edit -> preferences -> SQL Editor
--uncheck the "Safe update" option and reconnect to database.
--After that above query will be allowed

-- if you want to remove all the rows in the table without removing the table,
--use below query.
--TRUNCATE TABLE employees;

--=======================================================================
--STEP 2:
-- creating the trigger "before_hourly_pay_update" in employees table

-- This trigger will update the salary column every time when we
-- update the hourly_pay column
CREATE TRIGGER before_hourly_pay_update
BEFORE UPDATE ON employees
FOR EACH ROW
SET NEW.salary = (NEW.hourly_pay * 2080);

-- After the above trigger, every time we update the hourly_pay as like this,
-- the salary column will be updated automatically
UPDATE employees
SET hourly_pay =50
WHERE employee_id = 1;

-- to update the all rows of hourly_pay use below command
UPDATE employees
SET hourly_pay = hourly_pay + 1

--=======================================================================
--STEP 3:
-- creating the trigger "before_hourly_pay_insert" in employees table

-- now assume when we insert a new record to employees table, then the salary column
-- should be calculated automatically. we can write a trigger for that as follows
CREATE TRIGGER before_hourly_pay_insert
BEFORE INSERT ON employees
FOR EACH ROW
SET NEW.salary = (NEW.hourly_pay * 2080);

--Now we will insert a record to employees table by passing null to salary column
INSERT INTO employees
VALUES (6, "John", "MArk", 10, null, "Janitor", "2023-01-07", 5);

--=======================================================================
-- STEP 4:
-- creating the expenses table and insert records to it

-- Now assume there is another tables as expenses, which keeps the sum of salary column
-- in employees tables. When a particular salary updates/inserted/removed, the sum of that also should be be updated
-- We need separated triggers for that in expenses tables.

-- Now assume one row in salary table deleted. then sum in expenses table also should be reduced accordingly
-- lets see how to do that

--First lets create the expenses table
CREATE TABLE expenses(
    expense_id INT PRIMARY KEY,
    expense_name VARCHAR(50),
    expense_total DECIMAL(10, 2)
);
--lets insert some values to expenses table
INSERT INTO expenses
VALUES (1, "salaries", 0),
       (2, "supplies", 0),
       (3, "taxes", 0);

-- now lets calculate the update the salaries column in expenses table
UPDATE expenses
SET expense_total = (SELECT SUM(salary) FROM employees)
WHERE expense_name = "salaries";

--=======================================================================
--STEP 5:
-- creating the trigger "after_salary_insert" in expenses table

CREATE TRIGGER after_salary_insert
AFTER INSERT ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + NEW.salary
WHERE expense_name = "salaries";
-- After running above trigger we can see a new trigger named as "after_salary_insert" created
-- under the expenses table

--Now we will insert a record to employees table by passing null to salary column
INSERT INTO employees
VALUES (7, "Edward", "Barns", 10, null, "Janitor", "2023-01-08", 5);
-- After running above query we can see the salaries column in expenses table has been updated.
-- That means our intention is successful.

--=======================================================================
--STEP 6:
-- creating the trigger "after_salary_update" in expenses table

CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + (NEW.salary - OLD.salary)
WHERE expense_name = "salaries";
-- After running above trigger we can see a new trigger named as "after_salary_insert" created
-- under the expenses table

--Now we will update the salary of employees table by changing the hourly_pay value of a record
UPDATE employees
SET hourly_pay =100
WHERE employee_id = 1;
-- After running above query we can see the salaries column in expenses table has been updated.
-- That means our intention is successful.

--=======================================================================
--STEP 7:
-- creating the trigger "after_salary_delete" in expenses table

-- now when ever we delete a record from employees table, salaries column in expenses table
-- should be updated. Here is the trigger for that
CREATE TRIGGER after_salary_delete
AFTER DELETE ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total - OLD.salary
WHERE expense_name = "salaries";
-- After running above trigger we can see a new trigger named as "after_salary_delete" created
-- under the expenses table

SELECT * FROM expenses;

-- Now lets verify this by deleting a record from employees table
DELETE FROM employees
WHERE employee_id = 6;
-- After running above query we can see the salaries column in expenses table has been updated.
-- That means our intention is successful.

