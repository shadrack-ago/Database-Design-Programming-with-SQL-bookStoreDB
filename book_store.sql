CREATE DATABASE bookstore;
USE bookstore;

-- Table 1. author

CREATE TABLE author (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    biography TEXT,
    birth_date DATE
);


-- Table 2. book_language

CREATE TABLE book_language (
    id VARCHAR(36) PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);


-- table 3. publisher

CREATE TABLE publisher (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


-- table 4. book

CREATE TABLE book (
    id VARCHAR(36) PRIMARY KEY,
    publisher_id VARCHAR(36),
    title VARCHAR(200) NOT NULL,
    language_id VARCHAR(36),
    DateOfPublish_id DATE,
    FOREIGN KEY (publisher_id) REFERENCES publisher(id),
    FOREIGN KEY (language_id) REFERENCES book_language(id)
);


-- table 5. book_author

CREATE TABLE book_author (
    id VARCHAR(36) PRIMARY KEY,
    author_id VARCHAR(36),
    book_id VARCHAR(36),
    FOREIGN KEY (author_id) REFERENCES author(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
);


-- table 6. country

CREATE TABLE country (
    id VARCHAR(36) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);


-- table 7. address

CREATE TABLE address (
    id VARCHAR(36) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    country_id VARCHAR(36),
    FOREIGN KEY (country_id) REFERENCES country(id)
);



-- table 8. address_status

CREATE TABLE address_status (
    id VARCHAR(36) PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);


-- table 9. customer

CREATE TABLE customer (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);


-- table 10. customer_address

CREATE TABLE customer_address (
    id VARCHAR(36) PRIMARY KEY,
    address_id VARCHAR(36),
    status_id VARCHAR(36),
    customer_id VARCHAR(36),
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (status_id) REFERENCES address_status(id),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);


--table 11. shipping_method

CREATE TABLE shipping_method (
    id VARCHAR(36) PRIMARY KEY NOT NULL,
    method_name VARCHAR(50) NOT NULL
);


-- table 12. order_status

CREATE TABLE order_status (
    id VARCHAR(36) PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);


-- table13. cust_order

CREATE TABLE cust_order (
    id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id VARCHAR(36),
    status_id VARCHAR(36) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);

-- Table 14 order_line

CREATE TABLE order_line (
    id VARCHAR(36) PRIMARY KEY,
    book_id VARCHAR(36),
    quantity INT NOT NULL CHECK (quantity > 0),
    order_id VARCHAR(36),
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (order_id) REFERENCES cust_order(id)
);

-- table 15 order_history


CREATE TABLE order_history (
    id VARCHAR(36) PRIMARY KEY,
    order_id VARCHAR(36),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_id VARCHAR(36),
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (status_id) REFERENCES order_status(id)
);


-- Added indexes for frequently queried columns
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_customer_email ON customer(email);
CREATE INDEX idx_order_date ON cust_order(order_date);




-- DO we need this columns in the book table?  To be removed..

ALTER TABLE book ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE book ADD COLUMN updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

