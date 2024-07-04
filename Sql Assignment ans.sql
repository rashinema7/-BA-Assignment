/*Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
  a.Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to employee with employeenumber 1102*/ 

select employeeNumber, firstName,lastName from employees
 where jobTitle = 'Sales Rep' and reportsTo =1102;


 
/*b.	Show the unique productline values containing the word cars at the end from the products table.*/

select productline from productlines where productline like '% Cars';



/*Q2. CASE STATEMENTS for Segmentation
a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
                        "North America" for customers from USA or Canada
                        "Europe" for customers from UK, France, or Germany
                        "Other" for all remaining countries
     Select the customerNumber, customerName, and the assigned region as "CustomerSegment". */


select customerNumber,customerName, 
if(country ='USA'OR country ='Canada',' North America',
    if(country ='UK' or country='France' or country='Germany', 'Europe','other')) as customerSegment
from customers;




/*Q3. Group By with Aggregation functions and Having clause, Date and Time functions
a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.*/


select productCode, sum(quantityOrdered) as Total_orderd 
from orderdetails
group by productCode 
order by sum(quantityOrdered ) desc limit 10 ;



/*b.	Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number of payments
for each month and include only those months with a payment count exceeding 20. Sort the results by total number of payments in descending order.*/

select monthname(paymentDate) as payment_month, count(monthname(paymentDate)) as num_payments 
from payments 
group by monthname(paymentDate) 
order by count((paymentDate)) desc;



/*Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default

Create a new database named and Customers_Orders and add the following tables as per the description

a.	Create a table named Customers to store customer information. Include the following columns:

customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.*/


create database Customers_Orders;
use Customers_Orders;
create table Customers(
             customer_id int auto_increment primary key,
             first_name varchar(50) not null,
			 last_name varchar(50) not null,
			 email varchar(255) unique,
             phone_number varchar(20));


             
/*b.	Create a table named Orders to store information about customer orders. Include the following columns:

    	order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.

*/

create table orders(
              order_id int auto_increment primary key ,
              customer_id int, foreign key(customer_id) references customers(customer_id),
              total_amount decimal(10,2), check(total_amount>0));



/*Q5. JOINS
a. List the top 5 countries (by order count) that Classic Models ships to.*/

use classicmodels;
select country,count(orderNumber) 
               from customers 
               inner join orders on customers.customerNumber = orders.customerNumber
			   group by country
               order by count(orderNumber) desc;



/* Q6. SELF JOIN
a. Create a table project with below fields.


●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 
Add data into it.
 
Find out the names of employees and their related managers.*/

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




/*
Q7. DDL Commands: Create, Alter, Rename
a. Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.

*/
create table facility(
             facility_ID int,
             Name varchar(100),
             State varchar(100),
             Country varchar(100));
             
alter table facility modify facility_ID int auto_increment primary key;
alter table facility add column City varchar(100) not null;
describe facility;



/*Q8. Views in SQL
a. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following information:
productLine: The category name of the product (from the ProductLines table).

total_sales: The total revenue generated by products within that category (calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).

number_of_orders: The total number of orders containing products from that category.
*/

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


 
/*Q9. Stored Procedures in SQL with parameters

a. Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
*/
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(in iYear int, in iCountry varchar(100))
BEGIN
select year(payments.paymentDate) as Year, customers.country as Country, 
concat(format(sum(payments.amount)/1000,0),"K") as Total_amount
from payments inner join customers on payments.customerNumber = customers.customerNumber
where year(payments.paymentDate) = iyear and customers.country = icountry
group by Year,Country;

 call Get_country_payments(2003,"France");



 
/*Q10. Window functions - Rank, dense_rank, lead and lag

a) Using customers and orders tables, rank the customers based on their order frequency

*/

select c.customerName,count(o.orderNumber) as order_count, 
      dense_rank() over( order by count(o.orderNUmber) desc) as order_frequency_rnk
from  customers c join orders o
      on c.customerNumber = o.customerNumber  
      group by c.customerName;


      
/*b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.*/

select year(orderDate) as Year,monthname(orderDate) as month,count(ordernumber) as 'Total Orders',  
      concat( round(count(ordernumber)-lag(count(ordernumber))over(order by year(orderDate))) / 
       lag(count(ordernumber))over(order by year(orderDate))*100,"%") as 'Yoy % change' 
from orders group by year(orderdate), monthname(orderdate);



/*Q11.Subqueries and their applications
a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output
as product line and its count.*/

select productLine,count(buyPrice) as Total
         from products
		  where buyPrice>(select avg(buyPrice) from products)
		  group by productLine
          order by count(buyPrice) desc;


        
/*Q12. ERROR HANDLING in SQL
      Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.
*/
create table Emp_EH(
               EmpID int Primary Key,
               EmpName varchar(30),
               EmailAddress VArchar(50));

CREATE DEFINER=`root`@`localhost` PROCEDURE `EmpEntry`(in EmpID int, in EmpName varchar(30),in EmailAddress varchar(50))
BEGIN
declare exit handler for 1048
Begin
select 'Error occurred' as message;
End;
insert into Emp_EH values(EmpID,EmpName,EmailAddress);
END

call EmpEntry(null, 'esha', 'esha@123');



/* Q13. TRIGGERS
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data  
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.*/

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

CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.working_hours<0 then set new.working_hours= -new.working_hours;
end if;
END

insert into Emp_BIT values('Peter','Teacher','2020-10-04',-10);
select*from Emp_BIT;
