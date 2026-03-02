postgres=# CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2),
    age INT,
    experience_years INT,
    hire_date DATE
);
CREATE TABLE
postgres=# INSERT INTO employees (first_name, last_name, email, department, salary, bonus, age, experience_years, hire_date)
VALUES
('Alice', 'Brown', 'alice@company.com', 'Sales', 65000, 5000, 29, 5, '2023-05-10'),
('Bob', 'Smith', 'bob@company.com', 'Engineering', 95000, 7000, 33, 8, '2022-02-12'),
('Charlie', 'Johnson', 'charlie@company.com', 'Engineering', 120000, 9000, 42, 15, '2019-09-21'),
('Diana', 'Lee', 'diana@company.com', 'Marketing', 54000, NULL, 27, 4, '2024-03-03'),
('Evan', 'Davis', 'evan@company.com', 'Sales', 72000, 3000, 38, 10, '2021-07-15'),
('Fiona', 'Wong', NULL, 'HR', 60000, NULL, 25, 3, '2024-10-01'),
('George', 'Wilson', 'george@company.com', 'Engineering', 88000, 6000, 31, 7, '2020-11-05'),
('Helen', 'Taylor', 'helen@company.com', 'Sales', 78000, 4000, 45, 18, '2018-01-20');
INSERT 0 8
postgres=# CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    department VARCHAR(50),
    sales_amount NUMERIC(10,2)
);

INSERT INTO sales_data (department, sales_amount)
VALUES
('Sales', 25000),
('Engineering', 18000),
('Marketing', 12000),
('Sales', 30000),
('HR', 8000);
CREATE TABLE
INSERT 0 5
postgres=# CREATE TABLE employee_skills (
    employee_id INT REFERENCES employees(employee_id),
    skill_name VARCHAR(50)
);

INSERT INTO employee_skills (employee_id, skill_name)
VALUES
(1, 'Negotiation'),
(1, 'Communication'),
(2, 'C++'),
(2, 'SQL'),
(3, 'Python'),
(3, 'Machine Learning'),
(4, 'Social Media'),
(5, 'Salesforce'),
(6, 'Recruiting'),
(7, 'Java'),
(8, 'Customer Service');
CREATE TABLE
INSERT 0 11
postgres=# CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category VARCHAR(50),
    product_name VARCHAR(100),
    price NUMERIC(10,2)
);

INSERT INTO products (category, product_name, price)
VALUES
('Electronics', 'Keyboard', 40),
('Electronics', 'Mouse', 20),
('Gadgets', 'Smartwatch', 150),
('Food', 'Strawberry', 25),
('Food', 'Blueberry', 30),
('Food', 'Blackberry', 45);
CREATE TABLE
INSERT 0 6
postgres=# CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    rating NUMERIC(2,1)
);

INSERT INTO product_reviews (product_id, rating)
VALUES
(1, 4.2), (1, 4.5), (2, 3.9), (3, 4.7),
(4, 4.8), (4, 4.9), (4, 4.7), (5, 4.2),
(6, 3.5), (6, 4.0), (6, 4.3);
CREATE TABLE
INSERT 0 11
postgres=# CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    amount NUMERIC(10,2),
    sale_date DATE
);

INSERT INTO sales (employee_id, amount, sale_date)
VALUES
(1, 1200, '2024-02-10'),
(2, 1800, '2024-04-18'),
(3, 1500, '2024-07-05'),
(5, 2100, '2024-10-01'),
(8, 2500, '2025-02-01');
CREATE TABLE
INSERT 0 5
postgres=# -- Count total number of employees
SELECT COUNT(*) AS total_employees 
FROM employees;

-- Count employees with non-NULL email addresses
SELECT COUNT(email) AS employees_with_email 
FROM employees;

-- Count unique departments
SELECT COUNT(DISTINCT department) AS unique_departments 
FROM employees;

 total_employees 
-----------------
               8
(1 row)

 employees_with_email 
----------------------
                    7
(1 row)

 unique_departments 
--------------------
                  4
(1 row)

