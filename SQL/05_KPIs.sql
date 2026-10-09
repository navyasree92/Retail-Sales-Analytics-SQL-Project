USE RetailSalesDB;
GO

-- 1. Total Orders

select count(order_id) as total_orders
from Orders;


-- 2. Completed Orders

select count(order_id) as completed_orders
from Orders
where order_status = 'Completed';


-- 3. Cancelled Orders

select count(order_id) as cancelled_orders
from Orders
where order_status = 'Cancelled';


-- 4. Total Units Sold

select sum(od.quantity) as total_units_sold
from Order_Details od
join Orders o
on od.order_id = o.order_id
where o.order_status = 'Completed';


-- 5. Total Revenue

select sum(od.quantity * od.unit_price) as total_revenue
from Order_Details od
join Orders o
on od.order_id = o.order_id
where o.order_status = 'Completed';


-- 6. Average Order Value

select round(avg(total_order_value),2) as average_order_value
from
(
    select o.order_id,
    sum(od.quantity * od.unit_price) as total_order_value
    from Orders o
    join Order_Details od
    on o.order_id = od.order_id
    where o.order_status = 'Completed'
    group by o.order_id
) as order_totals;


-- 7. Unique Customers

select count(distinct customer_id) as unique_customers
from Orders
where order_status = 'Completed';


-- 8. Cancellation Rate

select
cast(
round(
(count(case when order_status = 'Cancelled' then 1 end) * 100.0)
/
count(order_id),
2
) as decimal(10,2)
) as cancellation_rate
from Orders;