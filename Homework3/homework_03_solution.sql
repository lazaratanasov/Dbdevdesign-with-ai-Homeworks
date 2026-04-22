-- PART 1 — RELATIONSHIPS AND KEYS

-- HOW THE TABLES CONNECT

-- 1. customer → customer_profile   (customer.id = customer_profile.customer_id)
--    ONE-TO-ONE: each customer has exactly one profile row.

-- 2. customer → address            (customer.id = address.customer_id)
--    ONE-TO-MANY: one customer can have several saved addresses (e.g. Ana has two).

-- 3. customer → shop_order         (customer.id = shop_order.customer_id)
--    ONE-TO-MANY: one customer can place many orders.

-- 4. category → product            (category.id = product.category_id)
--    ONE-TO-MANY: one category groups many products.

-- 5. product ↔ tag via product_tag (product_tag.product_id / product_tag.tag_id)
--    MANY-TO-MANY: one product can carry many tags; one tag can apply to many products.
--    product_tag is the junction/bridge table.

-- 6. shop_order → order_line       (shop_order.id = order_line.order_id)
--    ONE-TO-MANY: one order contains one or more order lines.

-- 7. product → order_line          (product.id = order_line.product_id)
--    ONE-TO-MANY: the same product can appear on many different order lines.

-- 8. shop_order → order_shipment   (shop_order.id = order_shipment.order_id)
--    ONE-TO-ONE: each shipped order gets exactly one shipment record.

-- 9. address → shop_order          (address.id = shop_order.shipping_address_id)
--    ONE-TO-MANY: the same address can be used as shipping address on several orders.


-- WHERE PRIMARY KEYS AND FOREIGN KEYS BELONG:

-- PRIMARY KEYS:
--   customer(id)           — identifies a unique shopper
--   customer_profile(id)   — also customer_id must be UNIQUE (one profile per customer)
--   category(id)           — identifies a unique category
--   product(id)            — identifies a unique product; sku should also be UNIQUE
--   tag(id)                — identifies a unique tag; name should also be UNIQUE
--   product_tag(product_id, tag_id) — composite PK, prevents duplicate tag assignments
--   address(id)            — identifies a unique saved address
--   shop_order(id)         — identifies a unique order; order_number should be UNIQUE
--   order_line(id)         — identifies a unique line item
--   order_shipment(id)     — identifies a unique shipment record

-- FOREIGN KEYS:
--   customer_profile.customer_id  → customer.id
--   product.category_id           → category.id
--   product_tag.product_id        → product.id
--   product_tag.tag_id            → tag.id
--   address.customer_id           → customer.id
--   shop_order.customer_id        → customer.id
--   shop_order.shipping_address_id → address.id
--   order_line.order_id           → shop_order.id
--   order_line.product_id         → product.id
--   order_shipment.order_id       → shop_order.id

-- PART 2 — QUERIES

-- A. Warm-up

SELECT p.name, c.name AS category
FROM product p
JOIN category c ON c.id = p.category_id;

SELECT c.email, cp.loyalty_tier
FROM customer c
JOIN customer_profile cp ON cp.customer_id = c.id;

SELECT o.order_number, c.full_name
FROM shop_order o
JOIN customer c ON c.id = o.customer_id;

SELECT o.order_number, p.name, ol.quantity
FROM order_line ol
JOIN shop_order o ON o.id = ol.order_id
JOIN product p ON p.id = ol.product_id;

SELECT t.name
FROM tag t
JOIN product_tag pt ON pt.tag_id = t.id
JOIN product p ON p.id = pt.product_id
WHERE p.name = 'Wireless earbuds';

-- B. Filters

SELECT o.order_number, o.placed_at, c.email
FROM shop_order o
JOIN customer c ON c.id = o.customer_id
WHERE o.status = 'delivered';

SELECT p.sku, p.unit_price
FROM product p
JOIN category c ON c.id = p.category_id
WHERE p.is_active = TRUE AND c.name = 'Books';

SELECT c.email, cp.loyalty_tier
FROM customer c
JOIN customer_profile cp ON cp.customer_id = c.id
WHERE cp.newsletter_opt_in = TRUE;

SELECT o.order_number, p.name, ol.line_total
FROM order_line ol
JOIN shop_order o ON o.id = ol.order_id
JOIN product p ON p.id = ol.product_id
WHERE ol.line_total > 50;

SELECT c.full_name, a.line1, a.is_default
FROM address a
JOIN customer c ON c.id = a.customer_id
WHERE a.city = 'Skopje';

-- C. Counts and grouping

SELECT c.full_name, COUNT(a.id) AS address_count
FROM customer c
LEFT JOIN address a ON a.customer_id = c.id
GROUP BY c.id, c.full_name;

SELECT c.full_name, COUNT(o.id) AS order_count
FROM customer c
LEFT JOIN shop_order o ON o.customer_id = c.id
GROUP BY c.id, c.full_name;

SELECT o.order_number, COUNT(ol.id) AS line_count
FROM shop_order o
JOIN order_line ol ON ol.order_id = o.id
GROUP BY o.id, o.order_number;

SELECT c.name, COUNT(p.id) AS product_count
FROM category c
JOIN product p ON p.category_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(p.id) >= 2;

