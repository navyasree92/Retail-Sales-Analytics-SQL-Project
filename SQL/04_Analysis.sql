USE RetailSalesDB;
--analysis process
--What is the total revenue generated from completed orders?

select sum(od.quantity * od.unit_price) as 'Total Revenue' from 
Order_Details od join Orders o
on od.order_id= o.order_id 
where o.order_status ='completed';

--2: Revenue by Product Category.

select sum(od.quantity * od.unit_price) as 'Total Revenue',p.category from 
Order_Details od join Orders o
on od.order_id= o.order_id join products p
on od.product_id= p.product_id 
where o.order_status ='Completed'
group by p.category;

--max revenue in category
select sum(od.quantity * od.unit_price) as 'Total Revenue',p.category from 
Order_Details od join Orders o
on od.order_id= o.order_id join products p
on od.product_id= p.product_id 
where o.order_status ='Completed'
group by p.category
order by [Total Revenue] desc;

--identify your #1 revenue-generating product.

select Top(1) sum(od.quantity * od.unit_price) as Total_Revenue,p.category,p.product_name from 
Order_Details od join Orders o
on od.order_id= o.order_id join products p
on od.product_id= p.product_id 
where o.order_status ='Completed'
group by p.category,p.product_name
order by Total_Revenue desc

--"Which 5 products sold the most units?"

SELECT TOP(5) SUM(od.quantity) AS Total_count ,p.category,p.product_name from 
Order_Details od join Orders o
on od.order_id= o.order_id join products p
on od.product_id= p.product_id 
where o.order_status ='Completed'
group by p.category,p.product_name
order by Total_count DESC;

--Which customers have never placed an order?
select *from customers c left join orders o
on c.customer_id=o.customer_id 
where order_id is null;

--What is the average order value (AOV) for completed orders?
select o.order_id,sum(quantity * unit_price) as total_order_val from Order_Details od join Orders o
on od.order_id=o.order_id
where order_status ='Completed'
group by o.order_id
order by total_order_val

select round(AVG(total_order_val),2) as avg_order_val from
(select o.order_id,sum(quantity * unit_price) as total_order_val from Order_Details od join Orders o
on od.order_id=o.order_id
where order_status ='Completed'
group by o.order_id) as total_orders;

--Which product category has the highest number of units sold?
select top(1) p.category,sum(od.quantity) as total_count from Order_Details od join products p
on od.product_id=p.product_id join Orders o
on od.order_id=o.order_id
where order_status='Completed'
group by p.category
order by total_count desc

--What percentage of orders are Completed vs Cancelled?
SELECT 
    order_status,
    COUNT(order_id) AS total_orders,
    round(COUNT(order_id) * 100.0 /
        (SELECT COUNT(order_id)
         FROM Orders
         WHERE order_status IN ('Completed', 'Cancelled')),
        2
    ) AS percentage
FROM Orders
WHERE order_status IN ('Completed', 'Cancelled')
GROUP BY order_status;

--Which are the most popular products based on the number of units sold?
select top(5) sum(od.quantity) as Total_count,p.product_name from Order_Details od
 join orders o on od.order_id=o.order_id join products p
 on od.product_id=p.product_id
 where o.order_status='Completed'
 group by p.product_name
 order by Total_count desc

 --Which city generates the highest revenue from completed orders?
 select top(1) c.city,sum(od.quantity*od.unit_price) as total_revenue from Customers c join Orders o
 on c.customer_id=o.customer_id join Order_Details od
 on o.order_id= od.order_id
 where o.order_status='completed'
 group by c.city
 order by total_revenue desc;

 --Which customer has placed the highest number of completed orders?
 select top(1) c.customer_id,c.first_name,Count(o.order_id) as total_orders from Customers c join orders o
 on c.customer_id =o.customer_id
 where o.order_status='completed'
 group by c.customer_id,c.first_name
 order by total_orders desc

 --Highest Revenue Customer
 select top(1) c.customer_id,c.first_name,c.last_name,sum(od.quantity*od.unit_price) as total_revenue from customers c join Orders o
 on c.customer_id=o.customer_id join 
 Order_Details od on 
 o.order_id=od.order_id
 where o.order_status='Completed'
 group by c.customer_id,c.first_name,c.last_name
 order by total_revenue desc;


 








--How much revenue did the business generate each month from completed orders?
SELECT 
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM Order_Details od
JOIN Orders o
    ON od.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY 
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY 
    order_year,
    order_month;

--Customers by Revenue

select TOP(5) c.first_name,c.last_name,c.customer_id,sum(od.unit_price*od.quantity) as Total_revenue from Order_Details od join Orders o
on od.order_id=o.order_id join Customers c
on c.customer_id=o.customer_id
where o.order_status='completed'
group by c.customer_id,
    c.first_name,
    c.last_name
order by Total_revenue desc;







