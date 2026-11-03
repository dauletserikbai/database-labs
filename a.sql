CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2)
);
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10, 2)
);

--- Insert data into employees
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);-- Insert data into departments
INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');-- Insert data into projects
INSERT INTO projects (project_id, project_name, dept_id,
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);


SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
--5*4=20

select e.emp_name, d.dept_name from employees e, departments d;

select e.emp_name ,d.dept_name from employees e inner join departments d on true;

select e.emp_name, p.project_name from employees e cross join projects p;

select e.emp_name, d.dept_name, d.location from employees e inner join departments d on e.dept_id=d.dept_id;
--4 rows, tom not included because dept id=null

select emp_name, dept_name, location from employees inner join departments using(dept_id);
--outputs are the same

select emp_name, dept_name, location from employees natural inner join departments;

select e.emp_name, d.dept_name, p.project_name from employees e inner join departments d on e.dept_id=d.dept_id inner join projects p on d.dept_id=p.dept_id;

select e.emp_id, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e
left join departments d on e.dept_id=d.dept_id;
--tom represented without emp_dept, dept_dept  and dept_name;

select emp_name, dept_id, dept_name
from employees
left join departments using(dept_id);

select e.emp_name, e.dept_id
from employees e
left join departments d on e.dept_id=d.dept_id
where d.dept_id is null;

select d.dept_name, count(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id=e.dept_id
group by d.dept_id, d.dept_name
order by employee_count desc;

select e.emp_name, d.dept_name
from employees e right join departments d on e.dept_id=d.dept_id;

select e.emp_name, d.dept_name
from departments d left join employees e on d.dept_id=e.dept_id;

select d.dept_name, d.location
from employees e right join departments d on e.dept_id=d.dept_id
where e.emp_id is null;

select e.emp_id, e.dept_id as emp_dept, d.dept_id as dept_dept, d.dept_name
from employees e full join departments d on e.dept_id=d.dept_id;

select d.dept_name, p.project_name, p.budget
from departments d full join projects p on d.dept_id=p.dept_id;

select
    case
        when e.emp_id is null then 'department without employees'
        when d.dept_id is null then 'emloyee without department'
        else 'matched'
    end as record_status,
    e.emp_name,
    d.dept_name
from employees e
full join departments d on e.dept_id=d.dept_id
where e.emp_id is null or d.dept_id is null;

select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id=d.dept_id and d.location='Building A';

select e.emp_name, d.dept_name, e.salary
from employees e left join departments d on e.dept_id=d.dept_id
where d.location='Building A';
--(ON clause): Applies the filter BEFORE the join, so all employees are included, but only departments in Building A are matched. (WHERE clause): Applies the filter AFTER the join, so employees are excluded if their department is not in Building A.

select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d
    on e.dept_id=d.dept_id
    and d.location='Building A';


select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d
    on e.dept_id=d.dept_id
where d.location='Building A';
--output is the same, with an INNER JOIN, both records without matches and records that do not meet the filter are excluded.

select
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
from departments d
left join employees e on d.dept_id=e.dept_id
left join projects p on d.dept_id=p.dept_id
order by d.dept_name, e.emp_name;

alter table employees add column manager_id int;

UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;

select
    e.emp_name as employee,
    m.emp_name as manager
from employees e
left join employees m on e.manager_id=m.emp_id;

select d.dept_name, avg(e.salary) as avg_salary
from departments d inner join employees e on d.dept_id=e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary)>50000;
