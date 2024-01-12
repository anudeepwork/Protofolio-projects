SELECT * FROM pizza_sales

--KPI'S
--Total Revenue
select sum(total_price) as total_revenue from pizza_sales 

--Average order Value
select sum(total_price) / count(distinct order_id) as Average_order_value from pizza_sales

--Total pizzas sold
select sum(quantity) as Total_pizzas_sold from pizza_sales 

--Total orders
select count(distinct order_id) as total_orders from pizza_sales 

--Average pizzas per order
select CAST(CAST(sum(quantity) AS DECIMAL(10,2)) / 
CAST(count(distinct order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
as Avg_pizzas_per_order from pizza_sales 

--Chart requiremenets

--Daily Trend for total orders
select DATENAME(DW, order_date) as order_day, count(distinct order_id) as total_orders
from pizza_sales 
group by DATENAME(DW, order_date)

--Monthly trend of total orders
SELECT DATENAME(Month, order_date) as order_month,
       COUNT(DISTINCT order_id) as total_orders
FROM pizza_sales   
GROUP BY DATENAME(Month, order_date), MONTH(order_date)
ORDER BY MONTH(order_date) ASC;

--highest to lowest months
SELECT DATENAME(Month, order_date) as order_month,
       COUNT(DISTINCT order_id) as total_orders
FROM pizza_sales   
GROUP BY DATENAME(Month, order_date)
ORDER BY total_orders desc

--number of pizza sold by category
Select pizza_category, sum(quantity) / count(distinct pizza_category) as total_sales_by_category FROM pizza_sales 
group by pizza_category

--Total pizza sales by percentage
Select pizza_category, sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as PCT
from pizza_sales 
group by pizza_category

Select pizza_category, sum(total_price) as total_sales, sum(total_price) * 100 / (select sum(total_price) from pizza_sales where MONTH(order_date) = 1) as PCT
from pizza_sales 
where MONTH(order_date) = 1
group by pizza_category

--Percentage of sales by pizza size
Select pizza_size, CAST(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) AS decimal(10,2)) as PCT
from pizza_sales 
group by pizza_size
order by PCT DESC

--BY quarter
Select pizza_size, CAST(sum(total_price) as decimal (10,2)) as total_sales, CAST(sum(total_price) * 100 / 
(select sum(total_price) from pizza_sales where Datepart(quarter, order_date) = 1) AS decimal(10,2)) as PCT
from pizza_sales 
where Datepart(quarter, order_date) = 1
group by pizza_size
order by PCT DESC

--Top 5 best sellers by revenue

select TOP 5 pizza_name, sum(total_price) as total_revenue 
from pizza_sales
group by pizza_name
Order by total_revenue DESC

--Top 5 best sellers by Total_quantity

select TOP 5 pizza_name, sum(quantity) as total_quantity 
from pizza_sales
group by pizza_name
Order by total_quantity DESC

--Top 5 best sellers by Total_orders

select TOP 5 pizza_name, count(distinct order_id) as total_orders 
from pizza_sales
group by pizza_name
Order by total_orders DESC

--Bottom 5 Pizza sellers by revenue

select TOP 5 pizza_name, sum(total_price) as total_revenue 
from pizza_sales
group by pizza_name
Order by total_revenue

--Bottom 5 sellers by Total_quantity

select TOP 5 pizza_name, sum(quantity) as total_pizzas_sold 
from pizza_sales
group by pizza_name
Order by total_pizzas_sold

--Bottom 5 sellers by Total_orders

select TOP 5 pizza_name, count(distinct order_id) as total_orders 
from pizza_sales
group by pizza_name
Order by total_orders 










