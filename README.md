# sales-intelligence-system

End-to-End SQL Analytics Project for Revenue Optimization &amp; Customer Segmentation

## 📌 Project Overview

This project simulates a **real-world sales analytics system** designed to help businesses understand revenue performance, customer behavior, product profitability, and operational risks.

Instead of just analyzing data, this project focuses on building a **scalable analytics pipeline** that transforms raw transactional data into **actionable business insights**.

## 🎯 Business Problem

Organizations often face challenges such as:

* Revenue growth without clear visibility into profitability
* High return rates impacting margins
* Lack of understanding of high-value customers
* Inefficient product pricing strategies

## 🎯 Objectives

* Analyze **revenue and profit performance**
* Identify **top customers and revenue drivers**
* Segment customers based on **value contribution**
* Evaluate **product-level profitability**
* Measure and assess the **impact of returns**

## ⚙️ Tech Stack

* **SQL** (SQL Server)
* **Excel** (Data Source)

## 🧱 Data Model

The project follows a **star schema design** with a layered architecture:

### ⭐ Fact Table

* `sales_orders`

### 📦 Dimension Tables

* `customers`
* `products`
* `order_returns`

## 🔄 Data Pipeline Architecture

```text
Raw Tables → cleaned_table → sales_master → KPI Layer → Analytics Layer
```

### 🔹 1. Raw Layer

Original data imported from Excel:

* Sales Orders
* Customers
* Products
* Returns

### 🔹 2. Clean Layer (`cleaned_tables`)

* Altering data types
* Validating data logic
* Checking NULLs
* Handling missing values

### 🔹 3. Master Layer (`sales_master`)

* Combines all tables using joins
* Acts as a **single source of truth**

### 🔹 4. Enriched Layer (`sales_view`)

Derived features created:

* Revenue & Profit calculations
* Date features (Year, Month, Quarter)
* Delivery time
* Customer Age & Age Group
* Return Flag

### 🔹 5. KPI Layer

Predefined views for:

* Core metrics
* Advanced KPIs

### 🔹 6. Analytics Layer

Business-focused analysis:

* Sales trends
* Customer insights
* Product performance
* Return impact

## 📊 Key Metrics (KPIs)

### 🔹 Core KPIs

* Total Orders
* Total Revenue
* Total Profit
* Total Customers
* Total Products Sold

### 🔹 Advanced KPIs

* Average Order Value (AOV)
* Return Rate (%)
* Profit Margin (%)
* Repeat Customer Rate

## 📈 Analysis Performed

### 🔹 Sales Analysis

* Monthly revenue trends
* Top-performing orders
* Revenue by category and region

### 🔹 Customer Analysis

* Top customers by revenue
* Repeat vs new customers
* Customer segmentation (Premium / Advanced / Casual)

### 🔹 Product Analysis

* Top-selling products
* Most profitable products
* Low-margin product identification

### 🔹 Return Analysis

* Return rate by category
* Revenue loss due to returns
* Profit impact of returned orders

## 🧠 Advanced Analytics

### 🔥 Customer Segmentation (Pareto Analysis)

* Top 20% customers identified as **Premium**
* Revenue contribution analyzed using cumulative %

### 🔥 Cohort Analysis

* Customer acquisition trends over time
* Helps understand retention patterns

### 🔥 Revenue Loss Analysis

* Quantifies revenue impact due to returns

## 🧠 Key Insights

* A small percentage of customers contribute a **major share of total revenue**
* Certain high-selling products generate **low profit margins**, indicating pricing inefficiencies
* Returned orders significantly impact profitability due to **sunk costs**
* Repeat customers form a crucial segment for **stable revenue generation**
* Specific customer age groups show higher spending patterns

<!-- ## 📊 Dashboard (Optional)

A dashboard can be built using Excel including:

* KPI summary cards
* Monthly revenue trends
* Customer segmentation visuals
* Product performance charts
* Return impact analysis -->

## 🚀 Business Impact

* Identified high-value customers driving the majority of revenue
* Highlighted products with poor profit margins for pricing optimization
* Quantified the financial impact of returns
* Enabled data-driven decision-making for customer targeting and retention

## 📁 Project Structure

```text
sales-intelligence-system/
│
├── data/
│   └── raw_dataset.xlsx
│
├── sql/
│   ├── 01_tables.sql
│   ├── 02_sales_master_view.sql
│   ├── 03_sales_enriched_view.sql
│   ├── 04_kpi_views.sql
│   ├── 05_analytics_views.sql
│   └── 06_advanced_analysis.sql
│
├── dashboard/
│   └── dashboard.png
│
└── README.md
```

<!-- ## 🧩 Future Improvements

* Automate data pipeline using scheduled jobs
* Implement incremental data loading
* Add forecasting models for revenue prediction
* Integrate real-time dashboards -->

## 💡 Key Learnings

* Designing scalable SQL data models
* Building layered data pipelines
* Translating business problems into analytical solutions
* Generating actionable insights from raw data
