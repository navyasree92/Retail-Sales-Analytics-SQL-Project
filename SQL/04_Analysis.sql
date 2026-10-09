USE RetailSalesDB;
GO

-- 1. Total Revenue

select sum(od.quantity * od.unit_price) as total_revenue
from Order_Details od
join Orders o
on od.order_id = o.order_id
where o.order_status = 'Completed';


-- 2. Revenue by Category

select p.category,
sum(od.quantity * od.unit_price) as total_revenue
from Order_Details od
join Orders o
on od.order_id = o.order_id
join Products p
on od.product_id = p.product_id
where o.order_status = 'Completed'
group by p.category
order by total_revenue desc;


-- 3. Top 5 Products by Units Sold
select top(5)
p.product_name,
p.category,
sum(od.quantity) as total_units
from Order_Details od
join Orders o
on od.order_id = o.order_id
join Products p
on od.product_id = p.product_id
where o.order_status = 'Completed'
group by p.product_name, p.category
order by total_units desc;


-- 4. Highest Revenue Customer

select top(1)
c.customer_id,
c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_revenue
from Customers c
join Orders o
on c.customer_id = o.customer_id
join Order_Details od
on o.order_id = od.order_id
where o.order_status = 'Completed'
group by c.customer_id, c.first_name, c.last_name
order by total_revenue desc;


-- 5. Average Order Value

select round(avg(total_order_value),2) as avg_order_value
from
(
    select o.order_id,
    sum(od.quantity * od.unit_price) as total_order_value
    from Orders o
    join Order_Details od
    on o.order_id = od.order_id
    where o.order_status = 'Completed'
    group by o.order_id
) as total_orders;


-- 6. Customers With No Orders

select c.customer_id,
c.first_name,
c.last_name
from Customers c
left join Orders o
on c.customer_id = o.customer_id
where o.order_id is null;


-- 7. Category With Highest Units Sold

select p.category,
sum(od.quantity) as total_units
from Order_Details od
join Orders o
on od.order_id = o.order_id
join Products p
on od.product_id = p.product_id
where o.order_status = 'Completed'
group by p.category
order by total_units desc;


-- 8. Customer With Most Completed Orders

select top(1)
c.customer_id,
c.first_name,
c.last_name,
count(o.order_id) as completed_orders
from Customers c
join Orders o
on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.first_name, c.last_name
order by completed_orders desc;


-- 9. Highest Revenue City

select top(1)
c.city,
sum(od.quantity * od.unit_price) as total_revenue
from Customers c
join Orders o
on c.customer_id = o.customer_id
join Order_Details od
on o.order_id = od.order_id
where o.order_status = 'Completed'
group by c.city
order by total_revenue desc;


-- 10. Monthly Revenue

select
year(o.order_date) as order_year,
month(o.order_date) as order_month,
sum(od.quantity * od.unit_price) as monthly_revenue
from Orders o
join Order_Details od
on o.order_id = od.order_id
where o.order_status = 'Completed'
group by year(o.order_date), month(o.order_date)
order by order_year, order_month;


-- 11. Top 5 Customers by Revenue

select top(5)
c.customer_id,
c.first_name,
c.last_name,
sum(od.quantity * od.unit_price) as total_revenue
from Customers c
join Orders o
on c.customer_id = o.customer_id
join Order_Details od
on o.order_id = od.order_id
where o.order_status = 'Completed'
group by c.customer_id, c.first_name, c.last_name
order by total_revenue desc;


-- 12. Monthly Revenue Growth

WITH MonthlyRevenue AS
(
    select
    year(o.order_date) as order_year,
    month(o.order_date) as order_month,
    sum(od.quantity * od.unit_price) as monthly_revenue
    from Order_Details od
    join Orders o
    on od.order_id = o.order_id
    where o.order_status = 'Completed'
    group by year(o.order_date), month(o.order_date)
),
RevenueWithPrevious AS
(
    select
    order_year,
    order_month,
    monthly_revenue,
    lag(monthly_revenue) over
    (
        order by order_year, order_month
    ) as previous_month_revenue
    from MonthlyRevenue
)
select
order_year,
order_month,
monthly_revenue,
previous_month_revenue,
cast(
round(
(monthly_revenue - previous_month_revenue)
* 100.0 / previous_month_revenue, 2
) as decimal(10,2)
) as revenue_growth_percentage
from RevenueWithPrevious
order by order_year, order_month;


-- 13. Average Units Per Order

select
round(
sum(od.quantity) * 1.0 / count(distinct o.order_id),2
) as avg_units_per_order
from Orders o
join Order_Details od
on o.order_id = od.order_id
where o.order_status = 'Completed';