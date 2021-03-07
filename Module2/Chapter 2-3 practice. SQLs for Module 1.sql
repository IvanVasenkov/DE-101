--Overview. Count total sales
SELECT sum(o.sales) as total_sales
FROM orders o;

--Overview. Count total profit
SELECT sum(o.profit) as total_profit
FROM orders o;

--Overview. Count profit ratio
SELECT round(sum(o.profit)/sum(o.sales)*100,2) as profit_ratio
FROM orders o;

--Overview. Count profit per order
SELECT round(sum(o.profit)/count(distinct o.order_id),2) as profit_per_order
FROM orders o;

--Overview. Count sales by customer
SELECT round(sum(o.sales)/count(distinct o.customer_id),2) as sales_by_customes
FROM orders o;

--Overview. Count average discount
SELECT round(avg(discount)*100,2) as avg_discount
FROM orders o;

--Overview. Monthly sales by segment
SELECT 
	case 
		when Extract(month from o.order_date)::int8 > 9 then
			concat(Extract(YEAR from o.order_date)::varchar(4), '-', Extract(month from o.order_date)::varchar(2))
		else
			concat(Extract(YEAR from o.order_date)::varchar(4), '-', concat('0',Extract(month from o.order_date)::varchar(1)))
	end as order_month,
	o.segment as segment,
	round(sum(o.sales),2) as sales
FROM orders o
group by segment, order_month
order by order_month, segment;

--Overview. Monthly sales by product category
SELECT 
	case 
		when Extract(month from o.order_date)::int8 > 9 then
			concat(Extract(YEAR from o.order_date)::varchar(4), '-', Extract(month from o.order_date)::varchar(2))
		else
			concat(Extract(YEAR from o.order_date)::varchar(4), '-', concat('0',Extract(month from o.order_date)::varchar(1)))
	end as order_month,
	o.category as category,
	round(sum(o.sales),2) as sales
FROM orders o
group by category, order_month
order by order_month, category;

--Product metrics. Sales by Product Category over time
SELECT 
	o.order_date as order_date,
	o.category as category,
	round(sum(o.sales),2) as sales
FROM orders o
group by category, order_date
order by order_date, category;

--Customer Analysis. Sales and Profit by Customer
SELECT 
	o.customer_id as customer_id,
	o.customer_name as customer_name,
	round(sum(o.sales),2) as sales,
	round(sum(o.profit),2) as profit
FROM orders o
group by customer_id, customer_name
order by customer_id, customer_name;

--Customer Analysis. Customes ranking. Top by profit
SELECT 
	o.customer_id as customer_id,
	o.customer_name as customer_name,
	round(sum(o.profit),2) as profit
FROM orders o
group by customer_id, customer_name
order by profit desc
limit 10;

--Customer Analysis. Customes ranking. Top by sales
SELECT 
	o.customer_id as customer_id,
	o.customer_name as customer_name,
	round(sum(o.sales),2) as sales 
FROM orders o
group by customer_id, customer_name
order by sales desc
limit 10;

--Customer Analysis. Customes ranking. Top by number of orders
SELECT 
	o.customer_id as customer_id,
	o.customer_name as customer_name,
	count(distinct o.order_id) as n_orders 
FROM orders o
group by customer_id, customer_name
order by n_orders desc
limit 10;

--Customer Analysis. Sales per region
SELECT 
	o.region as region,
	round(sum(o.sales),2) as sales 
FROM orders o
group by o.region
order by sales desc
limit 10;



