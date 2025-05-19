create database TechNova;
use TechNova;

create table Customers (
Customer_id INT PRIMARY KEY,
Namee VARCHAR (30),
Email VARCHAR (30),
Location VARCHAR (10)
);

INSERT INTO Customers (Customer_id, Namee, Email, Location)
Values (1, 'John Doe', 'john@example.com', 'Lagos'),
(2, 'Jane Smith', 'jane@example.com', 'Abuja'),
(3, 'Aliyu Musa', 'aliyu@example.com', 'Kano'),
(4, 'Ngozi Okeke', 'ngozi@example.com', 'Enugu'),
(5, 'Bola Ige', 'bola@example.com', 'Ibadan'),
(6, 'Aisha Bello', 'aisha@example.com', 'Ilorin'),
(7, 'Mike Adenuga', 'mikea@example.com', 'Lagos'),
(8, 'Femi Johnson', 'femi@example.com', 'Lagos'),
(9, 'Zainab Umar', 'zainab@example.com', 'Kaduna'),
(10, 'Kelechi Nwosu', 'kelechi@example.com', 'Owerri');

create table Campaigns_Table (
Campaign_ID INT PRIMARY KEY,
Campaign_Name varchar (30),
Platform VARCHAR (30),
Budget INT
);

insert into Campaigns_Table (Campaign_ID, Campaign_Name, Platform, Budget)
VALUES (101, 'Tech Awareness', 'Instagram', '50000'),
(102, 'Holiday Blast', 'Facebook', '70000'),
(103, 'New Launch', 'Google Ads', '60000'),
(104, 'Flash Friday', 'Twitter', '45000'),
(105, 'Mega Gadget Sale', 'Facebook', '90000'),
(106, 'Year End Sale', 'Instagram', '55000'),
(107, 'Buy Now Campaign', 'Google Ads', '65000'),
(108, 'Weekend Promo', 'Facebook', '30000'),
(109, 'Gadget Season', 'Twitter', '85000'),
(110, 'Digital Promo Push', 'Instagram', '40000');
;

create table Products (
Product_ID INT PRIMARY KEY,
Product_Name VARCHAR (30),
Category VARCHAR (30),
Price int
);

insert into Products (Product_ID, Product_Name, Category, Price)
VALUES (201, 'SmartWatch Pro', 'Wearable', 45000),
(202, 'TechTab X', 'Tablet', 120000),
(203, 'PhoneMax 12', 'Smartphone', 220000),
(204, 'EarBuds Neo', 'Accessory', 25000),
(205, 'PowerBank 20k', 'Accessory', 18000),
(206, 'TechCam 360', 'Accessory', 35000),
(207, 'GadgetGo Pro', 'Tablet', 115000),
(208, 'Smartwatch Mini', 'Wearable', 40000),
(209, 'PhonePlus Ultra', 'Smartphone', 250000),
(210, 'Speaker BoomBox', 'Accessory', 30000);
;
create table Sales (
Sales_ID INT PRIMARY KEY,
Customer_ID INT,
FOREIGN KEY (Customer_ID) REFERENCES customers(Customer_ID),
Campaign_ID INT,
FOREIGN KEY (Campaign_ID) REFERENCES Campaigns_Table(Campaign_ID),
Product_ID INT,
FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
Quantity INT, 
Sale_Date Date
);

insert into Sales (Sales_ID, Customer_id, Campaign_ID, Product_ID, Quantity, Sale_Date)
values (301, 1, 101, 201, 1, '2023-11-01'),
(302, 2, 102, 202, 2, '2024-01-12'),
(303, 3, 103, 203, 1, '2024-05-18'),
(304, 4, 104, 204, 1, '2023-12-10'),
(305, 5, 105, 205, 1, '2024-02-09'),
(306, 6, 106, 206, 2, '2024-03-21'),
(307, 7, 107, 207, 1, '2024-06-13'),
(308, 8, 108, 208, 1, '2024-07-28'),
(309, 9, 109, 209, 1, '2024-08-05'),
(310, 10, 110, 210, 1, '2024-09-14')
;

