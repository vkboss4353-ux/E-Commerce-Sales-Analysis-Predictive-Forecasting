CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    customer_unique_id VARCHAR(50),
    customer_zip_code INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL,
    category_name VARCHAR(100),
    category_name_english VARCHAR(100),
    product_weight_g INT,
    product_length_cm NUMERIC(10,2),
    product_height_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2),
    product_photos_qty INT
);

CREATE TABLE dim_seller (
    seller_key SERIAL PRIMARY KEY,
    seller_id VARCHAR(50) NOT NULL,
    seller_zip_code INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    weekday INT,
    weekday_name VARCHAR(20)
);
CREATE TABLE fact_sales (
    sales_key SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,

    customer_key INT,
    product_key INT,
    seller_key INT,
    date_key INT,

    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),
    quantity INT,
    sales_amount NUMERIC(12,2),

    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),

    FOREIGN KEY (product_key)
        REFERENCES dim_product(product_key),

    FOREIGN KEY (seller_key)
        REFERENCES dim_seller(seller_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)
);
CREATE TABLE fact_payments (
    payment_key SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(12,2)
);
CREATE TABLE fact_reviews (
    review_key SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    review_id VARCHAR(50) NOT NULL,
    review_score INT,
    review_creation_date DATE,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE stg_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE stg_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm NUMERIC(10,2),
    product_height_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2)
);

CREATE TABLE stg_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE stg_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE stg_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12,2),
    freight_value NUMERIC(12,2)
);
CREATE TABLE stg_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value NUMERIC(12,2)
);

CREATE TABLE stg_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE stg_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC(10,6),
    geolocation_lng NUMERIC(10,6),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

CREATE TABLE stg_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
SELECT COUNT(*) 
FROM stg_customers;

SELECT COUNT(*)
FROM stg_products;

SELECT COUNT(*)
FROM stg_sellers;

SELECT COUNT(*)
FROM stg_orders;

SELECT COUNT(*)
FROM stg_order_items;

SELECT COUNT(*)
FROM stg_order_payments;

SELECT COUNT(*)
FROM stg_order_reviews;

SELECT COUNT(*)
FROM stg_geolocation;

SELECT COUNT(*)
FROM stg_category_translation;

INSERT INTO dim_customer (
    customer_id,
    customer_unique_id,
    customer_zip_code,
    customer_city,
    customer_state
)
SELECT
    TRIM(customer_id),
    TRIM(customer_unique_id),
    customer_zip_code_prefix,
    TRIM(customer_city),
    UPPER(TRIM(customer_state))
FROM stg_customers
WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> '';

 SELECT COUNT(*)
FROM dim_customer;


INSERT INTO dim_product (
    product_id,
    category_name,
    category_name_english,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_photos_qty
)
SELECT
    TRIM(p.product_id),
    TRIM(p.product_category_name),
    TRIM(t.product_category_name_english),
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_photos_qty
FROM stg_products p
LEFT JOIN stg_category_translation t
    ON TRIM(p.product_category_name) =
       TRIM(t.product_category_name)
WHERE p.product_id IS NOT NULL
  AND TRIM(p.product_id) <> '';

  SELECT COUNT(*)
FROM dim_product;

INSERT INTO dim_seller (
    seller_id,
    seller_zip_code,
    seller_city,
    seller_state
)
SELECT
    TRIM(seller_id),
    seller_zip_code_prefix,
    TRIM(seller_city),
    UPPER(TRIM(seller_state))
FROM stg_sellers
WHERE seller_id IS NOT NULL
  AND TRIM(seller_id) <> '';

  SELECT COUNT(*)
FROM dim_seller;

INSERT INTO dim_date (
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    weekday,
    weekday_name
)
SELECT DISTINCT
    DATE(order_purchase_timestamp) AS full_date,
    EXTRACT(DAY FROM order_purchase_timestamp)::INT AS day,
    EXTRACT(MONTH FROM order_purchase_timestamp)::INT AS month,
    TO_CHAR(order_purchase_timestamp, 'Month') AS month_name,
    EXTRACT(QUARTER FROM order_purchase_timestamp)::INT AS quarter,
    EXTRACT(YEAR FROM order_purchase_timestamp)::INT AS year,
    EXTRACT(ISODOW FROM order_purchase_timestamp)::INT AS weekday,
    TO_CHAR(order_purchase_timestamp, 'Day') AS weekday_name
FROM stg_orders
WHERE order_purchase_timestamp IS NOT NULL;


SELECT COUNT(*)
FROM dim_date;

INSERT INTO fact_sales (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    seller_key,
    date_key,
    price,
    freight_value,
    quantity,
    sales_amount
)
SELECT
    oi.order_id,
    oi.order_item_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    d.date_key,
    oi.price,
    oi.freight_value,
    1 AS quantity,
    oi.price * 1 AS sales_amount
