-- Deduplicate with ROW_NUMBER
SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_at DESC) AS rn
FROM raw_table;

-- Running total
SELECT date,
       sales,
       SUM(sales) OVER (ORDER BY date) AS running_sales
FROM revenue_table;

-- Rank top sellers by region
SELECT region, seller, sales,
       RANK() OVER (PARTITION BY region ORDER BY sales DESC) AS sales_rank
FROM sales_data;
