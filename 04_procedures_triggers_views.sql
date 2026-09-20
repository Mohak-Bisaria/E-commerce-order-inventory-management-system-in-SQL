-- ============================================
-- Stored Procedure + Trigger
-- (MySQL syntax — DELIMITER needed for multi-statement bodies)
-- ============================================

DELIMITER //

-- Stored Procedure: place an order and its items in one transactional call.
-- Usage: CALL place_order(1, 1, 2); -- customer_id=1 orders product_id=1, qty=2
CREATE PROCEDURE place_order (
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id INT;

    SELECT price, stock_qty INTO v_price, v_stock
    FROM products WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock for this order';
    ELSE
        START TRANSACTION;

        INSERT INTO orders (customer_id, order_date, status)
        VALUES (p_customer_id, NOW(), 'PLACED');

        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO order_items (order_id, product_id, quantity, price_at_order)
        VALUES (v_order_id, p_product_id, p_quantity, v_price);

        -- stock_qty update happens automatically via trigger below

        COMMIT;
    END IF;
END //

-- Trigger: whenever a new order_item is inserted, auto-deduct stock
-- and log the change in inventory_log
CREATE TRIGGER trg_after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_qty = stock_qty - NEW.quantity
    WHERE product_id = NEW.product_id;

    INSERT INTO inventory_log (product_id, change_qty, reason)
    VALUES (NEW.product_id, -NEW.quantity, 'ORDER');
END //

DELIMITER ;

-- View: quick sales dashboard (per product) — application layer can just SELECT * FROM this
CREATE VIEW sales_dashboard AS
SELECT p.name AS product,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.price_at_order) AS revenue,
       p.stock_qty AS current_stock
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY p.name, p.stock_qty;
