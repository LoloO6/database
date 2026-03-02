postgres=# CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    tenure INT,
    manager_id INT REFERENCES employees(employee_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_id INT,
    product_id INT,
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    status VARCHAR(50)
);

CREATE TABLE warehouse_1 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

CREATE TABLE warehouse_2 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year INT,
    sales_amount DECIMAL(12,2)
);

CREATE TABLE pivoted_sales (
    product_name VARCHAR(100),
    year_2022 DECIMAL(12,2),
    year_2023 DECIMAL(12,2),
    year_2024 DECIMAL(12,2)
);
ERROR:  relation "employees" already exists
ERROR:  relation "orders" already exists
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
postgres=# SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)  -- This scalar subquery returns a single value
    FROM employees
);
 first_name | last_name |  salary   
------------+-----------+-----------
 Bob        | Smith     |  95000.00
 Charlie    | Johnson   | 120000.00
 George     | Wilson    |  88000.00
(3 rows)

postgres=# WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;
ERROR:  column "region_id" does not exist
LINE 2:     SELECT region_id, SUM(amount) AS total_sales
                   ^
postgres=# DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_id INT,
    product_id INT,
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    status VARCHAR(50)
);
ERROR:  cannot drop table orders because other objects depend on it
DETAIL:  constraint order_items_order_id_fkey on table order_items depends on table orders
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
ERROR:  relation "orders" already exists
postgres=# WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;
ERROR:  column "region_id" does not exist
LINE 2:     SELECT region_id, SUM(amount) AS total_sales
                   ^
postgres=# ALTER TABLE orders ADD COLUMN region_id INT;
ALTER TABLE
postgres=# WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;
ERROR:  column "amount" does not exist
LINE 2:     SELECT region_id, SUM(amount) AS total_sales
                                  ^
postgres=# DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_id INT,
    product_id INT,
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    status VARCHAR(50)
);
ERROR:  cannot drop table orders because other objects depend on it
DETAIL:  constraint order_items_order_id_fkey on table order_items depends on table orders
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
ERROR:  relation "orders" already exists
postgres=# DROP TABLE IF EXISTS orders CASCADE;
NOTICE:  drop cascades to constraint order_items_order_id_fkey on table order_items
DROP TABLE
postgres=# CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_id INT,
    product_id INT,
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    status VARCHAR(50)
);
CREATE TABLE
postgres=# WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000;
 region_id | total_sales 
-----------+-------------
(0 rows)

postgres=# WITH RECURSIVE org_chart AS (
    -- Anchor: Find the top-level manager (e.g., who has no manager)
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive: Find everyone who reports to the people already in the chart
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;
 employee_id | first_name | last_name | manager_id 
-------------+------------+-----------+------------
           1 | Alice      | Brown     |           
           2 | Bob        | Smith     |           
           3 | Charlie    | Johnson   |           
           4 | Diana      | Lee       |           
           5 | Evan       | Davis     |           
           6 | Fiona      | Wong      |           
           7 | George     | Wilson    |           
           8 | Helen      | Taylor    |           
(8 rows)

postgres=# -- Get all unique products from both warehouses
SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;

-- Find products that are out of stock in both warehouses
SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;
 product_name 
--------------
(0 rows)

 product_id 
------------
(0 rows)

postgres=# SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

 first_name | last_name | department  |  salary   | dept_salary_rank 
------------+-----------+-------------+-----------+------------------
 Charlie    | Johnson   | Engineering | 120000.00 |                1
 Bob        | Smith     | Engineering |  95000.00 |                2
 George     | Wilson    | Engineering |  88000.00 |                3
 Fiona      | Wong      | HR          |  60000.00 |                1
 Diana      | Lee       | Marketing   |  54000.00 |                1
 Helen      | Taylor    | Sales       |  78000.00 |                1
 Evan       | Davis     | Sales       |  72000.00 |                2
 Alice      | Brown     | Sales       |  65000.00 |                3
(8 rows)

postgres=# SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;
Unpivoting with UNION ALL:
 product_name | year_2022 | year_2023 | year_2024 
--------------+-----------+-----------+-----------
(0 rows)

postgres-# SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;
ERROR:  syntax error at or near "Unpivoting"
LINE 1: Unpivoting with UNION ALL:
        ^
postgres=# SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;
 product_name | year_2022 | year_2023 | year_2024 
--------------+-----------+-----------+-----------
(0 rows)

postgres=# SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;

 product_name | year | sales_amount 
--------------+------+--------------
(0 rows)

postgres=# SELECT
    employee_id,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_salary_senior
FROM employees;
ERROR:  column "tenure" does not exist
LINE 4:     AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_sal...
                                      ^
postgres=# DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    tenure INT,
    manager_id INT REFERENCES employees(employee_id)
);
NOTICE:  drop cascades to constraint employee_skills_employee_id_fkey on table employee_skills
DROP TABLE
CREATE TABLE
postgres=# SELECT
    employee_id,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_salary_senior
FROM employees;
 employee_id | total_dept_salary | avg_salary_senior 
-------------+-------------------+-------------------
(0 rows)

postgres=# SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;
 product_name | status 
--------------+--------
(0 rows)