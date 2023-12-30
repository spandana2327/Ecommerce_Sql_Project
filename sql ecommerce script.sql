use supply_chain;
-- 1.	Reading the data from all tables.
select * from customer;
select * from Orders;
select * from Supplier;
select * from Product;
select * from OrderItem;

-- 2.	Find the country wise count of customers.
select id,firstname,lastname,city,country,count(id) from customer group by country;

-- 3.	Display the products which are not discontinued.
select id,productname,IsDiscontinued from product where IsDiscontinued=0;

-- 4.	Display the list of companies along with the product name that they are supplying.
select s.id,s.companyname,p.id,p.productname 
from supplier s
join product p
on s.id = p.SupplierId;

-- 5.	Display customer's information who stays in 'uk'
select * from customer where country='uk';

-- 6.	Display the costliest item that is ordered by the customer.
select a.Id, a.FirstName, a.LastName, a.City, a.Country, a.Phone, b.TotalAmount 
from customer a left join orders b on a.Id = b.CustomerId order by b.TotalAmount desc limit 1;

-- 7.	Display supplier id who owns highest number of products.
select supplierid,max(package) from product group by SupplierId having max(Package);

select SupplierId,count(ProductName)'No_of_products'
 from product
 group by SupplierId
 order by No_of_products desc
 limit 1;

-- 8.	Display month wise and year wise count of the orders placed.
select month(orderdate),year(orderdate),count(ordernumber) from orders group by month(orderdate),year(orderdate);

-- 9.	Which country has maximum suppliers.
# 1st approach
select country,count(id) from supplier group by country order by count(id) desc limit 1;
# 2nd approach
select country,count(id) as supplier_count from supplier group by country 
having count(id) = (select max(supplier_count) from (select country,count(id) as supplier_count from supplier group by country)a );

-- 10.	Which customers did not place any order.
select * from customer o
where not exists (select * from orders i where o.id=i.CustomerId);

-- Knowing the business
select * from customer;
select * from Orders;
select * from Supplier;
select * from Product;
select * from OrderItem;

-- 1.	Arrange the product id, product name based on high demand by the customer.
# 1st apporach:
select o.productid,p.productname,sum(quantity) 
from orderitem o
left join product p 
on o.ProductId = p.id
group by ProductId
order by sum(Quantity) desc;

-- 2.	Display the number of orders delivered every year.
select year(orderdate),count(id) from orders group by year(orderdate);

-- 3.	Calculate year-wise total revenue.
select year(orderdate),sum(totalamount) from orders group by year(orderdate);

-- 4.	Display the customer details whose order amount is maximum including his past orders.
-- 1st Approach
select * from customer where id = (select CustomerId from 
(select CustomerId,sum(TotalAmount) from orders group by customerid order by sum(totalamount) desc limit 1) a);
-- 2nd Approach
SELECT c.*
FROM customer c
WHERE c.id = (
    SELECT o.CustomerId
    FROM orders o
    GROUP BY o.CustomerId
    ORDER BY SUM(o.TotalAmount) DESC
    LIMIT 1
);

-- 5.	Display total amount ordered by each customer from high to low.
select totalamount,customerid from orders group by customerid order by totalamount desc;

/* A sales and marketing department of this company wants to find out how frequently 
customer have business with them. This can be done in two ways.  */
-- 6 Approach 1. List the current and previous order amount for each customers.
select customerid,totalamount,
lag(totalamount) over (partition by CustomerId) 
from orders;

/* 7. Approach 2. Display the customerid, order ids and the 
order dates along with the previous order date and the next order date for every customer in the table:: */
select customerid, id, orderdate,
lag(orderdate) over (partition by customerid order by orderdate) as previous_order_date,
lead(orderdate) over (partition by customerid order by orderdate) as next_order_date
from orders;

-- 8.	Display all the product details with the ordered quantity size as 1.
select p.id,p.productname,o.quantity 
from product p
join orderitem o on p.id=o.ProductId
where o.Quantity=1;


-- 9.	Display the compan(y)ies which supplies products whose cost is above 100.
select s.companyname,p.productname,p.unitprice
from supplier s
join product p
on s.id = p.SupplierId
where p.UnitPrice>100;

-- 10.	Create a combined list to display customers and supplier list as per the below format.
 select 'customer' as type,concat(firstname,lastname) as name,city,country,phone from customer c
 union
 select 'supplier' as type,concat(companyname,contactname) as name,city,country,phone from supplier s;

-- 11. Display the customer list who belongs to same city and country arrange in country wise.
select * from customer a join customer b where a.Country=b.Country and a.City=b.City order by a.country;

















