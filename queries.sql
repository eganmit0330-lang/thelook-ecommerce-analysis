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
