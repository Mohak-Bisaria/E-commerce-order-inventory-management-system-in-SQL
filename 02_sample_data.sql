-- ============================================
-- Sample Data
-- ============================================

INSERT INTO categories (name, parent_id) VALUES
('Electronics', NULL),
('Mobiles', 1),
('Smartphones', 2),
('Laptops', 1),
('Fashion', NULL),
('Men''s Clothing', 5);

INSERT INTO customers (name, email, city, signup_date) VALUES
('Rohan Mehta', 'rohan.m@example.com', 'Mumbai', '2024-01-10'),
('Ayesha Khan', 'ayesha.k@example.com', 'Delhi', '2024-02-15'),
('Vikram Singh', 'vikram.s@example.com', 'Bangalore', '2024-03-05'),
('Priya Nair', 'priya.n@example.com', 'Chennai', '2024-04-20'),
('Sameer Iqbal', 'sameer.i@example.com', 'Goa', '2024-05-01');

INSERT INTO products (name, category_id, price, stock_qty) VALUES
('iPhone 15', 3, 79999.00, 20),
('Samsung Galaxy S24', 3, 69999.00, 15),
('MacBook Air M2', 4, 114999.00, 10),
('Dell XPS 13', 4, 99999.00, 8),
('Men''s Cotton T-Shirt', 6, 799.00, 100),
('Men''s Denim Jacket', 6, 2499.00, 40);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-06-01 10:15:00', 'DELIVERED'),
(2, '2024-06-03 14:20:00', 'DELIVERED'),
(3, '2024-06-10 09:00:00', 'SHIPPED'),
(1, '2024-06-15 18:30:00', 'CANCELLED'),
(4, '2024-06-20 11:45:00', 'PLACED'),
(5, '2024-07-01 16:00:00', 'DELIVERED');

INSERT INTO order_items (order_id, product_id, quantity, price_at_order) VALUES
(1, 1, 1, 79999.00),
(1, 5, 2, 799.00),
(2, 2, 1, 69999.00),
(3, 3, 1, 114999.00),
(4, 6, 1, 2499.00),
(5, 4, 1, 99999.00),
(6, 5, 3, 799.00),
(6, 6, 1, 2499.00);

INSERT INTO payments (order_id, amount, method, paid_at, status) VALUES
(1, 81597.00, 'CARD', '2024-06-01 10:16:00', 'SUCCESS'),
(2, 69999.00, 'UPI', '2024-06-03 14:21:00', 'SUCCESS'),
(3, 114999.00, 'CARD', '2024-06-10 09:01:00', 'SUCCESS'),
(4, 2499.00, 'UPI', '2024-06-15 18:31:00', 'FAILED'),
(5, 99999.00, 'COD', NULL, 'PENDING'),
(6, 4896.00, 'CARD', '2024-07-01 16:01:00', 'SUCCESS');

INSERT INTO inventory_log (product_id, change_qty, reason) VALUES
(1, -1, 'ORDER'),
(5, -2, 'ORDER'),
(2, -1, 'ORDER'),
(3, -1, 'ORDER'),
(4, -1, 'ORDER'),
(5, -3, 'ORDER'),
(6, -1, 'ORDER'),
(1, 10, 'RESTOCK');
