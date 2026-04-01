# TheLook E-Commerce Analysis

Analysis of sales performance, customer demographics, 
and return rates for a fictional e-commerce retailer 
using the BigQuery public TheLook dataset.

## Business Questions
1. Which product categories drive the most revenue?
2. Which categories have the highest return rates?
3. Which customer demographics spend the most?

## Key Findings
- Outerwear is the highest revenue category
- Clothing Sets have both the lowest revenue AND 
  the highest return rate (12.7%) — a double drag 
  on profitability
- Customers aged 46+ are the highest spenders 
  regardless of gender

## Business Recommendations
- Reduce investment in Clothing Sets — high return 
  rate and low revenue make it the weakest category
- Target marketing spend toward 46+ demographic, 
  particularly in high-revenue categories like Outerwear
- Monitor return rates alongside revenue — a category 
  can look profitable on revenue alone but lose margin 
  to returns

## Tools
- Google BigQuery (SQL)
- Tableau Public

## Visualizations
https://public.tableau.com/views/Thelook-RevenuebySalesCategory/Sheet1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
https://public.tableau.com/views/RevenuebyGenderandAge/Sheet1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
https://public.tableau.com/views/ReturnratebySalesCategory/Sheet1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link



## Queries
--Total Revenue by Category--
SELECT 
  SUM(oi.sale_price) AS total_revenue,
  p.category
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p 
  ON oi.product_id = p.id
GROUP BY category
ORDER BY total_revenue DESC;

--Return Rate by Category--
SELECT  p.category,
(100.0* COUNT(CASE WHEN oi.returned_at IS NOT NULL THEN 1 ELSE NULL END))/ (COUNT(oi.order_id)) AS return_rt
FROM bigquery-public-data.thelook_ecommerce.order_items oi  
JOIN bigquery-public-data.thelook_ecommerce.products p   ON oi.product_id = p.id  
GROUP BY p.category  
ORDER BY return_rt DESC;

--Revenue by Gender and Age --
SELECT 
  CASE 
    WHEN u.age BETWEEN 18 AND 25 THEN '18-25'
    WHEN u.age BETWEEN 26 AND 35 THEN '26-35'
    WHEN u.age BETWEEN 36 AND 45 THEN '36-45'
    WHEN u.age BETWEEN 46 AND 100 THEN '46+'
    ELSE NULL 
  END AS age_bucket,
  u.gender,
  SUM(oi.sale_price) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi 
JOIN `bigquery-public-data.thelook_ecommerce.users` u 
  ON oi.user_id = u.id 
GROUP BY u.gender, age_bucket
ORDER BY revenue DESC;
