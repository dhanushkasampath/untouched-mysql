--stored procedure is a prepared SQL code that you can save and use again and again.
--We make stored procedures for frequently used queries

--Advantages:
--      Reduces network traffic
--      Increase performance
--      Secure, admin can grant permission to use

--Disadvantage:
--      Increases memory usage of every connection


--STEP 1: simple example

--Assume below is the query we need
SELECT * FROM employees;

DELIMITER $$
CREATE PROCEDURE get_employees()
BEGIN
    SELECT * FROM employees;
END $$
DELIMITER ;
--After executing above query a new stored procedure will be
-- created under "Stored Procedures" section of the schema

--we can call it as like this
CALL get_employees();

--Use below query to drop a procedure
DROP PROCEDURE get_employees;

--STEP 2: passing inputs to stored procedure

DELIMITER $$
CREATE PROCEDURE find_employee(IN id INT)
BEGIN
    SELECT *
    FROM employees
    WHERE employee_id = id;
END $$
DELIMITER ;


CALL find_employee(2);

--STEP 3: passing 2 inputs to stored procedure

DELIMITER $$
CREATE PROCEDURE find_employee_by_name(IN f_name VARCHAR(20)
                               IN l_name VARCHAR(20),)
BEGIN
    SELECT *
    FROM employees
    WHERE first_name = f_name AND last_name = l_name;
END $$
DELIMITER ;

CALL find_employee_by_name("Andrew", "Hudson");