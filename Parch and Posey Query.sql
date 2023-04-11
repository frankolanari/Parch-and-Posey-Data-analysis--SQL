-- Task 1: Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT ac.primary_poc
,we.occurred_at
,we.channel
,ac.name AS account_name
FROM web_events AS we
JOIN accounts AS ac
ON we.account_id = ac.id
WHERE ac.name = 'Walmart';

-- Task 2: Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT id AS order_id
,total AS total_qty
,CASE WHEN total_amt_usd >= 3000 THEN 'Large'
      ELSE 'Small' 
	  END AS order_level
FROM orders;

-- Task 3: We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT ac.name AS customer_name
,o.total_amt_usd AS total_sales
,CASE WHEN o.total_amt_usd > 200000 THEN 'Top Level'
      WHEN o.total_amt_usd < 200000 AND o.total_amt_usd > 100000 THEN 'Mid Level'
	  ELSE 'Low Level'
	  END AS customer_level
FROM orders AS o
JOIN accounts AS ac
ON ac.id = o.account_id
ORDER BY total_sales DESC;

-- Task 4: Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
SELECT id
,account_id
,total AS total_qty
,RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;

-- Task 5: Find the region with the largest (sum) of sales total_amt_usd, how many total (count)
SELECT r.name AS region
,SUM(o.total_amt_usd) AS total_sales
,COUNT(o.total) AS total_orders
FROM accounts AS ac
JOIN orders AS o
ON ac.id = o.account_id
JOIN sales_reps AS sr
ON ac.sales_rep_id = sr.id
JOIN region AS r
ON sr.region_id = r.id
GROUP BY r.name
ORDER BY total_orders DESC
LIMIT 1


