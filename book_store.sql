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


-- table 11. shipping_method

CREATE TABLE shipping_method (
    id VARCHAR(36) PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL
);

-- table 12. order_status

CREATE TABLE order_status (
    id VARCHAR(36) PRIMARY KEY,
    status_name ENUM('New', 'Processing', 'Shipped', 'Delivered')
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

-- audit/logging columns for tracking changes
ALTER TABLE author ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE book ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE customer ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;




-- Table Insertions
-- Parent Tables First (Independent Tables)
START TRANSACTION;

INSERT INTO book_language (id, language_name) VALUES
('lang_eng', 'English'),
('lang_fre', 'French'),
('lang_spa', 'Spanish');

INSERT INTO publisher (id, name) VALUES
('pub_penguin', 'Penguin Random House'),
('pub_harper', 'HarperCollins'),
('pub_simon', 'Simon & Schuster');

INSERT INTO country (id, country_name) VALUES
('ctry_us', 'United States'),
('ctry_uk', 'United Kingdom'),
('ctry_ca', 'Canada');

INSERT INTO address_status (id, status_name) VALUES
('addrstat_home', 'Home'),
('addrstat_work', 'Work'),
('addrstat_bill', 'Billing');

INSERT INTO shipping_method (id, method_name) VALUES
('ship_std', 'Standard Shipping'),
('ship_exp', 'Express Shipping'),
('ship_int', 'International');

INSERT INTO order_status (id, status_name) VALUES
('ordstat_new', 'New'),
('ordstat_proc', 'Processing'),
('ordstat_ship', 'Shipped'),
('ordstat_del', 'Delivered');

COMMIT;

START TRANSACTION;

INSERT INTO author (id, name, biography, birth_date) VALUES
('auth_rowling', 'J.K. Rowling', 'Harry Potter series author', '1965-07-31'),
('auth_king', 'Stephen King', 'Master of horror fiction', '1947-09-21'),
('auth_atwood', 'Margaret Atwood', 'Canadian literary icon', '1939-11-18');

INSERT INTO book (id, publisher_id, title, language_id, DateOfPublish_id) VALUES
('book_hp1', 'pub_penguin', 'Harry Potter and the Philosopher''s Stone', 'lang_eng', '1997-06-26'),
('book_shining', 'pub_harper', 'The Shining', 'lang_eng', '1977-01-28'),
('book_handmaid', 'pub_simon', 'The Handmaid''s Tale', 'lang_eng', '1985-08-01');

COMMIT;


-- Relationship Tables (Dependent Tables)
START TRANSACTION;

-- Book-author relationships
INSERT INTO book_author (id, author_id, book_id) VALUES
('ba_hp_rowling', 'auth_rowling', 'book_hp1'),
('ba_sh_king', 'auth_king', 'book_shining'),
('ba_hm_atwood', 'auth_atwood', 'book_handmaid');

-- Customers with transaction protection
INSERT INTO customer (id, name, email) VALUES
('cust_john', 'John Smith', 'john.smith@example.com'),
('cust_emma', 'Emma Johnson', 'emma.j@example.com');

-- Addresses with country references
INSERT INTO address (id, street, city, postal_code, country_id) VALUES
('addr_john_home', '123 Main St', 'New York', '10001', 'ctry_us'),
('addr_emma_work', '456 Oxford St', 'London', 'W1D 1BS', 'ctry_uk');

-- Customer-address links
INSERT INTO customer_address (id, customer_id, address_id, status_id) VALUES
('ca_john_home', 'cust_john', 'addr_john_home', 'addrstat_home'),
('ca_emma_work', 'cust_emma', 'addr_emma_work', 'addrstat_work');

COMMIT;

