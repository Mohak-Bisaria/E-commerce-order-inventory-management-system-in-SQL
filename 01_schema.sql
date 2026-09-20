-- ============================================
-- E-commerce Order & Inventory Management System
-- Schema (MySQL syntax; minor tweaks for Postgres/SQLite)
-- ============================================

CREATE TABLE categories (
    category_id     INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    parent_id       INT,                     -- self-referencing for hierarchy
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id     INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    city            VARCHAR(50),
    signup_date     DATE NOT NULL
);

CREATE TABLE products (
    product_id      INT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(150) NOT NULL,
    category_id     INT,
    price           DECIMAL(10,2) NOT NULL,
    stock_qty       INT NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id        INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT,
    order_date      DATETIME NOT NULL,
    status          VARCHAR(20) DEFAULT 'PLACED',   -- PLACED, SHIPPED, DELIVERED, CANCELLED
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT,
    product_id      INT,
    quantity        INT NOT NULL,
    price_at_order  DECIMAL(10,2) NOT NULL,   -- snapshot price at time of order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id      INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT,
    amount          DECIMAL(10,2) NOT NULL,
    method          VARCHAR(20),               -- CARD, UPI, COD
    paid_at         DATETIME,
    status          VARCHAR(20) DEFAULT 'PENDING',  -- PENDING, SUCCESS, FAILED
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE inventory_log (
    log_id          INT PRIMARY KEY AUTO_INCREMENT,
    product_id      INT,
    change_qty      INT NOT NULL,      -- negative = stock reduced, positive = restocked
    reason          VARCHAR(50),       -- 'ORDER', 'RESTOCK', 'RETURN'
    logged_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Helpful indexes (mention these explicitly in your README/interview — shows you think about performance)
CREATE INDEX idx_orderitems_product ON order_items(product_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_products_category ON products(category_id);
