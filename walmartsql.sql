-- adding time of the day
alter table walmart add column time_of_day varchar(20);
update walmart set time_of_day =
case
    when Time  between '00:00:00' and '12:00:00' then 'Morning'
    when Time between '12:01:00' and '16:00:00' then 'Afternoon'
    else 'Evening'
    end ;
    
-- adding name of the day
alter table walmart add column day_name varchar(20);
update walmart set day_name = dayname(date);

-- adding name of the month
alter table walmart add column month_name varchar(20);
update walmart set month_name = monthname(date);


-- -------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- unique cities
select distinct City from walmart;

-- Branch of each walmart in each city
select City , count(*) as Total_branch from walmart
group by City;

-- each branch in which city
select distinct city, branch from walmart;


-- Product based questions------------------------------------------------------------------------
-- unique products
-- changing and removing space from name of column
alter table walmart change column `product line` productline varchar(200);

select distinct productline from walmart;

 -- common method of payment
 select payment , count(*) as number_of_payment from walmart group by 1;
 
 -- most selling products
 select productline , count(*) as product_sold from walmart
 group by 1 order by 2 desc;
 
 -- total revenue by month
 select month_name , round(sum(Total),2) as total_revenue from walmart
 group by 1 order by 2 desc;

-- cogs by month
 select month_name , round(sum(cogs),2) as total_cogs from walmart
 group by 1 order by 2 desc;

-- total revenue by productline
select productline , sum(total) as total_revenue from walmart
group by 1 order by 2 desc;

-- total revenue by city
select city , branch , round(sum(total),2) as total_revenue from walmart
group by 1,2 order by 2 desc;

-- largest tax by product line
-- changing and removing space from name of column
alter table walmart change column `Tax 5%` Tax varchar(200);

select productline , round(avg(tax),2) as avg_tax from walmart
group by 1 order by 2 desc;

-- branch sold more product than average
select branch , sum(quantity) as total_quantity from walmart
group by 1 
having sum(quantity) > (select avg(quantity) from walmart);

-- product sold  by gender
select gender, productline , count(gender) as number_sale from walmart
group by 1,2 order by 3 desc;

-- avg rating of product line
select productline, round(avg(rating),2) as avg_rating from walmart
group by 1 ;


-- sales based questions------------------------------------------------------------------------

-- total sales by time of the day
select time_of_day, count(*) as total_sales from walmart
group by 1 ;

-- type of customer brings most revenue
-- removing space from column name
alter table walmart change column `customer type` customer_type varchar(200);

select customer_type, round(sum(total),2) as total_sales from walmart
group by 1;

-- cities have largest tax

select city , round(avg(tax),2) as avg_tax from walmart
group by 1;

-- type of customer pay more tax
select customer_type , round(avg(tax),2) as avg_tax from walmart
group by 1;

-- cutomer based questions------------------------------------------------------------------------
-- unique paymnet by customer
select distinct payment from walmart;

-- customer type buy most
select customer_type, count(*) as total_sale from walmart
group by 1;

-- customer type and gender buy most
select customer_type, max(male) as male, max(female) as female from
(select  customer_type,
case 
when gender = 'male' then total_sale else 0 end as male,
case 
when  gender = 'female' then total_sale else 0 end as female
 from
(select gender, customer_type, count(*) as total_sale from walmart
group by 1 , 2)as new1)as new2 group by 1 ;

-- branch and gender buy most
select branch, max(male) as male, max(female) as female from
(select  branch,
case 
when gender = 'male' then total_sale else 0 end as male,
case 
when  gender = 'female' then total_sale else 0 end as female
 from
(select gender, branch, count(*) as total_sale from walmart
group by 1 , 2)as new1)as new2 group by 1 ;


-- time customer give most rating
select time_of_day , round(avg(rating),2) as rating from walmart
group by 1;


-- which week  customer give most rating
select day_name , round(avg(rating),2) as rating from walmart
group by 1 order by 2 desc;
    
    