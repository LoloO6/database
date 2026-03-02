postgres=# CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

CREATE TABLE
postgres=# INSERT INTO students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');

INSERT INTO students (first_name, last_name, birth_date) VALUES
('Ainura', 'Totomamatova', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');
INSERT 0 1
INSERT 0 3
postgres=# -- Update data
UPDATE students
SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek' AND last_name = 'Sharshenov';
UPDATE 1
postgres=# -- Delete specific rows
DELETE FROM students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova';
DELETE 1
postgres=# DELETE FROM students
WHERE birth_date < '2002-01-01';
DELETE 1
postgres=# UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov');
UPDATE 0
postgres=# DELETE FROM students
WHERE student_id IN (2, 3, 5);
DELETE 1