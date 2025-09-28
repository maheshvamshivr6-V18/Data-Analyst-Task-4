# Data-Analyst-Task-4
Use SQL queries to extract and analyze data from a database

This repository contains the deliverables for **Task 4: SQL for Data Analysis**.
Files included:
- `ecommerce.db` : SQLite database with synthetic e-commerce data (customers, products, orders, order_items)
- `task4.sql` : SQL file containing queries used for analysis (SELECT, JOINs, GROUP BY, HAVING, subqueries, views, indexes)
- `screenshots/` : PNG images of selected query outputs
- CSV exports of query outputs included in the `task4_output/` folder
- `submission_task4.zip` : Zip file with everything ready for upload

**How the data was generated**
- Medium-sized synthetic dataset:
  - Customers: 350
  - Products: 120
  - Orders: 1200
  - Order items: 2375

**How to run the SQL locally**
1. Download `ecommerce.db`.
2. Use SQLite CLI or a GUI (DB Browser for SQLite) to open the DB.
3. You can also run the provided `task4.sql` queries against the DB (note: some CREATE VIEW statements will not re-run if views already exist).

**Key queries included in `task4.sql`**
- Basic filtering and ordering with `SELECT`, `WHERE`, `ORDER BY`
- Aggregation with `GROUP BY`, `SUM`, `AVG`
- INNER JOIN and LEFT JOIN examples
- Subqueries and `EXISTS`
- Views: `monthly_revenue`, `customer_lifetime`
- Example indexes for optimization were created in the DB creation step

