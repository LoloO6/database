postgres=# -- Create main tables
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    major VARCHAR(50)
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    credits INTEGER
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    grade VARCHAR(2)
);
CREATE TABLE
CREATE TABLE
CREATE TABLE
postgres=# \dt
                    List of relations
 Schema |        Name         | Type  |       Owner       
--------+---------------------+-------+-------------------
 public | authors             | table | postgres
 public | blog_posts          | table | postgres
 public | book_authors        | table | postgres
 public | books               | table | postgres
 public | comments            | table | postgres
 public | course_enrollments  | table | postgres
 public | courses             | table | postgres
 public | customers           | table | postgres
 public | department          | table | postgres
 public | departments         | table | postgres
 public | enrollments         | table | postgres
 public | enrolments_bad      | table | postgres
 public | loans               | table | postgres
 public | members             | table | postgres
 public | orders              | table | postgres 
 public | products            | table | postgres
 public | student             | table | postgres
 public | student_enrollments | table | postgres
 public | students            | table | postgres
 public | students_bad_3nf    | table | postgres
 public | students_good       | table | postgres
 public | transactions        | table | postgres
 public | university_students | table | postgres
 public | user_profiles       | table | postgres
 public | users               | table | postgres
(25 rows)

postgres=# \d students
                                          Table "public.students"
   Column   |          Type          | Collation | Nullable |                   Default                    
------------+------------------------+-----------+----------+----------------------------------------------
 student_id | integer                |           | not null | nextval('students_student_id_seq'::regclass)
 name       | character varying(100) |           |          | 
 age        | integer                |           |          | 
 major      | character varying(50)  |           |          | 
Indexes:
    "students_pkey" PRIMARY KEY, btree (student_id)
Referenced by:
    TABLE "enrollments" CONSTRAINT "enrollments_student_id_fkey" FOREIGN KEY (student_id) REFERENCES students(student_id)