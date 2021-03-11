--Filling the customers dimentions table
insert into customers_dim
select distinct 
	o.customer_id,
	o.customer_name, 
	o.segment 
from public.orders o;

--Filling the geology dimentions table
insert into geology_dim 
select
	row_number() over () as geo_id,
	g.country,
	g.city,
	g.state,
	g.postal_code
from (select distinct 
	o.country, 
	o.city, 
	o.state, 
	o.postal_code 
from public.orders o 
order by state, city) g;

--Filling the products dimentions table
insert into products_dim 
select
	row_number() over () as product_id,
	p.category,
	p.subcategory,
	p.product_name,
	p.product_id as product_id_string
from (select distinct 
	o.product_id,
	o.category, 
	o.subcategory,
	o.product_name 
from public.orders o) p;

--Filling the region dimentions table
insert into region_dim 
select distinct 
	row_number() over () as reg_id,
	p.region as region_name,
	p.person as manager
from public.people p;

--Filling the shipping dimentions table
insert into shipping_dim 
select
	row_number() over () as ship_id,
	s.ship_mode
from
(select distinct o.ship_mode
from public.orders o) s;

--Filling the sales facts table
insert into sales_fact 
SELECT 
	row_id, 
	order_id, 
	order_date, 
	ship_date, 
	sales,
	o.quantity::int4, 
	o.discount,
	o.profit,
	pd.product_id, 
	gd.geo_id,
	sd.ship_id, 
	rd.reg_id , 
	cd.customer_id	 
FROM public.orders o 
inner join store.geology_dim gd on o.country = gd.country and o.city = gd.city and o.state = gd.state and coalesce(o.postal_code::text,'') = coalesce(gd.postal_code,'')
inner join customers_dim cd on o.customer_id = cd.customer_id 
inner join products_dim pd on o.product_id = pd.product_id_string and o.category = pd.category and o.subcategory = pd.sub_category and o.product_name = pd.product_name
inner join region_dim rd on o.region = rd.region_name 
inner join shipping_dim sd on o.ship_mode = sd.ship_mode 

--Check if number of rows equals to orders
select
	count(*) as c
from 
	sales_fact







