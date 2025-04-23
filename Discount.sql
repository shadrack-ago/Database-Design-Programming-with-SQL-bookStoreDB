CREATE TABLE discount (
    id VARCHAR(36) PRIMARY KEY,
    discount_name VARCHAR(100),
    discount_percent DECIMAL(5,2),
    valid_from DATE,
    valid_to DATE
);

-- Junction table to apply discounts to specific books
CREATE TABLE book_discount (
    id VARCHAR(36) PRIMARY KEY,
    book_id VARCHAR(36),
    discount_id VARCHAR(36),
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (discount_id) REFERENCES discount(id)
);
