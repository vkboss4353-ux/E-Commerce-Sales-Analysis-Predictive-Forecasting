# E-Commerce Sales Analysis & Predictive Forecasting

## Project Overview

This project focuses on analyzing e-commerce sales data using PostgreSQL and Power BI to understand sales performance, customer purchasing behavior, product category performance, seller performance, payment methods, and delivery efficiency.

The project uses the Brazilian Olist E-Commerce dataset to build a structured data warehouse, perform SQL-based data transformations, and create interactive dashboards for business intelligence and decision-making.

The project also provides a foundation for predictive sales forecasting using historical sales trends.

## Objectives

- Build a structured e-commerce data warehouse using PostgreSQL.
- Perform data cleaning, transformation, validation, and integration using SQL.
- Analyze sales trends, order volumes, and product category performance.
- Evaluate seller performance and customer geographical distribution.
- Analyze payment methods, customer reviews, and delivery performance.
- Develop Power BI dashboards for interactive business reporting.
- Explore historical sales patterns as a foundation for predictive forecasting.

## Tech Stack

- **Database:** PostgreSQL
- **Query Language:** SQL
- **Business Intelligence:** Microsoft Power BI
- **Data Modeling:** Star Schema
- **Analytics Techniques:** CTEs, joins, aggregations, window functions, and data validation
- **Dataset:** Brazilian Olist E-Commerce Public Dataset

## Dataset

The Olist dataset contains information about Brazilian e-commerce orders, customers, products, sellers, payments, reviews, and geographical locations.

The project works with nine related source datasets:

1. Customers
2. Products
3. Sellers
4. Orders
5. Order Items
6. Order Payments
7. Order Reviews
8. Geolocation
9. Product Category Translation

These datasets are integrated to support sales analysis and business reporting.

## Data Warehouse Architecture

The project follows a structured ETL workflow:

1. **Data Ingestion:** Load the source datasets into PostgreSQL staging tables.
2. **Data Cleaning:** Standardize text fields, check missing values, and validate records.
3. **Data Transformation:** Use SQL joins and transformations to integrate related datasets.
4. **Dimensional Modeling:** Create dimension and fact tables using a star-schema approach.
5. **Data Validation:** Check row counts, duplicate records, missing dimension keys, and sales calculations.
6. **Business Analytics:** Write SQL queries to analyze sales, products, customers, payments, reviews, and delivery performance.
7. **Visualization:** Use Power BI to present business metrics and trends through interactive dashboards.

## Database Schema

### Dimension Tables

- `dim_customer` — Customer identifiers and geographical information.
- `dim_product` — Product details, categories, and dimensions.
- `dim_seller` — Seller identifiers and geographical information.
- `dim_date` — Calendar attributes for time-based analysis.

### Fact Tables

- `fact_sales` — Order items, prices, freight values, quantities, and sales amounts.
- `fact_payments` — Payment methods, installments, and payment values.
- `fact_reviews` — Customer review scores and review timestamps.

### Staging Tables

The `stg_` tables hold the source data before transformation into the analytical warehouse.

## SQL Analysis and Business Questions

The project uses SQL to answer important business questions:

1. What are the total sales, order count, items sold, and freight value?
2. How do sales and order volumes change month by month?
3. Which product categories generate the highest sales?
4. Which products contribute most to revenue?
5. Which sellers and geographical regions perform best?
6. Which payment methods are most commonly used?
7. How are customer review scores distributed?
8. What is the average order-to-delivery time?
9. Which customer states generate the highest sales?
10. What percentage of overall sales comes from each product category?
11. How does sales performance change compared with the previous month?

SQL techniques include joins, aggregate functions, Common Table Expressions (CTEs), `CASE` expressions, date functions, and window functions such as `LAG()`.

## Power BI Dashboards

Power BI is used to convert the transformed data into interactive business reports.

The dashboards focus on:

- Sales performance and key business metrics
- Monthly sales trends and growth
- Product and category performance
- Seller and geographical analysis
- Payment behavior and customer reviews
- Delivery performance and operational insights

## Predictive Forecasting

Historical sales analysis helps identify patterns and changes in business performance. These insights can be used as a foundation for forecasting future sales.

A complete forecasting extension would involve preparing a time-series dataset, selecting an appropriate forecasting model, generating future sales predictions, and evaluating prediction errors using suitable metrics.

**Note:** Historical trend analysis and month-over-month growth are descriptive analytics, not predictive forecasting by themselves. A forecasting model and its evaluation should be added before presenting forecasting as an implemented feature.

## Key Learnings

- Designing relational databases and dimensional data models.
- Building SQL-based ETL workflows.
- Integrating multiple related datasets using joins.
- Applying data-quality checks and validating warehouse records.
- Performing business analysis using aggregations and window functions.
- Translating analytical results into business intelligence dashboards.
- Understanding how historical sales analysis supports forecasting.

## Repository Structure

```text
E-Commerce-Sales-Analysis-Predictive-Forecasting/
│
├── sql/
│   └── ecommerce_sales_analysis.sql
│
├── screenshots/
│   ├── dashboard_1.png
│   ├── dashboard_2.png
│   └── dashboard_3.png
│
└── README.md
```

The folder structure can be updated as additional scripts, dashboard screenshots, and forecasting components are added.

## Conclusion

This project demonstrates an end-to-end analytical workflow using PostgreSQL and Power BI, from staging and data transformation to dimensional modeling, SQL analytics, and business reporting. It provides a foundation for data-driven decision-making and future predictive sales forecasting.

## Author

Ram Vishal Manoj

GitHub: [vkboss4353-ux](https://github.com/vkboss4353-ux)

