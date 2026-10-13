--Serikbai Daulet 25B031822

CREATE TABLE employees (
    employee_id integer,
    first_name text,
    last_name text,
    age integer CHECK (age BETWEEN 18 AND 65),
    salary numeric CHECK (salary > 0)
);

CREATE TABLE products_catalog(
    product_id integer,
    product_name text,
    regular_price numeric,
    discount_price numeric,
    CONSTRAINT valid_discount CHECK(
        regular_price>0 and
        discount_price>0 and
        discount_price<regular_price
    )
);

CREATE TABLE booking(
    booking_id integer,
    check_in_date date,
    check_out_date date,
    num_guests integer CHECK(num_guests BETWEEN 1 AND 10 ),
    CONTRAINTS valid_dates CHECK(check_out_date>check_in_date)
);

INSERT INTO employees VALUES (1, 'Daulet', 'Zhasarov', 25, 50000.00);
INSERT INTO employees VALUES (2, 'Azhar', 'Sharipova', 42, 75000.50);

INSERT INTO products_catalog VALUES (101, 'Laptop', 1000.00, 850.00);
INSERT INTO products_catalog VALUES (102, 'Mouse', 50.00, 39.99);

INSERT INTO bookings VALUES (1, '2026-06-01', '2026-06-07', 2);
INSERT INTO bookings VALUES (2, '2026-07-10', '2026-07-15', 4);

--1
INSERT INTO employees VALUES (3, 'Aleksei', 'ivanov', 17, 0);
--problem:age is under 18 and salary equals 0
--2
INSERT INTO products_catalog VALUES (103, 'Tablet', 300.00, 350.00);
--problem : discount price more than regular
--3
INSERT INTO bookings VALUES (3, '2026-08-05', '2026-08-01', 12);
--problem: guests more than 10 and check in date more than check out date

CREATE TABLE customers(
    customer_id integer not null,
    email text not null,
    phone text,
    registration_date date not null
);

CREATE TABLE inventory(
    item_id integer not null,
    item_name text not null,
    quantity integet not null check(quantity>=0),
    unit_price numeric not null check(unit_price>0),
    last_updated timestamp not null
);

insert into customers values(1, 'dfmvjdsnjsdn@gmail.com', '+7777777777', '2023-09-09');
insert into customers values(2, 'noenrwjvnewvn@gmail.com', '+7898888890', '2021-09-02');

insert into inventory values(10, 'mouse', 30, 20.00, '2026-10-12 10:20:00');
insert into inventory values(11, 'touchpad', 15, 45.50, '2026-10-12 10:00:00');

insert into customers values(3, null, '+900808098', '2026-01-01');

insert into inventory values(12, 'monitor', 5, null, '2026-10-10 11:11:11');

INSERT INTO customers VALUES (4, 'mkdmvkgfdfdfm@gmail.com', NULL, '2026-10-02');

create table users(
    user_id integer,
    username text unique,
    email text unique,
    created_at timestamp
);

create table course_enrollments(
    enrollment_id integer,
    student_id integer,
    course_code text,
    semester text,
    constraint unique_s_c_s unique(student_id, course_code, semester)
);

alter table users
    add constraint unique_username unique(username),
    add constraint uniqe_email unique(email);

INSERT INTO users VALUES (1, 'kiraki', 'kiraki@gmail.com', '2026-10-12 12:00:00');
INSERT INTO users VALUES (2, 'kiraki', 'kiraki@gmail.com', '2026-10-12 12:00:00');

create table departments(
    dept_id integer primery key,
    dept_name text not null,
    location text
);

insert into departments values(1, 'hr','almaty');
insert into departments values(2, 'engineering', 'astana');
insert into departments values(3, 'marketing', 'shymket');

insert into departments values(1, 'sales', 'almaty');

insert into departments values(null, 'finance', 'aktau');

create table student_courses(
    student_id integer,
    course_id integer,
    enrollment_date date,
    grade text,
    primary key(student_id, course_id)
);

--primary key cannot be empty, while unique can be empty
--we use single_column primary key when one column is enough to identify a row, we use composite primary key when we need two or more columns together to make a row unique
--a table represents one main thing, so it has one main identity just like a person has one main passport number, however person can have many other details that must be unique , that is why we can have many unique constrains

create table employees_dept(
    emp_id integer primary key,
    emp_name text not null,
    dept_id integer references departments(dept_id),
    hire_date date
);

INSERT INTO employees_dept VALUES (101, 'aleksey', 1, '2026-05-01');
INSERT INTO employees_dept VALUES (102, 'maria', 2, '2026-05-15');

INSERT INTO employees_dept VALUES (103, 'ivan', 999, '2026-06-01');

create table authors(
    author_id integer primary key,
    author_name text not null,
    country text
);

create table publishers(
    publisher_id integer primary key,
    publisher_name text not null,
    city text
);

create table books(
    book_id integer primary key,
    title text not null,
    author_id integer references authors(author_id),
    publisher_id integer peferences publishers(publisher_id),
    publication_year integer,
    isbn text unique
);

INSERT INTO authors VALUES (1, 'Лев Толстой', 'Россия');
INSERT INTO authors VALUES (2, 'Джордж Оруэлл', 'Великобритания');