SELECT c.email
FROM customer c
JOIN address a ON a.customer_id = c.id
GROUP BY c.id, c.email
HAVING COUNT(a.id) > 1;

-- D. Products and tags

SELECT p.name
FROM product p
JOIN product_tag pt ON pt.product_id = p.id
JOIN tag t ON t.id = pt.tag_id
WHERE t.name = 'bestseller';

SELECT t.name, COUNT(pt.product_id) AS product_count
FROM tag t
JOIN product_tag pt ON pt.tag_id = t.id
GROUP BY t.id, t.name;

SELECT p.name
FROM product p
LEFT JOIN product_tag pt ON pt.product_id = p.id
WHERE pt.product_id IS NULL;

SELECT p.name AS product_name, t.name AS tag_name
FROM product_tag pt
JOIN product p ON p.id = pt.product_id
JOIN tag t ON t.id = pt.tag_id;

SELECT t.name
FROM tag t
LEFT JOIN product_tag pt ON pt.tag_id = t.id
WHERE pt.tag_id IS NULL;

-- E. Money and aggregates

SELECT o.order_number, SUM(ol.line_total) AS order_total
FROM shop_order o
JOIN order_line ol ON ol.order_id = o.id
GROUP BY o.id, o.order_number;

SELECT c.name, ROUND(AVG(p.unit_price), 2) AS avg_price
FROM category c
JOIN product p ON p.category_id = c.id
WHERE p.is_active = TRUE
GROUP BY c.id, c.name;

SELECT o.order_number, p.name, ol.line_total
FROM order_line ol
JOIN shop_order o ON o.id = ol.order_id
JOIN product p ON p.id = ol.product_id
ORDER BY ol.line_total DESC
LIMIT 1;

SELECT c.email, SUM(ol.line_total) AS total_spend
FROM customer c
JOIN shop_order o ON o.customer_id = c.id
JOIN order_line ol ON ol.order_id = o.id
GROUP BY c.id, c.email;

SELECT o.order_number, SUM(ol.line_total) AS order_total
FROM shop_order o
JOIN order_line ol ON ol.order_id = o.id
GROUP BY o.id, o.order_number
HAVING SUM(ol.line_total) > 100;

-- F. Dates and sorting

SELECT order_number, placed_at, status
FROM shop_order
WHERE EXTRACT(YEAR FROM placed_at) = 2025
ORDER BY placed_at DESC;

SELECT o.order_number, c.email
FROM shop_order o
JOIN customer c ON c.id = o.customer_id
ORDER BY o.placed_at ASC
LIMIT 1;

SELECT name, unit_price
FROM product
WHERE is_active = TRUE
  AND unit_price < (SELECT AVG(unit_price) FROM product WHERE is_active = TRUE);

-- G. Missing rows

SELECT c.email
FROM customer c
LEFT JOIN customer_profile cp ON cp.customer_id = c.id
WHERE cp.id IS NULL;

SELECT o.order_number, o.status
FROM shop_order o
LEFT JOIN order_shipment os ON os.order_id = o.id
WHERE os.id IS NULL;

SELECT c.name
FROM category c
LEFT JOIN product p ON p.category_id = c.id
WHERE p.id IS NULL;

-- H. Combined reports

SELECT o.order_number, os.tracking_code, os.carrier
FROM shop_order o
JOIN order_shipment os ON os.order_id = o.id
WHERE o.status = 'delivered';

SELECT o.order_number, c.full_name, a.city
FROM shop_order o
JOIN customer c ON c.id = o.customer_id
JOIN address a ON a.id = o.shipping_address_id;

SELECT DISTINCT c.email
FROM customer c
JOIN customer_profile cp ON cp.customer_id = c.id
JOIN shop_order o ON o.customer_id = c.id
WHERE cp.loyalty_tier = 'gold';

SELECT customer_id, COUNT(*) AS occurrences
FROM customer_profile
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- I. Stretch

SELECT c.name, SUM(ol.line_total) AS category_total
FROM category c
JOIN product p ON p.category_id = c.id
JOIN order_line ol ON ol.product_id = p.id
GROUP BY c.id, c.name;

SELECT c.email, SUM(ol.line_total) AS total_spend
FROM customer c
JOIN shop_order o ON o.customer_id = c.id
JOIN order_line ol ON ol.order_id = o.id
GROUP BY c.id, c.email
ORDER BY total_spend DESC, c.id ASC
LIMIT 1;

SELECT p1.name AS product_a, p2.name AS product_b
FROM order_line ol1
JOIN order_line ol2 ON ol2.order_id = ol1.order_id AND ol2.product_id > ol1.product_id
JOIN product p1 ON p1.id = ol1.product_id
JOIN product p2 ON p2.id = ol2.product_id;

SELECT EXTRACT(MONTH FROM placed_at) AS month, COUNT(*) AS order_count
FROM shop_order
WHERE EXTRACT(YEAR FROM placed_at) = 2024
GROUP BY month
ORDER BY month;

SELECT DISTINCT o.shipping_address_id
FROM shop_order o
LEFT JOIN address a ON a.id = o.shipping_address_id
WHERE a.id IS NULL;