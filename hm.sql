CREATE SCHEMA LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors
(
    author_id   INT AUTO_INCREMENT
        PRIMARY KEY ,
    author_name VARCHAR(255) NOT NULL
);

CREATE TABLE genres
(
    genre_id   INT AUTO_INCREMENT
        PRIMARY KEY ,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE books
(
    book_id          INT AUTO_INCREMENT
        PRIMARY KEY,
    title            VARCHAR(255) NULL,
    publication_year YEAR         NULL,
    author_id        INT          NULL,
    genre_id         INT          NULL,
    CONSTRAINT books_authors_author_id_fk
        FOREIGN KEY (author_id) REFERENCES authors (author_id),
    CONSTRAINT books_genres_genre_id_fk
        FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
);

CREATE TABLE users
(
    user_id  INT AUTO_INCREMENT
        PRIMARY KEY ,
    username VARCHAR(255) NOT NULL,
    email    VARCHAR(255) NULL
);

CREATE TABLE borrowed_books
(
    borrow_id INT AUTO_INCREMENT
        PRIMARY KEY,
    book_id   INT NULL,
    user_id   INT NULL,
    borrow_date DATE,
    return_date DATE,
    CONSTRAINT borrowed_books_books_book_id_fk
        FOREIGN KEY (book_id) REFERENCES books (book_id),
    CONSTRAINT borrowed_books_users_user_id_fk
        FOREIGN KEY (user_id ) REFERENCES users (user_id)
);

INSERT INTO authors (author_name) VALUES ('Jane Austen');
INSERT INTO authors (author_name) VALUES ('Charles Dickens');
INSERT INTO authors (author_name) VALUES ('Mark Twain');

INSERT INTO genres (genre_name) VALUES ('Fiction');
INSERT INTO genres (genre_name) VALUES ('Love novel');
INSERT INTO genres (genre_name) VALUES ('Satire');
INSERT INTO genres (genre_name) VALUES ('A novel of customs');
INSERT INTO genres (genre_name) VALUES ('Novel');

INSERT INTO users (username, email) VALUES ('Reader1', 'reader1@gmail.com');
INSERT INTO users (username, email) VALUES ('User42', 'user42@gmail.com');
INSERT INTO users (username, email) VALUES ('NomadReader', 'nomad-reader@gmail.com');

INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES ('Pride and Prejudice', 2001, 1, 1);

INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES ('Great Expectations', 2024, 2, 5);

INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES ('The Adventures of Huckleberry Finn', 2020, 3, 5);

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES (3, 3, '2024-11-20', NULL);

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES (2, 1, '2024-11-08', '2024-12-01');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES (1, 2, '2024-12-02', NULL);

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES (2, 2, '2024-12-02', NULL);

USE mydb;

SELECT
    orders.id AS order_id,
    customers.name AS customer_name,
    CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name,
    shippers.name AS shipper_name,
    products.name AS product_name,
    suppliers.name AS supplier_name,
    categories.name AS category_name,
    order_details.quantity AS quantity,
    orders.date AS order_date
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id
         INNER JOIN employees ON orders.employee_id = employees.employee_id
         INNER JOIN shippers ON orders.shipper_id = shippers.id
         INNER JOIN order_details ON orders.id = order_details.order_id
         INNER JOIN products ON order_details.product_id = products.id
         INNER JOIN suppliers ON products.supplier_id = suppliers.id
         INNER JOIN categories ON products.category_id = categories.id;

# 1. COUNT the number of rows in the full join query
SELECT COUNT(*) AS count_all
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id
         INNER JOIN employees ON orders.employee_id = employees.employee_id
         INNER JOIN shippers ON orders.shipper_id = shippers.id
         INNER JOIN order_details ON orders.id = order_details.order_id
         INNER JOIN products ON order_details.product_id = products.id
         INNER JOIN suppliers ON products.supplier_id = suppliers.id
         INNER JOIN categories ON products.category_id = categories.id;

# 2. Replace INNER JOINs with LEFT JOINs and count rows
SELECT COUNT(*) AS count_all
FROM orders
         LEFT JOIN customers ON orders.customer_id = customers.id
         RIGHT JOIN employees ON orders.employee_id = employees.employee_id
         LEFT JOIN shippers ON orders.shipper_id = shippers.id
         RIGHT JOIN order_details ON orders.id = order_details.order_id
         LEFT JOIN products ON order_details.product_id = products.id
         RIGHT JOIN suppliers ON products.supplier_id = suppliers.id
         LEFT JOIN categories ON products.category_id = categories.id;
# Кількість рядків у результаті залежить від типу з'єднання:
# INNER JOIN обмежує кількість рядків, залишаючи тільки ті, що мають відповідності.
# LEFT JOIN або RIGHT JOIN додають рядки з однієї таблиці навіть за відсутності відповідностей в іншій, збільшуючи кількість рядків у результаті.
# Схоже що жодна з таблиць не має дублювань за ключами, тому кількість рядків буде визначатися кількістю рядків у найменшій таблиці з відповідностями.

# 3. Filter rows where employee_id > 3 and ≤ 10
SELECT
    orders.id AS order_id,
    customers.name AS customer_name,
    CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name,
    shippers.name AS shipper_name,
    products.name AS product_name,
    suppliers.name AS supplier_name,
    categories.name AS category_name,
    order_details.quantity AS quantity,
    orders.date AS order_date,
    orders.employee_id AS employee_id
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id
         INNER JOIN employees ON orders.employee_id = employees.employee_id
         INNER JOIN shippers ON orders.shipper_id = shippers.id
         INNER JOIN order_details ON orders.id = order_details.order_id
         INNER JOIN products ON order_details.product_id = products.id
         INNER JOIN suppliers ON products.supplier_id = suppliers.id
         INNER JOIN categories ON products.category_id = categories.id
WHERE orders.employee_id BETWEEN 3 AND 10;

# Group by category name, count rows, calculate average quantity, sort by row count and limit
SELECT categories.name AS category_name, COUNT(*) AS row_count, AVG(order_details.quantity) AS avg_quantity
FROM orders
         INNER JOIN customers ON orders.customer_id = customers.id
         INNER JOIN employees ON orders.employee_id = employees.employee_id
         INNER JOIN shippers ON orders.shipper_id = shippers.id
         INNER JOIN order_details ON orders.id = order_details.order_id
         INNER JOIN products ON order_details.product_id = products.id
         INNER JOIN suppliers ON products.supplier_id = suppliers.id
         INNER JOIN categories ON products.category_id = categories.id
GROUP BY categories.name
HAVING AVG(order_details.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;