postgres=# -- Calculate total salary expenditure
SELECT SUM(salary) AS total_salaries 
FROM employees;
-- Calculate total sales by department
SELECT department, SUM(sales_amount) AS total_sales
FROM sales_data
GROUP BY department;
 total_salaries 
----------------
      632000.00
(1 row)

 department  | total_sales 
-------------+-------------
 Marketing   |    12000.00
 Engineering |    18000.00
 Sales       |    55000.00
 HR          |     8000.00
(4 rows)

postgres=# -- Calculate average salary
SELECT AVG(salary) AS average_salary 
FROM employees;
-- Calculate average age by department
SELECT department, AVG(age) AS avg_age
FROM employees
GROUP BY department;
   average_salary   
--------------------
 79000.000000000000
(1 row)

 department  |       avg_age       
-------------+---------------------
 Marketing   | 27.0000000000000000
 Engineering | 35.3333333333333333
 Sales       | 37.3333333333333333
 HR          | 25.0000000000000000
(4 rows)

postgres=# -- Find highest and lowest salaries
SELECT 
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;

-- Find the most recent hire date by department
SELECT department, MAX(hire_date) AS latest_hire
FROM employees
GROUP BY department;
 highest_salary | lowest_salary 
----------------+---------------
      120000.00 |      54000.00
(1 row)

 department  | latest_hire 
-------------+-------------
 Marketing   | 2024-03-03
 Engineering | 2022-02-12
 Sales       | 2023-05-10
 HR          | 2024-10-01
(4 rows)

postgres=# -- List all employees in each department as a comma-separated string
SELECT department, STRING_AGG(first_name, ', ') AS employee_names
FROM employees
GROUP BY department;

-- Create a list of skills per employee (ordered alphabetically)
SELECT employee_id, STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills
GROUP BY employee_id;
 department  |    employee_names    
-------------+----------------------
 Marketing   | Diana
 Engineering | Bob, Charlie, George
 Sales       | Alice, Evan, Helen
 HR          | Fiona
(4 rows)

 employee_id |           skills           
-------------+----------------------------
           1 | Communication, Negotiation
           2 | C++, SQL
           3 | Machine Learning, Python
           4 | Social Media
           5 | Salesforce
           6 | Recruiting
           7 | Java
           8 | Customer Service
(8 rows)

postgres=# -- Create an array of all salaries in each department
SELECT department, ARRAY_AGG(salary) AS salary_array
FROM employees
GROUP BY department;

-- Create ordered array of employee names
SELECT department, ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees
GROUP BY department;
 department  |         salary_array          
-------------+-------------------------------
 Marketing   | {54000.00}
 Engineering | {95000.00,120000.00,88000.00}
 Sales       | {65000.00,72000.00,78000.00}
 HR          | {60000.00}
(4 rows)

 department  |      employees       
-------------+----------------------
 Engineering | {Charlie,Bob,George}
 HR          | {Fiona}
 Marketing   | {Diana}
 Sales       | {Alice,Evan,Helen}
(4 rows)

postgres=# -- Standard deviation and variance
SELECT 
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

-- Correlation coefficient between two numeric columns
SELECT CORR(experience_years, salary) AS experience_salary_correlation
FROM employees;
 department  |  salary_std_dev   |    salary_variance    
-------------+-------------------+-----------------------
 Marketing   |                   |                      
 Engineering |    16822.60384126 |    283000000.00000000
 Sales       | 6506.407098647712 | 42333333.333333333333
 HR          |                   |                      
(4 rows)

 experience_salary_correlation 
-------------------------------
            0.6097732403652278
(1 row)

postgres=# -- Sales summary by product category
SELECT 
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products
GROUP BY category;
  category   | number_of_products | total_value |    average_price     
-------------+--------------------+-------------+----------------------
 Gadgets     |                  1 |      150.00 | 150.0000000000000000
 Electronics |                  2 |       60.00 |  30.0000000000000000
 Food        |                  3 |      100.00 |  33.3333333333333333
(3 rows)

postgres=# -- Sales analysis by year and quarter
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

 year | quarter | total_sales | total_revenue 
