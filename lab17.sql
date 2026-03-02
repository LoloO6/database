
postgres=# DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customer_feedback CASCADE;
DROP TABLE IF EXISTS sales_data CASCADE;
DROP TABLE
NOTICE:  drop cascades to constraint inventory_product_id_fkey on table inventory
DROP TABLE
NOTICE:  drop cascades to constraint orders_customer_id_fkey on table orders
DROP TABLE
NOTICE:  drop cascades to constraint order_items_order_id_fkey on table order_items
DROP TABLE
NOTICE:  table "customer_feedback" does not exist, skipping
DROP TABLE
DROP TABLE
postgres=# 
postgres=# CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2),
    stock INTEGER
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total NUMERIC(10,2)
);

CREATE TABLE customer_feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INT,
    feedback TEXT
);

CREATE TABLE sales_data (
    sale_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT,
    sale_amount NUMERIC(10,2)
);
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
postgres=# INSERT INTO employees (first_name, last_name, email, department) VALUES
('John', 'Smith', 'john.smith@email.com', 'IT'),
('Jane', 'Doe', 'jane.doe@email.com', 'HR');

INSERT INTO products (name, price) VALUES
('Laptop', 999.99),
('Mouse', 25.50);

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@email.com'),
('Bob', 'bob@email.com');

INSERT INTO orders (customer_id, total) VALUES (1, 250.00), (2, 300.00);
INSERT 0 2
ERROR:  column "name" of relation "products" does not exist
LINE 1: INSERT INTO products (name, price) VALUES
                              ^
INSERT 0 2
INSERT 0 2
postgres=# -- Custom delimiter and null representation
COPY employees TO '/tmp/employees.txt' 
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;

-- Export query results only for IT department
COPY (SELECT * FROM employees WHERE department = 'IT') 
TO '/tmp/it_employees.csv' WITH CSV HEADER;

-- Export full products table
COPY products TO '/tmp/products.csv' WITH CSV HEADER;

-- CSV export with custom delimiter and quote
COPY customers TO '/tmp/customers.csv' 
WITH CSV HEADER DELIMITER ';' QUOTE '"';

-- Force quoting for order_date
COPY orders TO '/tmp/orders.csv' 
WITH CSV HEADER FORCE_QUOTE (order_date);
COPY 2
COPY 1
COPY 0
COPY 2
ERROR:  syntax error at or near "FORCE_QUOTE"
LINE 2: WITH CSV HEADER FORCE_QUOTE (order_date);
                        ^
postgres=# -- Custom delimiter and null representation
COPY employees TO '/tmp/employees.txt' 
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;

-- Export query results only for IT department
COPY (SELECT * FROM employees WHERE department = 'IT') 
TO '/tmp/it_employees.csv' WITH CSV HEADER;

-- Export full products table
COPY products TO '/tmp/products.csv' WITH CSV HEADER;

-- CSV export with custom delimiter and quote
COPY customers TO '/tmp/customers.csv' 
WITH CSV HEADER DELIMITER ';' QUOTE '"';

-- Force quoting for order_date
COPY orders TO '/tmp/orders.csv' 
WITH CSV HEADER FORCE_QUOTE (order_date);
COPY 2
COPY 1
COPY 0
COPY 2
ERROR:  syntax error at or near "FORCE_QUOTE"
LINE 2: WITH CSV HEADER FORCE_QUOTE (order_date);
                        ^
postgres=# -- Basic import (table must exist)
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

-- Handle embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv' 
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv' 
WITH CSV HEADER NULL 'NULL';
COPY 0
ERROR:  could not open file "/tmp/new_employees.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
COPY 0
ERROR:  could not open file "/tmp/sales.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
postgres=# \copy products FROM '/path/to/products.csv' WITH CSV HEADER;

\copy employees(first_name, last_name, email)
FROM '/path/to/new_employees.csv' WITH CSV HEADER;

\copy customer_feedback TO '/path/to/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

\copy sales_data FROM '/path/to/sales.csv' 
WITH CSV HEADER NULL 'NULL';
/path/to/products.csv: No such file or directory
postgres=# -- Basic import (table must exist)
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

