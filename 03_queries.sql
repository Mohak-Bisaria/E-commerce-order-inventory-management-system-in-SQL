-- ============================================
-- Showcase Queries
-- ============================================

-- 1. All orders with customer name, total item count, and order status
SELECT o.order_id, c.name AS customer, o.status,
       SUM(oi.quantity) AS total_items
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.name, o.status;

-- 2. Revenue per product (JOIN + aggregate), highest first
SELECT p.name, SUM(oi.quantity * oi.price_at_order) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY p.name
ORDER BY revenue DESC;

-- 3. Top spending customer (subquery + aggregate)
SELECT c.name, total_spent FROM customers c
JOIN (
    SELECT o.customer_id, SUM(oi.quantity * oi.price_at_order) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'CANCELLED'
    GROUP BY o.customer_id
) spend ON c.customer_id = spend.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- 4. Recursive CTE: full category hierarchy (Electronics > Mobiles > Smartphones)
WITH RECURSIVE category_tree AS (
    SELECT category_id, name, parent_id, 0 AS depth,
           CAST(name AS CHAR(200)) AS path
    FROM categories
    WHERE parent_id IS NULL
    UNION ALL
    SELECT c.category_id, c.name, c.parent_id, ct.depth + 1,
           CONCAT(ct.path, ' > ', c.name)
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.category_id
)
SELECT * FROM category_tree ORDER BY path;

-- 5. Products low on stock (below a threshold) — useful for a restock alert feature
SELECT name, stock_qty FROM products
WHERE stock_qty < 15
ORDER BY stock_qty ASC;

-- 6. Rank customers by total orders placed (WINDOW FUNCTION)
SELECT c.name,
       COUNT(o.order_id) AS orders_placed,
       DENSE_RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rank_by_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- 7. Running total of revenue by order date (WINDOW FUNCTION — cumulative sum)
SELECT o.order_date,
       SUM(oi.quantity * oi.price_at_order) AS order_value,
       SUM(SUM(oi.quantity * oi.price_at_order)) OVER (ORDER BY o.order_date) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY o.order_date
ORDER BY o.order_date;

-- 8. Failed / pending payments needing follow-up
SELECT o.order_id, c.name, p.amount, p.status
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.status IN ('PENDING', 'FAILED');

-- 9. Customers who never placed an order (LEFT JOIN + IS NULL)
SELECT c.name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 10. Check query plan on a filtered join (shows you think about performance)
EXPLAIN
SELECT c.name, o.order_id
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'DELIVERED';
