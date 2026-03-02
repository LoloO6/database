postgres=# -- BAD: Multiple phone numbers in one column
CREATE TABLE students_bad (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone_numbers TEXT -- "123-456-7890, 098-765-4321"
);
CREATE TABLE
postgres=# -- GOOD: Atomic values
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE student_phones (
    student_id INT,
    phone_number VARCHAR(15),
    phone_type VARCHAR(20), -- 'mobile', 'home', etc.
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
CREATE TABLE
CREATE TABLE
postgres=# -- GOOD: Atomic values
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE student_phones (
    student_id INT,
    phone_number VARCHAR(15),
    phone_type VARCHAR(20), -- 'mobile', 'home', etc.
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
ERROR:  relation "students" already exists
ERROR:  relation "student_phones" already exists
postgres=# DROP TABLE IF EXISTS student_phones;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS students_bad;
DROP TABLE
DROP TABLE
DROP TABLE
postgres=# -- BAD: enrolment depends only on course_id, not on the full primary key
CREATE TABLE enrolments_bad (
    student_id INT,
    course_id INT,
    course_name VARCHAR(100), -- Partial dependency!
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id)
);
CREATE TABLE
postgres=# -- GOOD: Separate tables
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
ERROR:  relation "courses" already exists
ERROR:  relation "students" does not exist
postgres=# DROP TABLE IF EXISTS courses;
ERROR:  cannot drop table courses because other objects depend on it
DETAIL:  constraint student_enrollments_course_id_fkey on table student_enrollments depends on table courses
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
postgres=# DROP TABLE IF EXISTS courses CASCADE;
NOTICE:  drop cascades to constraint student_enrollments_course_id_fkey on table student_enrollments
DROP TABLE
postgres=# CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);
CREATE TABLE
CREATE TABLE
postgres=# DROP TABLE IF EXISTS students;
DROP TABLE
postgres=# DROP TABLE IF EXISTS departments;
DROP TABLE
postgres=# -- BAD: department_name depends on department_id, which depends on student_id
CREATE TABLE students_bad_3nf (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100) -- Transitive dependency!
);
CREATE TABLE
postgres=# -- GOOD: Separate department information
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    department_head VARCHAR(100)
);

CREATE TABLE students_good (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE
CREATE TABLE
postgres=# 
postgres=# -- GOOD: Library system example
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    publication_year INTEGER,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors (
    book_id INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    loan_date DATE DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE