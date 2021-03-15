--Filling the customers dimentions table
insert into dw.customers_dim
select distinct 
	o.customer_id,
	o.customer_name, 
	o.segment 
from stg.orders o

--Filling the geology dimentions table
insert into dw.geology_dim 
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
from stg.orders o 
order by state, city) g;

--Data quality check
select distinct country, city, state, postal_code from dw.geology_dim
where country is null or city is null or postal_code is null;

-- Set postal code for city Burlington, Vermont
update dw.geology_dim
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

--Also update orders
update stg.orders
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

--Filling the products dimentions table
insert into dw.products_dim 
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
from stg.orders o) p;

--Filling the region dimentions table
insert into dw.region_dim 
select distinct 
	row_number() over () as reg_id,
	p.region as region_name,
	p.person as manager
from public.people p;

--Filling the shipping dimentions table
insert into dw.shipping_dim 
select
	row_number() over () as ship_id,
	s.ship_mode
from
(select distinct o.ship_mode
from stg.orders o) s;

--Filling the sales facts table
insert into dw.sales_fact 
SELECT 
	row_id, 
	order_id, 
	order_date, 
	ship_date, 
	sales,
	o.quantity, 
	o.discount,
	o.profit,
	pd.product_id, 
	gd.geo_id,
	sd.ship_id, 
	rd.reg_id , 
	cd.customer_id	 
FROM stg.orders o 
inner join dw.geology_dim gd on o.country = gd.country and o.city = gd.city and o.state = gd.state and o.postal_code = gd.postal_code
inner join dw.customers_dim cd on o.customer_id = cd.customer_id 
inner join dw.products_dim pd on o.product_id = pd.product_id_string and o.category = pd.category and o.subcategory = pd.sub_category and o.product_name = pd.product_name
inner join dw.region_dim rd on o.region = rd.region_name 
inner join dw.shipping_dim sd on o.ship_mode = sd.ship_mode;

--Check if i get 9994rows?
select count(*) from dw.sales_fact o
inner join dw.geology_dim gd on o.geo_id = gd.geo_id
inner join dw.customers_dim cd on o.customer_id = cd.customer_id 
inner join dw.products_dim pd on o.product_id = pd.product_id 
inner join dw.region_dim rd on o.reg_id = rd.reg_id 
inner join dw.shipping_dim sd on o.ship_id = sd.ship_id ;



