postgres=# CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    balance NUMERIC(10,2) NOT NULL
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    total NUMERIC(10,2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT,
    quantity INT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2)
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY REFERENCES products(product_id),
    stock INT
);

CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE user_preferences (
    pref_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    theme VARCHAR(50)
);

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    action TEXT,
    timestamp TIMESTAMP DEFAULT NOW()
);
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
postgres=# INSERT INTO accounts (balance) VALUES (1000), (500);

INSERT INTO customers (name, email) VALUES
('John Doe', 'john@email.com'),
('Alice', 'alice@email.com');

INSERT INTO products (name, price) VALUES
('Laptop', 999.99),
('Mouse', 25.99),
('Keyboard', 79.99),
('Monitor', 299.99);

INSERT INTO inventory (product_id, stock)
SELECT product_id, 10 FROM products;
INSERT 0 2
INSERT 0 2
INSERT 0 4
INSERT 0 4
postgres=# BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT; -- Both updates are saved permanently

BEGIN
UPDATE 1
UPDATE 1
COMMIT
postgres=# BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
-- Something went wrong, undo everything
ROLLBACK; -- Both updates are undone
BEGIN
UPDATE 1
UPDATE 1
ROLLBACK
postgres=# -- Transfer $500 from account 1 to account 2
BEGIN;

-- Check if account 1 has sufficient balance
SELECT balance FROM accounts WHERE account_id = 1;

-- If sufficient, perform the transfer
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;

-- If everything is correct, commit
COMMIT;
BEGIN
 balance 
---------
  900.00
(1 row)

UPDATE 1
UPDATE 1
COMMIT
postgres=# BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 2);
UPDATE inventory SET stock = stock - 2 WHERE product_id = 101;
-- If any of these fail, ALL are rolled back
COMMIT;
BEGIN
INSERT 0 1
INSERT 0 1
UPDATE 0
COMMIT
postgres=# -- This transaction maintains consistency by respecting foreign key constraints
BEGIN;
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
INSERT INTO orders (customer_id, total) VALUES (LASTVAL(), 100.00);
COMMIT;

BEGIN
INSERT 0 1
INSERT 0 1
COMMIT
postgres=# BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM accounts; -- May see uncommitted changes
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000; -- May differ
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts;
UPDATE accounts SET balance = balance * 1.05; -- 5% interest
COMMIT;
BEGIN
 account_id | balance 
------------+---------
          1 |  400.00
          2 | 1100.00
(2 rows)

COMMIT
BEGIN
 account_id | balance 
------------+---------
          2 | 1100.00
(1 row)

 account_id | balance 
------------+---------
          2 | 1100.00
(1 row)

COMMIT
BEGIN
 account_id | balance 
------------+---------
          2 | 1100.00
(1 row)

 account_id | balance 
------------+---------
          2 | 1100.00
(1 row)

COMMIT
BEGIN
 account_id | balance 
------------+---------
          1 |  400.00
          2 | 1100.00
(2 rows)

UPDATE 2
COMMIT
postgres=# ET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');

SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 500.00);

-- Something went wrong with the order
ROLLBACK TO SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 300.00);

COMMIT;
ERROR:  syntax error at or near "ET"
LINE 1: ET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        ^
BEGIN
INSERT 0 1
SAVEPOINT
INSERT 0 1
ROLLBACK
INSERT 0 1
COMMIT
postgres=# SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');

SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 500.00);

-- Something went wrong with the order
ROLLBACK TO SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 300.00);

COMMIT;
WARNING:  SET TRANSACTION can only be used in transaction blocks
SET
BEGIN
INSERT 0 1
SAVEPOINT
INSERT 0 1
ROLLBACK
INSERT 0 1
COMMIT
postgres=# -- Multiple savepoints
BEGIN;
INSERT INTO products (name, price) VALUES ('Laptop', 999.99);
SAVEPOINT sp1;

INSERT INTO products (name, price) VALUES ('Mouse', 25.99);
SAVEPOINT sp2;

-- Invalid product (negative price)
-- Rollback to previous point
ROLLBACK TO SAVEPOINT sp2;

INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);
COMMIT;


-- Releasing savepoints
BEGIN;
INSERT INTO logs (message) VALUES ('Starting process');
SAVEPOINT process_start;

INSERT INTO logs (message) VALUES ('Process completed');
RELEASE SAVEPOINT process_start;
COMMIT;
BEGIN
INSERT 0 1
SAVEPOINT
INSERT 0 1
SAVEPOINT
ROLLBACK
INSERT 0 1
COMMIT
BEGIN
INSERT 0 1
SAVEPOINT
INSERT 0 1
RELEASE
COMMIT
postgres=# -- Short transaction
BEGIN;
UPDATE inventory SET stock = stock - 1 WHERE product_id = 1;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 1, 1);
COMMIT;
BEGIN
UPDATE 1
INSERT 0 1
COMMIT
postgres=# -- Handling errors properly (with exception block)
DO $$
DECLARE
    insufficient_funds EXCEPTION;
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;

    IF current_balance < 100 THEN
        RAISE insufficient_funds;
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

EXCEPTION
    WHEN insufficient_funds THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
        ROLLBACK;
END $$;
ERROR:  type "exception" does not exist
LINE 3:     insufficient_funds EXCEPTION;
                               ^
postgres=# DO $$
DECLARE
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;

    IF current_balance < 100 THEN
        RAISE EXCEPTION 'Transaction failed: Insufficient funds';
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

    RAISE NOTICE 'Transaction completed successfully';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Transaction failed and changes were rolled back.';
        ROLLBACK;
END $$;
NOTICE:  Transaction completed successfully
DO
postgres=# 
postgres=# -- Use appropriate isolation
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Critical financial operation
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Reporting query
COMMIT;


-- Savepoints in complex operations
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 1000.00);
SAVEPOINT before_items;

INSERT INTO order_items (order_id, product_id, quantity) 
VALUES (currval('orders_order_id_seq'), 1, 2);

INSERT INTO order_items (order_id, product_id, quantity) 
VALUES (currval('orders_order_id_seq'), 2, 1);
COMMIT;


-- Check for blocking transactions
SELECT 
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity 
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;


-- Explicit transaction control
BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (currval('users_user_id_seq'), 'dark');
COMMIT;
BEGIN
COMMIT
BEGIN
COMMIT
BEGIN
INSERT 0 1
SAVEPOINT
INSERT 0 1
INSERT 0 1
COMMIT
 blocked_pid | blocked_user | blocking_pid | blocking_user | blocked_statement 
-------------+--------------+--------------+---------------+-------------------
(0 rows)

BEGIN
INSERT 0 1
INSERT 0 1
INSERT 0 1
COMMIT