select *
from products;

SELECT *
FROM Sales;

-- WHICH CUSTOMERS MADE THE HIGHEST PURCHASES?
select Customers.Customer_ID AS CID , customers.Namee AS Namee,
SUM(Sales.Quantity) AS Total_Products_Purchased
from Sales
join Customers on Customers.Customer_id = Sales.Customer_id
group by CID, Namee
order by Total_Products_Purchased DESC;

-- TOTAL REVENUE GENERATED FROM EACH CAMPAIGN
select Sales.Sales_ID, Sales.campaign_id,
sum(products.price * sales.quantity) AS Total_Revenue
from sales
join campaigns_table on sales.Campaign_ID = campaigns_table.Campaign_ID
join products on sales.Product_ID = products.Product_ID
group by Sales_ID, Campaign_ID
order by Total_Revenue DESC;

-- LIST OF CUSTOMERS AND WHAT THEY PURCHASED
select customers.Customer_id AS C_ID, customers.Namee AS C_Name, products.Product_ID, products.Product_Name
from sales
join customers on sales.Customer_ID = customers.Customer_id
join products on sales.Product_ID = products.Product_ID
order by C_ID;

-- Campaign that led to the highest number of sales transaction
select campaigns_table.Campaign_ID AS C_ID, campaigns_table.Campaign_Name AS C_Name,
	count(sales.Quantity)  AS Sales_Transactions
from sales 
join campaigns_table on sales.Campaign_ID = campaigns_table.Campaign_ID
group by C_ID, C_Name
order by Sales_Transactions DESC
LIMIT 1;

-- Top 3 most sold product categories
select products.Category,  SUM(sales.Quantity) AS Total_Quantity_Sold
from sales 
join products on sales.Product_ID = products.Product_ID
group by products.Category
order by Total_Quantity_Sold DESC
limit 3;

-- Total quantity of products sold by each customer location
SELECT customers.Location, SUM(sales.Quantity) AS Total_Quantity_Sold
FROM Sales
JOIN Customers ON sales.Customer_id = customers.Customer_id
GROUP BY customers.Location
ORDER BY Total_Quantity_Sold DESC;

SELECT 
    campaigns_table.Platform,
    COUNT(Sales.Sales_ID) AS Total_Sales_Transactions,
    SUM(Sales.Quantity) AS Total_Quantity_Sold,
    SUM(Sales.Quantity * products.Price) AS Total_Revenue
FROM 
    Sales
JOIN 
    Campaigns_Table ON Sales.Campaign_ID = campaigns_table.Campaign_ID
JOIN 
    Products ON Sales.Product_ID = products.Product_ID
GROUP BY 
    campaigns_table.Platform
ORDER BY 
    Total_Revenue DESC;

-- Analysis of the effectiveness of didital marketing campaigns ran by TechNova across all platforms
  SELECT Campaigns_table.Campaign_ID, Campaigns_table.Platform, Campaigns_table.Campaign_Name,
    COUNT(Sales.Sales_ID) AS Total_Transactions,
    SUM(Sales.Quantity) AS Total_QuantitySold,
    SUM(Products.Price * Sales.Quantity) AS Total_Rev, Campaigns_table.Budget,
    ROUND(SUM(Products.Price * Sales.Quantity) - Campaigns_table.Budget, 2) AS Profit,
    ROUND(((SUM(Products.Price * Sales.Quantity) - Campaigns_table.Budget) / Campaigns_table.Budget) * 100, 2) AS ROI_Percentage
    FROM Sales 
JOIN Campaigns_table ON Sales.Campaign_ID = Campaigns_table.Campaign_ID
JOIN Products ON Sales.Product_ID = Products.Product_ID
GROUP BY campaigns_table.Campaign_ID, campaigns_table.Platform, campaigns_table.Campaign_Name, campaigns_table.Budget
ORDER BY Total_Rev DESC;