------+---------+-------------+---------------
 2024 |       1 |           1 |       1200.00
 2024 |       2 |           1 |       1800.00
 2024 |       3 |           1 |       1500.00
 2024 |       4 |           1 |       2100.00
 2025 |       1 |           1 |       2500.00
(5 rows)

postgres=# -- Group by calculated values
SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

 age_group | employee_count |     avg_salary     
-----------+----------------+--------------------
 Under 30  |              3 | 59666.666666666667
 30-50     |              5 | 90600.000000000000
(2 rows)

postgres=# -- Find departments with more than 5 employees
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- Find products with average rating above 4.0
SELECT 
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING AVG(rating) > 4.0 AND COUNT(*) >= 10;

 department | employee_count 
------------+----------------
(0 rows)

 product_id | avg_rating | review_count 
------------+------------+--------------
(0 rows)

postgres=# -- Aggregate function: Returns one row per department
SELECT department, AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department;

-- Window function: Returns all rows with department average
SELECT 
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;

 department  |   dept_avg_salary   
-------------+---------------------
 Marketing   |  54000.000000000000
 Engineering | 101000.000000000000
 Sales       |  71666.666666666667
 HR          |  60000.000000000000
(4 rows)

 employee_id | first_name | department  |  salary   |   dept_avg_salary   
-------------+------------+-------------+-----------+---------------------
           7 | George     | Engineering |  88000.00 | 101000.000000000000
           3 | Charlie    | Engineering | 120000.00 | 101000.000000000000
           2 | Bob        | Engineering |  95000.00 | 101000.000000000000
           6 | Fiona      | HR          |  60000.00 |  60000.000000000000
           4 | Diana      | Marketing   |  54000.00 |  54000.000000000000
           8 | Helen      | Sales       |  78000.00 |  71666.666666666667
           5 | Evan       | Sales       |  72000.00 |  71666.666666666667
           1 | Alice      | Sales       |  65000.00 |  71666.666666666667
(8 rows)

postgres=# -- COUNT(*) includes NULLs, COUNT(column) excludes NULLs
SELECT 
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees;

-- SUM, AVG, MAX, MIN ignore NULL values
SELECT 
    SUM(bonus) AS total_bonus,        -- NULLs ignored
    AVG(bonus) AS avg_bonus,          -- NULLs ignored
    COUNT(bonus) AS employees_with_bonus
FROM employees;
 total_rows | non_null_emails | null_emails 
------------+-----------------+-------------
          8 |               7 |           1
(1 row)

 total_bonus |       avg_bonus       | employees_with_bonus 
-------------+-----------------------+----------------------
    34000.00 | 5666.6666666666666667 |                    6
(1 row)

postgres=# 
postgres=# -- Combining Multiple Aggregations
SELECT 
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_std_dev
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

-- Conditional aggregation
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;

-- Percentage Calculations
SELECT 
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT / (SELECT COUNT(*) FROM employees) * 100 AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;
 department  | employee_count | min_salary | max_salary |     avg_salary      |  salary_std_dev   
-------------+----------------+------------+------------+---------------------+-------------------
 Engineering |              3 |   88000.00 |  120000.00 | 101000.000000000000 |    16822.60384126
 Sales       |              3 |   65000.00 |   78000.00 |  71666.666666666667 | 6506.407098647712
 HR          |              1 |   60000.00 |   60000.00 |  60000.000000000000 |                  
 Marketing   |              1 |   54000.00 |   54000.00 |  54000.000000000000 |                  
(4 rows)

 department  | total_employees | high_earners | recent_hires 
-------------+-----------------+--------------+--------------
 Marketing   |               1 |            1 |            1
 Engineering |               3 |            3 |            0
 Sales       |               3 |            3 |            1
 HR          |               1 |            1 |            1
(4 rows)

 department  | dept_count | percentage 
-------------+------------+------------
 Engineering |          3 |       37.5
 Sales       |          3 |       37.5
 Marketing   |          1 |       12.5
 HR          |          1 |       12.5
(4 rows)