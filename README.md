# E-Commerce Sales Analysis & Predictive Forecasting Dashboard

## Executive Summary
This project delivers an interactive business intelligence solution designed to analyze e-commerce transactional data, model sub-category profitability, and evaluate payment processing friction. Built to align with enterprise diagnostic and data-driven selling frameworks, the project translates raw sales records into executive-level decision metrics to mitigate revenue concentration risks and optimize operational fulfillment.

---

## Core Business Problems Solved

* **Revenue Concentration Risk:** Identifies single-category or single-item reliance (e.g., Electronics or Furniture dominating overall sales, or specific sub-categories like Printers or Tables driving the majority of profit), uncovering portfolio vulnerabilities.
* **Payment Channel Friction:** Evaluates customer checkout behavior, highlighting heavy reliance on **Cash on Delivery (30%–38%)**, which leads to delayed working capital settlement (10–15 days) and high Return-to-Origin (RTO) logistics costs.
* **Margin & Pricing Transparency:** Bridges the gap between high top-line revenue ($79K–$81K) and underlying net profit margins (12.2%–14.8%) to guide dynamic pricing and bundling strategies.

---

## Key Performance Indicators (KPIs)

* **Sum of Amount (Total Revenue):** Aggregates total gross sales across product lines ($79K–$81K).
* **Sum of Profit (Net Profitability):** Tracks total net yield ($9,655–$12K) across filtered categories.
* **Sum of Quantity:** Total units fulfilled across transactions (e.g., 358–553 units).
* **Sum of AOV (Average Order Value):** Measures transaction size (~$21.96K–$22.24K), indicating a B2B or high-ticket retail client profile.
* **Profit Margin (%):** Measures net yield per category (e.g., Furniture operating at a 12.2% margin).

---

## Technical Stack & Architecture

* **Business Intelligence & Visualization:** Power BI / Microsoft Excel (DAX Measures, Data Modeling, Custom Tooltips, Drill-down Filters).
* **Data Processing & ETL:** Power Query / SQL (Data transformation, schema cleaning, missing value handling).
* **Predictive Forecasting:** Time-series analysis utilizing Exponential Smoothing (ETS / Holt-Winters) to model future monthly order volume and revenue.
* **Model Evaluation Metrics:**
  * **$R^2$ (Coefficient of Determination):** Evaluates variance explained by trend models (target range: 0.82–0.90).
  * **MAE (Mean Absolute Error):** Measures average absolute deviation in revenue forecasting.

---

## Key Dashboard Visualizations

* **Monthly Profit Distribution:** Column chart tracking temporal sales stability and monthly performance trajectory (~$35K–$37K/month).
* **Sub-Category Profitability Breakdown:** Horizontal bar charts isolating top profit drivers (e.g., Tables generating $3,139 of $9,655 total Furniture profit).
* **Payment Gateway Mix:** Donut charts illustrating transaction distribution across COD, UPI, Credit Card, EMI, and Debit Card.
* **Category Focus Slicers:** Interactive filters isolating performance metrics by high-level sectors (Electronics vs. Furniture).

---

## Strategic Recommendations

* **Product Bundling:** Pair lower-margin core products (e.g., Tables at 12.2% margin) with high-margin accessories to raise overall basket profitability.
* **Prepaid Payment Incentives:** Introduce small discounts (1%–2%) for UPI and Credit Card orders to convert high COD volumes (30%–38%), reducing RTO shipping costs and unlocking working capital.
* **Supplier Procurement Alignment:** Renegotiate unit costs on dominant sub-categories (Printers, Tables) to protect margins against inflationary or supply-chain pressures.