FROM stg_order_items oi
JOIN stg_orders o
    ON oi.order_id = o.order_id
JOIN dim_customer c
    ON o.customer_id = c.customer_id
JOIN dim_product p
    ON oi.product_id = p.product_id
JOIN dim_seller s
    ON oi.seller_id = s.seller_id
JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.full_date
WHERE o.order_purchase_timestamp IS NOT NULL;

SELECT COUNT(*)
FROM stg_order_items;

SELECT COUNT(*)
FROM stg_orders;

SELECT COUNT(*)
FROM stg_order_items oi
JOIN stg_orders o
    ON oi.order_id = o.order_id;

	SELECT
    COUNT(*) AS total_items,
    COUNT(c.customer_key) AS customer_matches,
    COUNT(p.product_key) AS product_matches,
    COUNT(s.seller_key) AS seller_matches,
    COUNT(d.date_key) AS date_matches
FROM stg_order_items oi
JOIN stg_orders o
    ON oi.order_id = o.order_id
LEFT JOIN dim_customer c
    ON o.customer_id = c.customer_id
LEFT JOIN dim_product p
    ON oi.product_id = p.product_id
LEFT JOIN dim_seller s
    ON oi.seller_id = s.seller_id
LEFT JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.full_date;

SELECT
    oi.seller_id AS staging_seller_id,
    s.seller_id AS dimension_seller_id
FROM stg_order_items oi
LEFT JOIN dim_seller s
    ON TRIM(oi.seller_id) = TRIM(s.seller_id)
WHERE s.seller_id IS NULL
LIMIT 10;

SELECT COUNT(*) AS seller_count
FROM dim_seller;

INSERT INTO dim_seller (
    seller_id,
    seller_zip_code,
    seller_city,
    seller_state
)
SELECT
    TRIM(seller_id),
    seller_zip_code_prefix,
    TRIM(seller_city),
    UPPER(TRIM(seller_state))
FROM stg_sellers
WHERE seller_id IS NOT NULL
  AND TRIM(seller_id) <> '';



  INSERT INTO fact_sales (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    seller_key,
    date_key,
    price,
    freight_value,
    quantity,
    sales_amount
)
SELECT
    oi.order_id,
    oi.order_item_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    d.date_key,
    oi.price,
    oi.freight_value,
    1 AS quantity,
    oi.price * 1 AS sales_amount
FROM stg_order_items oi
JOIN stg_orders o
    ON oi.order_id = o.order_id
JOIN dim_customer c
    ON o.customer_id = c.customer_id
JOIN dim_product p
    ON oi.product_id = p.product_id
JOIN dim_seller s
    ON oi.seller_id = s.seller_id
JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.full_date
WHERE o.order_purchase_timestamp IS NOT NULL;

SELECT *
FROM fact_sales
LIMIT 10;

INSERT INTO fact_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    TRIM(order_id),
    payment_sequential,
    TRIM(payment_type),
    payment_installments,
    payment_value
FROM stg_order_payments
WHERE order_id IS NOT NULL
  AND TRIM(order_id) <> '';


INSERT INTO fact_reviews (
    order_id,
    review_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    TRIM(order_id),
    TRIM(review_id),
    review_score,
    DATE(review_creation_date),
    review_answer_timestamp
FROM stg_order_reviews
WHERE order_id IS NOT NULL
  AND TRIM(order_id) <> ''
  AND review_id IS NOT NULL
  AND TRIM(review_id) <> '';

  SELECT
    'dim_customer' AS table_name, COUNT(*) AS row_count
FROM dim_customer

UNION ALL

SELECT
    'dim_product', COUNT(*)
FROM dim_product

UNION ALL

SELECT
    'dim_seller', COUNT(*)
FROM dim_seller

UNION ALL

SELECT
    'dim_date', COUNT(*)
FROM dim_date

UNION ALL

SELECT
    'fact_sales', COUNT(*)
FROM fact_sales

UNION ALL

SELECT
    'fact_payments', COUNT(*)
FROM fact_payments

UNION ALL

SELECT
    'fact_reviews', COUNT(*)
FROM fact_reviews;

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM dim_seller
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM fact_sales
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS missing_customer_keys
FROM fact_sales
WHERE customer_key IS NULL;

SELECT
    COUNT(*) FILTER (WHERE product_key IS NULL) AS missing_product_keys,
    COUNT(*) FILTER (WHERE seller_key IS NULL) AS missing_seller_keys,
    COUNT(*) FILTER (WHERE date_key IS NULL) AS missing_date_keys
FROM fact_sales;

SELECT COUNT(*) AS inconsistent_sales
FROM fact_sales
WHERE sales_amount <> price * quantity;

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_items,
    SUM(sales_amount) AS total_sales,
    SUM(freight_value) AS total_freight
FROM fact_sales;

SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;



	SELECT
    p.category_name_english AS category,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.category_name_english
ORDER BY
    total_sales DESC;

	SELECT
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.freight_value) AS total_freight
FROM fact_sales f
JOIN dim_seller s
    ON f.seller_key = s.seller_key
