CREATE TABLE employees (
 employee_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 department VARCHAR(50),
 salary NUMERIC(10,2),
 hire_date DATE,
 manager_id INTEGER,
 email VARCHAR(100)
);
CREATE TABLE projects (
 project_id SERIAL PRIMARY KEY,
 project_name VARCHAR(100),
 budget NUMERIC(12,2),
 start_date DATE,
 end_date DATE,
 status VARCHAR(20)
);
CREATE TABLE assignments (
 assignment_id SERIAL PRIMARY KEY,
 employee_id INTEGER REFERENCES employees(employee_id),
 project_id INTEGER REFERENCES projects(project_id),
 hours_worked NUMERIC(5,1),
 assignment_date DATE
);


INSERT INTO employees (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');
INSERT INTO projects (project_name, budget, start_date,
end_date, status) VALUES
('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
('Database Migration', 120000, '2024-01-10', NULL, 'Active');
INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
(1, 1, 120.5, '2024-01-15'),
(2, 1, 95.0, '2024-01-20'),
(1, 4, 80.0, '2024-02-01'),
(3, 3, 60.0, '2024-03-05'),
(5, 2, 110.0, '2024-02-20'),
(6, 3, 75.5, '2024-03-10');

--task 1.1
SELECT first_name || ' ' || last_name AS full_name, department, salary FROM employees;
--task 1.2
SELECT DISTINCT department from employees;
--task 1.3
Select
    project_name,
    budget,
    case
        when budget>150000 then 'Large'
        when budget between 100000 and 150000 then 'medium'
        else 'Small'
    end as budget_category
from projects;
--task 1.4
select
    first_name || ' ' || last_name as full_name,
    coalesce(email, 'No email provided') as email
from employees;
--task 2.1
select * from employees where hire_date> '2020-01-01';
--task 2.2
select * from employees where salary between 60000 and 70000;
--task 2.3
select * from employees where last_name like 'S%' or last_name like 'J%';
--task 2.4
select * from employees where manager_id is not null and department='IT';
--task 3.1
Select upper(first_name || ' ' || last_name) as full_upper_name, length(last_name) as last_naem_length, substring(email from 1 for 3) as email_sub from employees;
--task 3.2
select first_name || ' ' || last_name as employee_name, salary*12 as annual_salary, round(salary/12.0, 2) as monthly_salary, round(salary*0.10,2) as raise_amount from employees;
--task 3.3
select format('Project: %s -Budget: $%s -Status: %s', project_name, budget, status) as project_details from projects;
--task 3.4
select first_name || ' ' || last_name as full_name, extract(year from age(current_date, hire_date)) as years_with_company from employees;
--task 4.1
select department, round(avg(salary), 2) as average_slary from employees group by department;
--task 4.2
select p.project_name, sum(a.hours_worked) as total_hours from projects p join assignments a on p.project_id = a.project_id group by p.project_id, p.project_name;
--task 4.3
select department, count(*) as employee_count from employees group by department having count(*)>1;
--task 4.4
select max(salary) as max_salary, min(salary) as min_salary, sum(salary) as total_salary from employees;
--task 5.1
select
    employee_id,
    first_name || ' ' || last_name as full_name,
    salary
from employees
where salary>65000

union

select
    employee_id,
    first_name || ' ' || last_name as full_name,
    salary
from employees
where hire_date>'2020-01-01';
--task 5.2
select
    employee_id,
    first_name || ' ' || last_name as full_name
from employees
where department ='IT'

intersect

select
    employee_id,
    first_name || ' ' || last_name as full_name
from employees
where salary>65000;
--task 5.3
select employee_id from employees

except

select employee_id from assignments;

--task 6.1
select e.* from employees e
where exists(
    select 1
    from assignments a
    where a.employee_id=e.employee_id

);

--task 6.2
select *
from employees
where employee_id in(
    select a.employee_id
    from assignments a join projects p on a.project_id = p.project_id
    where p.status='Active'
);

--task 6.3

SELECT *
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);
--task 7.1
select
    e.first_name ||' '|| e.last_name as employee_name,
    e.department,
    round(avg(a.hours_worked), 2) as avg_hours,
    dense_rank() over (partition by e.department order by e.salary desc) as salary_rank
from employees e left join assignments a on e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary
ORDER BY e.department, salary_rank;


--task 7.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS assigned_employees_count
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;

--task 7.3
WITH RankedEmployees AS (
    SELECT
        department,
        first_name || ' ' || last_name AS full_name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT
    e.department,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary,
    re.full_name AS highest_paid_employee,
    GREATEST(MAX(e.salary), MIN(e.salary)) AS max_salary_check,
    LEAST(MIN(e.salary), MAX(e.salary)) AS min_salary_check
FROM employees e
JOIN RankedEmployees re ON e.department = re.department AND re.rn = 1
GROUP BY e.department, re.full_name;



