-- Handle embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv' 
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv' 
WITH CSV HEADER NULL 'NULL';
COPY 0
ERROR:  could not open file "/tmp/new_employees.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
COPY 0
ERROR:  could not open file "/tmp/sales.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
postgres=# -- Import data into existing table
\copy products FROM '/path/to/products.csv' WITH CSV HEADER;

-- Import only specific columns
\copy employees(first_name, last_name, email)
FROM '/path/to/new_employees.csv' WITH CSV HEADER;

-- Handle embedded commas and quotes (export)
\copy customer_feedback TO '/path/to/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
\copy sales_data FROM '/path/to/sales.csv'
WITH CSV HEADER NULL 'NULL';
/path/to/products.csv: No such file or directory
postgres=# -- Basic import (table must exist)
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

-- Handle embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv' 
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv' 
WITH CSV HEADER NULL 'NULL';
COPY 0
ERROR:  could not open file "/tmp/new_employees.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
COPY 0
ERROR:  could not open file "/tmp/sales.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
postgres=# -- Import from local CSV into an existing table
\copy products FROM '/path/to/products.csv' WITH CSV HEADER;

-- Import specific columns
\copy employees(first_name, last_name, email)
FROM '/path/to/new_employees.csv' WITH CSV HEADER;

-- Export to CSV (handles commas and quotes)
\copy customer_feedback TO '/path/to/feedback.csv'
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Import with custom NULL representation
\copy sales_data FROM '/path/to/sales.csv'
WITH CSV HEADER NULL 'NULL';
/path/to/products.csv: No such file or directory
postgres=# \copy employees(first_name, last_name, email)
FROM '/Users/user/Downloads/new_employees.csv' WITH CSV HEADER;
/Users/user/Downloads/new_employees.csv: No such file or directory
postgres=# -- Basic import (table must exist)
COPY products FROM '/tmp/products.csv' WITH CSV HEADER;

-- Import specific columns only
COPY employees(first_name, last_name, email)
FROM '/tmp/new_employees.csv' WITH CSV HEADER;

-- Handle embedded commas and quotes
COPY customer_feedback TO '/tmp/feedback.csv' 
WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"';

-- Custom NULL representation
COPY sales_data FROM '/tmp/sales.csv' 
WITH CSV HEADER NULL 'NULL';
COPY 0
ERROR:  could not open file "/tmp/new_employees.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
COPY 0
ERROR:  could not open file "/tmp/sales.csv" for reading: No such file or directory
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.
postgres=# # Basic SQL dump
pg_dump -h localhost -U postgres -d your_database > backup.sql

# Custom compressed format (recommended)
pg_dump -h localhost -U postgres -d your_database -Fc > backup.dump

# Backup specific tables only
pg_dump -h localhost -U postgres -d your_database -t employees -t products > tables_backup.sql
postgres-# # Restore full database from custom format
pg_restore -h localhost -U postgres -d your_database backup.dump

# Restore into a new database
createdb restored_db
pg_restore -h localhost -U postgres -d restored_db backup.dump
postgres-# # Schema-only backup
pg_dump -h localhost -U postgres -d your_database -s > schema_only.sql

# Data-only backup
pg_dump -h localhost -U postgres -d your_database -a > data_only.sql

# Exclude specific tables
pg_dump -h localhost -U postgres -d your_database -T logs -T temp_data > backup_without_logs.sql
postgres-# pg_dumpall -h localhost -U postgres > full_cluster_backup.sql
postgres-# archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
wal_level = replica
postgres-# pg_basebackup -h localhost -U replication_user -D /backup/base -Ft -z -P
postgres=# -- Create staging table
CREATE TABLE staging_customers AS SELECT * FROM customers WHERE 1=0;

-- Extract data
COPY (SELECT * FROM customers) 
TO '/tmp/customers_batch.csv' WITH CSV HEADER;

-- Load into staging
COPY staging_customers FROM '/tmp/customers_batch.csv' WITH CSV HEADER;
SELECT 0
COPY 2
COPY 2