GROUP BY
    s.seller_city,
    s.seller_state
ORDER BY
    total_sales DESC;

	SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;

	SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS total_payment,
    AVG(payment_value) AS average_payment
FROM fact_payments
GROUP BY
    payment_type
ORDER BY
    total_payment DESC;

	SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS average_score
FROM fact_reviews
GROUP BY
    review_score
ORDER BY
    review_score;


SELECT
    ROUND(
        AVG(
            EXTRACT(
                DAY FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            )
        ),
        2
    ) AS avg_delivery_days
FROM stg_orders o
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL;


 SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(
        AVG(
            EXTRACT(
                DAY FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            )
        )::NUMERIC,
        2
    ) AS avg_delivery_days,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM stg_orders o
JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.full_date
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;

	SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(
        AVG(
            EXTRACT(
                DAY FROM (
                    o.order_delivered_customer_date
                    - o.order_purchase_timestamp
                )
            )
        )::NUMERIC,
        2
    ) AS avg_delivery_days,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM stg_orders o
JOIN dim_date d
    ON DATE(o.order_purchase_timestamp) = d.full_date
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    d.year,
    d.month,
    d.month_name
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY
    d.year,
    d.month;

	SELECT
    c.customer_state,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.sales_amount) AS total_sales,
    ROUND(AVG(f.sales_amount), 2) AS avg_item_value
FROM fact_sales f
JOIN dim_customer c
    ON f.customer_key = c.customer_key
GROUP BY
    c.customer_state
ORDER BY
    total_sales DESC;

	SELECT
    p.category_name_english AS category,
    ROUND(SUM(f.sales_amount), 2) AS total_sales,
    ROUND(
        SUM(f.sales_amount) * 100.0 /
        SUM(SUM(f.sales_amount)) OVER (),
        2
    ) AS sales_percentage
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.category_name_english
ORDER BY
    total_sales DESC;

	SELECT
    p.category_name_english AS category,
    p.product_id,
    SUM(f.quantity) AS units_sold,
    ROUND(SUM(f.sales_amount), 2) AS total_sales
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.category_name_english,
    p.product_id
ORDER BY
    total_sales DESC
LIMIT 10;

WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    JOIN dim_date d
        ON f.date_key = d.date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
)

SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(SUM(f.sales_amount), 2) AS total_sales,

    ROUND(
        LAG(SUM(f.sales_amount)) OVER (
            ORDER BY d.year, d.month
        ),
        2
    ) AS previous_month_sales,

    ROUND(
        (
            SUM(f.sales_amount)
            - LAG(SUM(f.sales_amount)) OVER (
                ORDER BY d.year, d.month
            )
        )
        * 100.0
        / NULLIF(
            LAG(SUM(f.sales_amount)) OVER (
                ORDER BY d.year, d.month
            ),
            0
        ),
        2
    ) AS mom_growth_percentage

FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month,
    d.month_name

ORDER BY
    d.year,
    d.month;

	-- ============================================================
-- ENTERPRISE SALES DATA WAREHOUSE - SQL ANALYTICS
-- ========================================================

-- 1. Core KPIs
-- Calculated total orders, total items sold, total sales,
-- and total freight value to measure overall business performance.

-- 2. Monthly Sales Analysis
-- Calculated monthly sales and order volume to identify
-- sales trends and changes in business activity over time.

-- 3. Category-wise Sales Analysis
-- Calculated total sales and total orders for each product
-- category to identify the highest-performing categories.

-- 4. Seller Performance Analysis
-- Calculated total orders, sales, and freight value by
-- seller location to compare seller-level performance.

-- 5. Payment Analysis
-- Analyzed payment methods using total orders, total payment
-- value, and average payment value to understand customer
-- payment behavior.

-- 6. Review Analysis
-- Analyzed customer review scores and review distribution
-- to evaluate customer satisfaction.

-- 7. Delivery Performance Analysis
-- Calculated average delivery time in days to evaluate
-- operational and delivery performance.

-- 8. State-wise Sales Analysis
-- Calculated total orders, total sales, and average item
-- value by customer state to identify high-performing markets.

-- 9. Top 10 Products Analysis
-- Identified the top 10 products based on total sales
-- and units sold.

-- 10. Category Sales Contribution
-- Calculated each product category's percentage contribution
-- to overall sales using SQL window functions.

-- 11. Month-over-Month (MoM) Sales Growth
-- Calculated previous-month sales and MoM growth percentage
-- using the LAG() window function to identify sales growth
-- and decline trends.
