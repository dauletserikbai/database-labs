CREATE DATABASE advanced_lab;
USE advanced_lab;

CREATE TABLE employees(
    emp_id int auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50),
    salary int,
    hire_date date,
    status varchar(20) default 'Active'
);

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT,
    manager_id INT
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget INT
);

INSERT INTO employees(emp_id, first_name, last_name, department)
values (1, 'daulet', 'serik', 'it');

INSERT INTO employees( first_name, last_name, department, salary, hire_date, status)
values('ardak', 'bauyr', 'teacher',  default, '2023-12-12', default );

INSERT INTO departments(dept_name, budget, manager_id)
values
    ( 'it', 10000, 1),
    ('hr', 30000,2),
    ('marketing', 20000,3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Ali', 'Bakir', 'IT', 50000 * 1.1, CURRENT_DATE);

CREATE TEMPORARY TABLE temp_employees AS
SELECT * FROM employees WHERE department = 'IT';

UPDATE employees
SET salary = salary * 1.10;

UPDATE employees
SET status = 'Senior' WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments d
SET budget = (
    SELECT AVG(salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
);

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';


DELETE FROM employees
WHERE status = 'Terminated';


DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;


DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);


DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;


INSERT INTO employees (first_name, last_name, salary, department, hire_date)
VALUES ('Micha', 'Geleshvili', NULL, NULL, '2023-05-01');


UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;


DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;


INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Aisha', 'Aram', 'Sales', 60000, '2022-03-01')
RETURNING emp_id, CONCAT(first_name, ' ', last_name) AS full_name;


UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;


DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;


INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'Dara', 'Salute', 'Sales', 55000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Dara' AND last_name = 'Salute'
);


UPDATE employees e
SET salary = CASE
    WHEN (
        SELECT budget
        FROM departments d
        WHERE d.dept_name = e.department
    ) > 100000 THEN salary * 1.10
    ELSE salary * 1.05
END;



INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES
    ('Arman', 'Pusu', 'Sales', 45000, '2023-01-10'),
    ('Asel', 'Sisu', 'Temp', 35000, '2023-02-15'),
    ('Askar', 'Susi', 'Sales', 48000, '2023-03-20'),
    ('Aziz', 'Pupo', 'Sales', 52000, '2023-04-05'),
    ('Pariza', 'Popu', 'Sales', 50000, '2023-05-12');

UPDATE employees
SET salary = salary * 1.10;


CREATE TABLE employee_archive AS
SELECT * FROM employees WHERE 1 = 0;

INSERT INTO employee_archive
SELECT *
FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';


UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT d.dept_id
      FROM departments d
      JOIN employees e ON d.dept_name = e.department
      GROUP BY d.dept_id
      HAVING COUNT(e.emp_id) > 3
  );