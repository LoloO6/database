postgres=# CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    department_id INT,
    salary NUMERIC(10,2)
);

INSERT INTO employees (name, department, department_id, salary) VALUES
('Alice', 'Sales', 3, 65000),
('Bob', 'Engineering', 5, 90000),
('Charlie', 'Engineering', 7, 120000),
('Diana', 'Marketing', 4, 55000),
('Evan', 'Sales', 3, 70000),
('Brian', 'Support', 6, 48000),
('Amy', 'HR', 2, 75000);
CREATE TABLE
INSERT 0 7
postgres=# CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2)
);

INSERT INTO products (product_name, price) VALUES
('Strawberry', 25),
('Blueberry', 30),
('Blackberry', 45),
('Keyboard', 20),
('Mouse', 15),
('Monitor', 120);
CREATE TABLE
INSERT 0 6
postgres=# CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO customers (customer_name) VALUES
('Brandon Smith'),
('Bradley Cooper'),
('Brian Adams'),
('Charlie Brown'),
('Alex Johnson');
CREATE TABLE
INSERT 0 5
postgres=# CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(100)
);

INSERT INTO users (email) VALUES
('amy@gmail.com'),
('bob@gmail.com'),
('carol@yahoo.com'),
('dave@outlook.com'),
('alex@gmail.com');
CREATE TABLE
INSERT 0 5
postgres=# CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    amount NUMERIC(10,2)
);

INSERT INTO sales (employee_id, amount) VALUES
(1, 900),
(2, 1500),
(3, 800),
(4, 1300),
(5, 2500),
(2, 500);
CREATE TABLE
INSERT 0 6
postgres=# SELECT * FROM employees;
 id |  name   | department  | department_id |  salary   
----+---------+-------------+---------------+-----------
  1 | Alice   | Sales       |             3 |  65000.00
  2 | Bob     | Engineering |             5 |  90000.00
  3 | Charlie | Engineering |             7 | 120000.00
  4 | Diana   | Marketing   |             4 |  55000.00
  5 | Evan    | Sales       |             3 |  70000.00
  6 | Brian   | Support     |             6 |  48000.00
  7 | Amy     | HR          |             2 |  75000.00
(7 rows)

postgres=# SELECT name, department FROM employees;
  name   | department  
---------+-------------
 Alice   | Sales
 Bob     | Engineering
 Charlie | Engineering
 Diana   | Marketing
 Evan    | Sales
 Brian   | Support
 Amy     | HR
(7 rows)

postgres=# SELECT name, salary, salary * 0.10 AS potential_bonus
FROM employees;
  name   |  salary   | potential_bonus 
---------+-----------+-----------------
 Alice   |  65000.00 |       6500.0000
 Bob     |  90000.00 |       9000.0000
 Charlie | 120000.00 |      12000.0000
 Diana   |  55000.00 |       5500.0000
 Evan    |  70000.00 |       7000.0000
 Brian   |  48000.00 |       4800.0000
 Amy     |  75000.00 |       7500.0000
(7 rows)

postgres=# SELECT name, salary
FROM employees
WHERE department = 'Sales';
 name  |  salary  
-------+----------
 Alice | 65000.00
 Evan  | 70000.00
(2 rows)

postgres=# SELECT name
FROM employees
WHERE salary > 75000 AND department = 'Engineering';
  name   
---------
 Bob
 Charlie
(2 rows)

postgres=# SELECT product_name, price
FROM products
WHERE price BETWEEN 20 AND 50;
 product_name | price 
--------------+-------
 Strawberry   | 25.00
 Blueberry    | 30.00
 Blackberry   | 45.00
 Keyboard     | 20.00
(4 rows)

postgres=# SELECT customer_name
FROM customers
WHERE customer_name LIKE 'Bra%'; 
 customer_name  
----------------
 Brandon Smith
 Bradley Cooper
(2 rows)

postgres=# SELECT product_name
FROM products
WHERE product_name LIKE '%berry';

 product_name 
--------------
 Strawberry
 Blueberry
 Blackberry
(3 rows)

postgres=# SELECT email
FROM users
WHERE email ILIKE '%@gmail.com';

     email      
----------------
 amy@gmail.com
 bob@gmail.com
 alex@gmail.com
(3 rows)

postgres=# SELECT name
FROM employees
WHERE name ~ '^[AB]';
 name  
-------
 Alice
 Bob
 Brian
 Amy
(4 rows)

postgres=# SELECT email
FROM users
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';
      email       
------------------
 amy@gmail.com
 bob@gmail.com
 carol@yahoo.com
 dave@outlook.com
 alex@gmail.com
(5 rows)

postgres=# SELECT name, department
FROM employees
WHERE department_id IN (3, 5, 7);
-- Or with a subquery
SELECT name
FROM employees
WHERE id IN (SELECT employee_id FROM sales WHERE amount > 1000);
  name   | department  
---------+-------------
 Alice   | Sales
 Bob     | Engineering
 Charlie | Engineering
 Evan    | Sales
(4 rows)

 name  
-------
 Bob
 Diana
 Evan
(3 rows)

postgres=# SELECT name
FROM employees e
WHERE EXISTS (
  SELECT 1
  FROM sales s
  WHERE s.employee_id = e.id AND s.amount > 1000
);
 name  
-------
 Bob
 Diana
 Evan
(3 rows)

postgres=# --CASE Statements SELECT name, salary,
  CASE
    WHEN salary > 100000 THEN 'Senior'
    WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
    ELSE 'Junior'
  END AS employee_level
FROM employees;
ERROR:  syntax error at or near "CASE"
LINE 1: CASE
        ^
postgres=# WITH department_averages AS (
  SELECT
    department,
    AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)

SELECT
  e.name,
  e.salary,
  e.department,
  da.avg_salary
FROM employees e
JOIN department_averages da ON e.department = da.department
WHERE e.salary > da.avg_salary;
  name   |  salary   | department  |     avg_salary      
---------+-----------+-------------+---------------------
 Charlie | 120000.00 | Engineering | 105000.000000000000
 Evan    |  70000.00 | Sales       |  67500.000000000000
(2 rows)