INSERT INTO publishers VALUES (1, 'ЭКСМО', 'Москва');
INSERT INTO publishers VALUES (2, 'Penguin Books', 'Лондон');

INSERT INTO books VALUES (101, 'Война и мир', 1, 1, 1869, '978-5-699-12345-6');
INSERT INTO books VALUES (102, '1984', 2, 2, 1949, '978-0-141-18776-1');

CREATE TABLE categories (
    category_id integer PRIMARY KEY,
    category_name text NOT NULL
);

CREATE TABLE products_fk (
    product_id integer PRIMARY KEY,
    product_name text NOT NULL,
    category_id integer REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    order_date date NOT NULL
);

CREATE TABLE order_items (
    item_id integer PRIMARY KEY,
    order_id integer REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id integer REFERENCES products_fk(product_id),
    quantity integer CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'electronics');
INSERT INTO products_fk VALUES (10, 'smartphone', 1);

INSERT INTO orders VALUES (100, '2026-10-12');
INSERT INTO order_items VALUES (1, 100, 10, 2);

--error because of restrict
DELETE FROM categories WHERE category_id = 1;

--order_items will be authomatically deleted because of cascade
DELETE FROM orders WHERE order_id = 100;

create table customers(
    customer_id integer primary key,
    name text not null,
    email text not null contraint unique_customer_email unique,
    phone text,
    registration_date date not null
);

create table products(
    product_id integer primary key,
    name text not null,
    description text,
    price numeric not null check(price>=0),
    stock_quantity integer not null check(stock_quantity>=0)
);

create table orders(
    order_id integer primary key,
    customer_id integer not null references(customer_id) on delete restrict,
    order_date date not null,
    total_amount numeric not null check(total_amount>=0),
    status text not null check(status in ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

create table order_details(
    order_detail_id integer primary key,
    order_id integer not null references orders(order_id) on delete cascade,
    product_id integer not null references products(product_id) on delete restrict,
    quantity integer not null check(quantity>0),
    unit_price numeric not null check(unit_price>=0)
);

INSERT INTO customers VALUES (1, 'Алексей Смирнов', 'alex@mail.com', '+77011234567', '2026-01-10');
INSERT INTO customers VALUES (2, 'Елена Ким', 'elena@gmail.com', '+77029876543', '2026-03-15');
INSERT INTO customers VALUES (3, 'Дмитрий Пак', 'dmitriy@yandex.ru', NULL, '2026-05-20');
INSERT INTO customers VALUES (4, 'Ольга Цой', 'olga@mail.com', '+77051112233', '2026-07-01');
INSERT INTO customers VALUES (5, 'Тимур Ибраев', 'timur@gmail.com', '+77074445566', '2026-09-10');

INSERT INTO products VALUES (101, 'Смартфон', 'Мобильный телефон 128GB', 250000.00, 15);
INSERT INTO products VALUES (102, 'Ноутбук', 'Игровой ноутбук 16GB', 450000.00, 5);
INSERT INTO products VALUES (103, 'Наушники', 'Беспроводные наушники', 45000.00, 30);
INSERT INTO products VALUES (104, 'Монитор', '27 дюймов IPS 144Hz', 120000.00, 8);
INSERT INTO products VALUES (105, 'Клавиатура', 'Механическая клавиатура RGB', 35000.00, 20);

INSERT INTO orders VALUES (1001, 1, '2026-10-01', 295000.00, 'shipped');
INSERT INTO orders VALUES (1002, 2, '2026-10-05', 450000.00, 'processing');
INSERT INTO orders VALUES (1003, 3, '2026-10-08', 45000.00, 'pending');
INSERT INTO orders VALUES (1004, 4, '2026-10-10', 120000.00, 'delivered');
INSERT INTO orders VALUES (1005, 5, '2026-10-11', 35000.00, 'pending');

INSERT INTO order_details VALUES (1, 1001, 101, 1, 250000.00);
INSERT INTO order_details VALUES (2, 1001, 103, 1, 45000.00);
INSERT INTO order_details VALUES (3, 1002, 102, 1, 450000.00);
INSERT INTO order_details VALUES (4, 1003, 103, 1, 45000.00);
INSERT INTO order_details VALUES (5, 1004, 104, 1, 120000.00);

-- test 1: error CHECK constraint for order status
INSERT INTO orders VALUES (1006, 1, '2026-10-12', 1000.00, 'unknown_status');

-- test 2: error UNIQUE constraint for client email(duplicate)
INSERT INTO customers VALUES (6, 'Новый Клиент', 'alex@mail.com', '+77000000000', '2026-10-12');

-- test 3: error CHECK constraint for product price (negative price)
INSERT INTO products VALUES (106, 'Брак', 'Тестовый товар', -100.00, 10);

-- test 4: error CHECK constraint for quantity, quantity should be nore than 0 not equal or less
INSERT INTO order_details VALUES (6, 1005, 105, 0, 35000.00);

-- test 5: error FOREIGN KEY constraint (customer id which does not exist)
INSERT INTO orders VALUES (1007, 999, '2026-10-12', 50000.00, 'pending');
