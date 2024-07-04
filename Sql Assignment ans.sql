-- question 1a
select employeeNumber, firstName,lastName from employees
 where jobTitle = 'Sales Rep' and reportsTo =1102;
 
-- question 1b
select productline from productlines where productline like '% Cars';

-- question 2

select customerNumber,customerName, 
if(country ='USA'OR country ='Canada',' North America',
    if(country ='UK' or country='France' or country='Germany', 'Europe','other')) as customerSegment
from customers;

-- question 3a

select productCode, sum(quantityOrdered) as Total_orderd 
from orderdetails
group by productCode 
order by sum(quantityOrdered ) desc limit 10 ;

-- question 3b

select monthname(paymentDate) as payment_month, count(monthname(paymentDate)) as num_payments 
from payments 
group by monthname(paymentDate) 
order by count((paymentDate)) desc;

-- question 4a
create database Customers_Orders;
use Customers_Orders;
create table Customers(
             customer_id int auto_increment primary key,
             first_name varchar(50) not null,
			 last_name varchar(50) not null,
			 email varchar(255) unique,
             phone_number varchar(20));
             
-- question 4b

create table orders(
              order_id int auto_increment primary key ,
              customer_id int, foreign key(customer_id) references customers(customer_id),
              total_amount decimal(10,2), check(total_amount>0));
              
-- question 5a
use classicmodels;
select country,count(orderNumber) 
               from customers 
               inner join orders on customers.customerNumber = orders.customerNumber
			   group by country
               order by count(orderNumber) desc;

-- question 6a
create table project(
             employeeID int auto_increment primary key,
             FullName varchar(50) not null,
             Gender enum('Male','Female'),
             ManagerID int);
             
insert into project(FullName,Gender,ManagerID) values('Pranaya','Male',3),
						  ('Priyanka','Female',1),
                          ('Preety','Female',null),
                          ('Anurag','Male',1),
                          ('Sambit','Male',1),
                          ('Rajesh','Male',3),
                          ('Hina','Female',3);
select*from project; 

select   mgr.fullName as Manager_Name,
         emp.fullName as Employee_Name
         from project as mgr inner join project as emp 
         on mgr.employeeID = emp.ManagerID 
         order by mgr.fullName ;

-- Question 7a
create table facility(
             facility_ID int,
             Name varchar(100),
             State varchar(100),
             Country varchar(100));
             
alter table facility modify facility_ID int auto_increment primary key;
alter table facility add column City varchar(100) not null;
describe facility;

-- question 8a               
create view product_category_sales as
select pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) as total_sales,
    COUNT(distinct o.orderNumber) as number_of_orders
from ProductLines pl
join Products p on pl.productLine = p.productLine
join OrderDetails od on p.productCode = od.productCode
join Orders o on od.orderNumber = o.orderNumber
group by pl.productLine;

select * from product_category_sales;
 
 -- question 9a
 call Get_country_payments(2003,"France");
 
 -- question 10a
select c.customerName,count(o.orderNumber) as order_count, 
      dense_rank() over( order by count(o.orderNUmber) desc) as order_frequency_rnk
from  customers c join orders o
      on c.customerNumber = o.customerNumber  
      group by c.customerName;
      
-- Question 10b not complete
select year(orderDate) as Year,monthname(orderDate) as month,count(ordernumber) as 'Total Orders',  
      concat( round(count(ordernumber)-lag(count(ordernumber))over(order by year(orderDate))) / 
       lag(count(ordernumber))over(order by year(orderDate))*100,"%") as 'Yoy % change' 
from orders group by year(orderdate), monthname(orderdate);

-- question 11a
select productLine,count(buyPrice) as Total
         from products
		  where buyPrice>(select avg(buyPrice) from products)
		  group by productLine
          order by count(buyPrice) desc;
        
-- Question 12
create table Emp_EH(
               EmpID int Primary Key,
               EmpName varchar(30),
               EmailAddress VArchar(50));

call EmpEntry(null, 'esha', 'esha@123');

-- Question 13
create table Emp_BIT(
              Name varchar(25),
              Occupation Varchar(30),
              Working_Date date,
              Working_hours int);
insert into Emp_BIT values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

insert into Emp_BIT values('Peter','Teacher','2020-10-04',-10);
select*from Emp_BIT;
