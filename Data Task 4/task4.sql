
-- Task4: SQL for Data Analysis (sample queries)
-- 1. Basic SELECT, WHERE, ORDER BY
SELECT customer_id, first_name, last_name, city FROM customers WHERE city = 'Bengaluru' ORDER BY signup_date DESC LIMIT 10;

-- 2. Aggregate with GROUP BY: total revenue per customer
SELECT o.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.order_id) AS orders_count, SUM(o.total_amount) AS total_revenue
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. JOINs: inner join orders and order_items to get item-level revenue
SELECT oi.order_item_id, oi.order_id, oi.product_id, p.product_name, oi.quantity, oi.unit_price,
       (oi.quantity * oi.unit_price) AS item_revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY item_revenue DESC LIMIT 15;

-- 4. LEFT JOIN: list customers and their most recent order (if any)
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
       o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date = (SELECT MAX(order_date) FROM orders o2 WHERE o2.customer_id = c.customer_id)
ORDER BY c.customer_id LIMIT 15;

-- 5. RIGHT JOIN alternative in SQLite (use LEFT JOIN with reversed tables): products and orders (products may not be ordered)
SELECT p.product_id, p.product_name, oi.order_id, oi.quantity
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
ORDER BY p.product_id LIMIT 15;

-- 6. Subquery: customers who spent above average total revenue
SELECT customer_id, total_revenue FROM (
    SELECT o.customer_id, SUM(o.total_amount) AS total_revenue
    FROM orders o GROUP BY o.customer_id
) WHERE total_revenue > (SELECT AVG(total_revenue) FROM (SELECT SUM(total_amount) AS total_revenue FROM orders GROUP BY customer_id));

-- 7. HAVING vs WHERE: products with average unit price > 5000
SELECT category, COUNT(*) AS num_products, AVG(price) AS avg_price FROM products
GROUP BY category HAVING AVG(price) > 5000;

-- 8. Create view for monthly revenue
CREATE VIEW IF NOT EXISTS monthly_revenue AS
SELECT strftime('%Y-%m', order_date) AS year_month, SUM(total_amount) AS revenue, COUNT(order_id) AS orders_count
FROM orders GROUP BY year_month;

-- 9. Query view
SELECT * FROM monthly_revenue ORDER BY year_month DESC LIMIT 12;

-- 10. Subquery with EXISTS: customers who ordered 'Electronics'
SELECT DISTINCT c.customer_id, c.first_name || ' ' || c.last_name AS name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id = c.customer_id AND p.category = 'Electronics'
);

-- 11. Window function (SQLite 3.25+ supports window functions): cumulative revenue per month
SELECT year_month, revenue, SUM(revenue) OVER (ORDER BY year_month) AS cumulative_revenue
FROM monthly_revenue ORDER BY year_month;

-- 12. Example optimization: create index (already created in DB creation section)
-- 13. View for customer lifetime value (CLV)
CREATE VIEW IF NOT EXISTS customer_lifetime AS
SELECT o.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.order_id) AS orders_count, SUM(o.total_amount) AS lifetime_value
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id;

SELECT * FROM customer_lifetime ORDER BY lifetime_value DESC LIMIT 10;

-- 14. Use of subquery in SELECT: top product per customer (most expensive item they bought)
SELECT o.customer_id,
       (SELECT p.product_name FROM order_items oi JOIN products p ON oi.product_id=p.product_id WHERE oi.order_id=o.order_id ORDER BY oi.unit_price DESC LIMIT 1) AS top_item
FROM orders o LIMIT 15;

-- 15. Cleaning / null handling sample: find orders with null total_amount (none expected)
SELECT * FROM orders WHERE total_amount IS NULL LIMIT 10;
