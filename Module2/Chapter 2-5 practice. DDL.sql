create schema dw;

CREATE TABLE IF NOT EXISTS dw.customers_dim
(
 customer_id   varchar(8) NOT NULL,
 customer_name varchar(50) NOT NULL,
 segment       varchar(20) NOT NULL,
 CONSTRAINT PK_customers_dim PRIMARY KEY ( customer_id )
);

CREATE TABLE IF NOT EXISTS dw.geology_dim
(
 geo_id      integer NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 state       varchar(50) NOT NULL,
 postal_code varchar(5),
 CONSTRAINT PK_geology_dim PRIMARY KEY ( geo_id )
);

CREATE TABLE IF NOT EXISTS dw.products_dim
(
 product_id        integer NOT NULL,
 category          varchar(50) NOT NULL,
 sub_category      varchar(50) NOT NULL,
 product_name      varchar(300) NOT NULL,
 product_id_string varchar(15) NOT NULL,
 CONSTRAINT PK_products_dim PRIMARY KEY ( product_id )
);

CREATE TABLE IF NOT EXISTS dw.region_dim
(
 reg_id      integer NOT NULL,
 region_name varchar(50) NOT NULL,
 manager     varchar(50) NOT NULL,
 CONSTRAINT PK_region_dim PRIMARY KEY ( reg_id )
);

CREATE TABLE IF NOT EXISTS dw.returns
(
 order_id varchar(14) NOT NULL,
 returned boolean NOT NULL,
 CONSTRAINT PK_returns PRIMARY KEY ( order_id )
);

CREATE TABLE IF NOT EXISTS dw.shipping_dim
(
 ship_id   integer NOT NULL,
 ship_mode varchar(20) NOT NULL,
 CONSTRAINT PK_shipping_dim PRIMARY KEY ( ship_id )
);

CREATE TABLE IF NOT EXISTS dw.sales_fact
(
 row_id      integer NOT NULL,
 order_id    varchar(14) NOT NULL,
 order_date  date NOT NULL,
 ship_date   date NOT NULL,
 sales       numeric(15,2) NOT NULL,
 quantity    integer NOT NULL,
 discount    numeric(3,2) NOT NULL,
 profit      numeric(15,2) NOT NULL,
 product_id  integer NOT NULL,
 geo_id      integer NOT NULL,
 ship_id     integer NOT NULL,
 reg_id      integer NOT NULL,
 customer_id varchar(8) NOT NULL,
 CONSTRAINT PK_sales_fact PRIMARY KEY ( row_id ),
 CONSTRAINT FK_39 FOREIGN KEY ( product_id ) REFERENCES dw.products_dim ( product_id ),
 CONSTRAINT FK_42 FOREIGN KEY ( geo_id ) REFERENCES dw.geology_dim ( geo_id ),
 CONSTRAINT FK_45 FOREIGN KEY ( ship_id ) REFERENCES dw.shipping_dim ( ship_id ),
 CONSTRAINT FK_48 FOREIGN KEY ( reg_id ) REFERENCES dw.region_dim ( reg_id ),
 CONSTRAINT FK_56 FOREIGN KEY ( customer_id ) REFERENCES dw.customers_dim ( customer_id )
);

CREATE INDEX fkIdx_40 ON dw.sales_fact
(
 product_id
);

CREATE INDEX fkIdx_43 ON dw.sales_fact
(
 geo_id
);

CREATE INDEX fkIdx_46 ON dw.sales_fact
(
 ship_id
);

CREATE INDEX fkIdx_49 ON dw.sales_fact
(
 reg_id
);

CREATE INDEX fkIdx_57 ON dw.sales_fact
(
 customer_id
);