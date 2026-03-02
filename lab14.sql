postgres=# CREATE TABLE customers (
postgres(#     customer_id SERIAL PRIMARY KEY,
postgres(#     name VARCHAR(100),
postgres(#     email VARCHAR(100)
postgres(# );
CREATE TABLE
postgres=# -- Orders table
postgres=# CREATE TABLE orders (
postgres(#     order_id SERIAL PRIMARY KEY,
postgres(#     customer_id INTEGER REFERENCES customers(customer_id),
postgres(#     order_date DATE,
postgres(#     total_amount DECIMAL(10,2)
postgres(# );
CREATE TABLE
postgres=# SELECT c.name, c.email, o.order_date, o.total_amount
postgres-# FROM customers c
postgres-# INNER JOIN orders o ON c.customer_id = o.customer_id;
 name | email | order_date | total_amount
------+-------+------------+--------------
(0 rows)


postgres=#
postgres=# SELECT c.name, c.email, o.order_date, o.total_amount
postgres-# FROM customers c
postgres-# LEFT JOIN orders o ON c.customer_id = o.customer_id;
 name | email | order_date | total_amount
------+-------+------------+--------------
(0 rows)


postgres=#
postgres=#
postgres=# SELECT c.name, c.email, o.order_date, o.total_amount
postgres-# FROM customers c
postgres-# RIGHT JOIN orders o ON c.customer_id = o.customer_id;
 name | email | order_date | total_amount
------+-------+------------+--------------
(0 rows)


postgres=#
postgres=# SELECT c.name, c.email, o.order_date, o.total_amount
postgres-# FROM customers c
postgres-# FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
 name | email | order_date | total_amount
------+-------+------------+--------------
(0 rows)


postgres=#
postgres=#
postgres=# SELECT c.name, p.product_name
postgres-# FROM customers c
postgres-# CROSS JOIN products p;
ОШИБКА:  отношение "products" не существует
LINE 3: CROSS JOIN products p;
                   ^
postgres=# CREATE TABLE products (
postgres(#     product_id SERIAL PRIMARY KEY,
postgres(#     product_name VARCHAR(100),
postgres(#     price DECIMAL(10,2)
postgres(# );
CREATE TABLE
postgres=# INSERT INTO products (product_name, price) VALUES
postgres-# ('Widget', 10.50),
postgres-# ('Gadget', 20.75);
INSERT 0 2
postgres=# CROSS JOIN products p;
ОШИБКА:  ошибка синтаксиса (примерное положение: "CROSS")
LINE 1: CROSS JOIN products p;
        ^
postgres=# SELECT c.name, p.product_name
postgres-# FROM customers c
postgres-# CROSS JOIN products p;
 name | product_name
------+--------------
(0 rows)


postgres=#
postgres=#
postgres=# SELECT c.name, o.order_date, oi.quantity, p.product_name, p.price
postgres-# FROM customers c
postgres-# INNER JOIN orders o ON c.customer_id = o.customer_id
postgres-# INNER JOIN order_items oi ON o.order_id = oi.order_id
postgres-# INNER JOIN products p ON oi.product_id = p.product_id;
ОШИБКА:  отношение "order_items" не существует
LINE 4: INNER JOIN order_items oi ON o.order_id = oi.order_id
                   ^
postgres=#
postgres=# -- Customers table
postgres=# CREATE TABLE customers (
postgres(#     customer_id SERIAL PRIMARY KEY,
postgres(#     name VARCHAR(100),
postgres(#     email VARCHAR(100)
postgres(# );
ОШИБКА:  отношение "customers" уже существует
postgres=#
postgres=# CREATE TABLE orders (
postgres(#     order_id SERIAL PRIMARY KEY,
postgres(#     customer_id INTEGER REFERENCES customers(customer_id),
postgres(#     order_date DATE,
postgres(#     total_amount DECIMAL(10,2)
postgres(# );
ОШИБКА:  отношение "orders" уже существует
postgres=# INSERT INTO customers (name, email) VALUES
postgres-# ('Alice Johnson', 'alice@example.com'),
postgres-# ('Bob Smith', 'bob@example.com');
INSERT 0 2
postgres=# INSERT INTO orders (customer_id, order_date, total_amount) VALUES
postgres-# (1, '2026-02-25', 150.00),
postgres-# (2, '2026-03-01', 75.50),
postgres-# (1, '2026-03-02', 200.00);
INSERT 0 3
postgres=# -- Find employees and their managers
postgres=# SELECT e1.name AS employee, e2.name AS manager
postgres-# FROM employees e1
postgres-# LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;
ОШИБКА:  отношение "employees" не существует
LINE 2: FROM employees e1
             ^
postgres=#
postgres=# CREATE TABLE employees (
postgres(#     employee_id SERIAL PRIMARY KEY,
postgres(#     name VARCHAR(100),
postgres(#     manager_id INTEGER REFERENCES employees(employee_id) -- self-reference
postgres(# );
CREATE TABLE
postgres=#
postgres=# -- Insert sample employees
postgres=# INSERT INTO employees (name, manager_id) VALUES
postgres-# ('John Doe', NULL),
postgres-# ('Jane Smith', 1),
postgres-# ('Bob Johnson', 1),
postgres-# ('Alice Brown', 2);
INSERT 0 4
postgres=# -- Find employees and their managers
postgres=# SELECT e1.name AS employee, e2.name AS manager
postgres-# FROM employees e1
postgres-# LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;
  employee   |  manager
-------------+------------
 John Doe    |
 Jane Smith  | John Doe
 Bob Johnson | John Doe
 Alice Brown | Jane Smith
(4 rows)


postgres=#
postgres=# SELECT c.name, o.order_date, o.total_amount
postgres-# FROM customers c
postgres-# INNER JOIN orders o ON c.customer_id = o.customer_id
postgres-# WHERE o.order_date >= '2024-01-01'
postgres-# AND o.total_amount > 100;
     name      | order_date | total_amount
---------------+------------+--------------
 Alice Johnson | 2026-02-25 |       150.00
 Alice Johnson | 2026-03-02 |       200.00
(2 rows)


postgres=#
postgres=# SELECT u.username, up.first_name, up.last_name, up.phone
postgres-# FROM users u
postgres-# LEFT JOIN user_profiles up ON u.user_id = up.user_id;
ОШИБКА:  отношение "users" не существует
LINE 2: FROM users u
             ^
postgres=# CREATE TABLE users (
postgres(#     user_id SERIAL PRIMARY KEY,
postgres(#     username VARCHAR(50) NOT NULL UNIQUE,
postgres(#     email VARCHAR(100) UNIQUE
postgres(# );
CREATE TABLE
postgres=# CREATE TABLE user_profiles (
postgres(#     profile_id SERIAL PRIMARY KEY,
postgres(#     user_id INTEGER UNIQUE REFERENCES users(user_id) ON DELETE CASCADE,
postgres(#     first_name VARCHAR(100),
postgres(#     last_name VARCHAR(100),
postgres(#     phone VARCHAR(20)
postgres(# );
CREATE TABLE
postgres=# INSERT INTO users (username, email) VALUES
postgres-# ('alice', 'alice@example.com'),
postgres-# ('bob', 'bob@example.com'),
postgres-# ('charlie', 'charlie@example.com');
INSERT 0 3
postgres=#
postgres=# INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
postgres-# (1, 'Alice', 'Johnson', '123-456-7890'),
postgres-# (2, 'Bob', 'Smith', '555-111-2222');
INSERT 0 2
postgres=# -- Joining user profiles (one-to-one)
postgres=# SELECT u.username, up.first_name, up.last_name, up.phone
postgres-# FROM users u
postgres-# LEFT JOIN user_profiles up ON u.user_id = up.user_id;
 username | first_name | last_name |    phone
----------+------------+-----------+--------------
 alice    | Alice      | Johnson   | 123-456-7890
 bob      | Bob        | Smith     | 555-111-2222
 charlie  |            |           |
(3 rows)


postgres=#
postgres=#
postgres=# -- Authors and their books (one-to-many)
postgres=# SELECT a.author_name, b.title, b.publication_year
postgres-# FROM authors a
postgres-# INNER JOIN books b ON a.author_id = b.author_id
postgres-# ORDER BY a.author_name, b.publication_year;
ОШИБКА:  отношение "authors" не существует
LINE 2: FROM authors a
             ^
postgres=#
postgres=#
postgres=# -- Students and their enrolled courses (many-to-many)
postgres=# SELECT s.student_name, c.course_name, e.enrollment_date, e.grade
postgres-# FROM students s
postgres-# INNER JOIN enrollments e ON s.student_id = e.student_id
postgres-# INNER JOIN courses c ON e.course_id = c.course_id
postgres-# WHERE e.grade IS NOT NULL
postgres-# ORDER BY s.student_name, c.course_name;
ОШИБКА:  столбец s.student_name не существует
LINE 1: SELECT s.student_name, c.course_name, e.enrollment_date, e.g...
               ^
postgres=#
postgres=# -- Create indexes on foreign key columns
postgres=# CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX
postgres=# CREATE INDEX idx_order_items_order_id ON order_items(order_id);
ОШИБКА:  отношение "order_items" не существует
postgres=# CREATE INDEX idx_order_items_product_id ON order_items(product_id);
ОШИБКА:  отношение "order_items" не существует
postgres=#
postgres=# CREATE TABLE order_items (
postgres(#     order_item_id SERIAL PRIMARY KEY,
postgres(#     order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
postgres(#     product_id INTEGER REFERENCES products(product_id),
postgres(#     quantity INTEGER NOT NULL
postgres(# );
CREATE TABLE
postgres=# INSERT INTO order_items (order_id, product_id, quantity) VALUES
postgres-# (1, 1, 2),  -- Order 1, Widget x2
postgres-# (1, 2, 1),  -- Order 1, Gadget x1
postgres-# (2, 2, 3);  -- Order 2, Gadget x3
INSERT 0 3
postgres=# CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX
postgres=# CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX
postgres=# SELECT c.name, o.order_date
postgres-# FROM customers c
postgres-# INNER JOIN orders o ON c.customer_id = o.customer_id;
     name      | order_date
---------------+------------
 Alice Johnson | 2026-03-02
 Alice Johnson | 2026-02-25
 Bob Smith     | 2026-03-01
(3 rows)
