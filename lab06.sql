postgres=# CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

CREATE TABLE
postgres=# DROP TABLE students;

DROP TABLE
postgres=# CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);
CREATE TABLE
postgres=# ALTER TABLE students
postgres-# ADD COLUMN date_of_birth DATE;
ALTER TABLE
postgres=# ALTER TABLE students
postgres-# DROP COLUMN faculty;
ALTER TABLE
postgres=# ALTER TABLE students
postgres-# ALTER COLUMN first_name TYPE TEXT;
ALTER TABLE
postgres=# ALTER TABLE students
ADD CONSTRAINT unique_student_email UNIQUE (email);
ALTER TABLE
postgres=# ALTER TABLE students
RENAME COLUMN email TO email_adress;
ALTER TABLE
postgres=# ALTER TABLE students
RENAME TO university_students;
ALTER TABLE
postgres=# CREATE TEMP TABLE temp_table_students (
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE
);
CREATE TABLE