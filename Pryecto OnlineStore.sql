Create database online_store;

---- voy a trabajar dentro de la base de datos online_store

USE online_store;
GO

Create table customers (
customer_id int primary key identity(1,1),
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) unique not null,
phone varchar(20),
city varchar(50)
);
---
create table categories(
category_id int primary key identity(1,1),
category_name varchar(100) not null 
);
---

create table product (
product_id int primary key identity(1,1),
product_name varchar(100) not null,
price decimal(10,2) not null,
stock int not null,
category_id int ,

FOREIGN key (category_id)
references categories(category_id),

);
--

go

--- Ordenar tablas 

create table orders (

order_id int primary key identity(1,1),
customer_id int not null,
order_date date default getdate(),
status varchar(30) default 'pending',

foreign key (customer_id)
references customers(customer_id)
)
GO

-- Order Detail Detalles

CREATE TABLE order_details (
    detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES product(product_id)
);
GO

---- Payments table

create table payments(
payment_id int primary key identity(1,1),
order_id int not null,
payment_method varchar(50),
amount decimal(10,2),
payment_date date default getdate(),

foreign key (order_id)
references orders (order_id)
);
go

--- insertar customer informacion

insert into customers
(first_name,last_name, email,phone,city)
values
('kevin', 'vasquez', 'kevin@gmail.com','809-111-2222','Santo Domingo'),
('Maria', 'Lopez','Maria@gmail.com','809-222-333','Santiago'),
('Carlos',' Perez','Carlos@gmail.com','860958358','Peru'),
('Alexandra','Gomez','Alexandra@gmail.com','9853532','LimaPeru');
GO
select * from customers;

--- Insertar Categorias / Categories

insert into categories (category_name)

values -- Valores
('technolgy'),
('Clothing'),
('System'),
('home'),
('Software');
Go
Select * from categories

--- Insert Prodcut

insert into product

(product_name, price,stock, category_id)
values

('latop lenovo' , 650.00,10,1),
('Wireless mouse', 20.00,50,1),
('Computer PowerFul', 1500.00,100,2),
('Office Chair Gamers', 5000,5,4),
('Latop Asus', 3500.00,10,5);
go
select * from product
--- insert into order

insert into orders
(customer_id, status)

values

(1, 'completed'),
(2, 'Pending'),
(1, 'Completed');

go
-- insert order detalles

insert into order_details

(order_id, product_id, quantity, unit_price)

values
(1,3,1,650.00),
(2,4,2,20.00),
(3,5,1,1500.00),
(3,6,4,5000.00),
(1,7,3,3500.00);

go

select * from order_details
----

insert into payments

(order_id, payment_method, amount)

values

(1,'credit card',690.00),
(3,'Paylpal', 120.00);

go
 
-- selecionar todo

Select * from payments;

go 
----

Select 
p.product_name,
c.category_name,
p.price,
p.stock

from 
product p

inner join categories c
on p.category_id = c.category_id;

go
---

Select 

o.order_id,

c.first_name,
c.last_name,
o.order_date,
o.status

from orders o
inner join customers c
on o.customer_id = c.customer_id;
go
----- View order Details

select 

o.order_id,
c.first_name,
p.product_name,
od.quantity,
od.unit_price,
od.quantity * od.unit_price as subtotal
from order_details od
inner join orders o
on od.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
inner join product p
on od.product_id = p.product_id;
go 

--- total sales per order

select 

o.order_id,
sum(od.quantity * od.unit_price) as total_order
from order_details od

inner join orders o 
on od.order_id = o.order_id

group by o.order_id;
go


-- total spent per custromer / total de gasto de cliente

select 

c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_spent

from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_details od
on o.order_id = od.order_id
group by c.first_name, c.last_name
order by total_spent desc;
go


select * from order_details


------


SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM product;
SELECT * FROM payments;


Use online_store;
go 

-- INNER JOIN entre customers y orders 
select 
c.first_name,
c.last_name,
o.order_id,
o.order_date
from customers c
inner join orders o
on c.customer_id = o.customer_id;

-- SUm sirve para sumar dinero calcula el subtotal

select 
c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_spent
from customers c 
inner join orders o
on c.customer_id = o.customer_id
inner join order_details od
on o.order_id = od.order_id
group by c.first_name, c.last_name; -- agrupa por clientes / group by row or cliente o 


-- ORDER BY sirve para odernar resultados / order results


select 
c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_spent
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_details od
on o.order_id= od.order_id
group by c.first_name, c.last_name
ORDER BY total_spent DESC;


select count (*) as total_orders --- count cuenta todas las filas rows
from orders;

select count (*) as total_product
from product;


select count(*) as customers
from customers;


select  -- aqui miramos las ordenes que hizo el cliente
c.first_name,
count(o.order_id) as total_orders
from customers c
inner join orders o 
on c.customer_id = o.customer_id
group by c.first_name;

--- Count sirve para contar Clientes o otra 

select count(*) as total_customers
from customers;

-- Count Orders per customer
select 
c.first_name,
count(o.order_id) as total_orders
from customers c
inner join orders o
on c.customer_id = o.customer_id
group by c.first_name;

-- Dinero total money spent per client

select 
c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_spent
from customers c
inner join orders o
on  c.customer_id = o.customer_id
inner join order_details od
on o.order_id = od.order_id
group by c.first_name, c.last_name
order by total_spent desc;

-- Best Selling product / producto vendidos

select p.product_name,
sum(od.quantity) as total_sold
from product p
inner join order_details od 
on p.product_id = od.product_id
group by p.product_name
order by total_sold desc;

-- total store  renueve  Ganancias totales

select 
sum(amount) as total_revenue
from payments;

--- Average= promedio price

select avg(price) as average_price
from product;



 -- Left Join ensena todos los customer  and if a customer has order they appear

Select 

c.first_name,
c.last_name,
o.order_id,
o.status
from customers c
left join orders o
on c.customer_id = o.customer_id;


--- Left Join muestra todos los customers aunque no tengan órdenes

Select 
c.first_name,
c.last_name,
o.order_id,
o.status

from customers c
left join orders o
on c.customer_id = o.customer_id;

-- Where are filtros / Filters
select 
* from customers 
where city = 'LimaPeru';

select * from customers
where first_name = 'kevin'
---------- Modificar datops / Actualizar datos 
update customers
set city = 'LimaPeru'
where first_name = 'kevin' ;


-- Having Agrupan filas que tienen el mismo valor / rows have same values

select 
status,
count(*) as total_orders
from orders
group by status
having count (*) >2;

-- Else condiciion se cumple / AS ponerle el noimbre nueva columna
Select 
first_name,
city,

case
when city = 'limaPeru' then 'peru customer'
else ' other customer '
end as customer_type
from customers;
