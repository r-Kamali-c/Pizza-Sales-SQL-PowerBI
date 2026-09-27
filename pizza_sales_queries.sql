SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Net_Revenue) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value
FROM
(
    SELECT
        oi.Order_ID,

        (oi.Quantity * oi.Unit_Price)
        - ((oi.Quantity * oi.Unit_Price) * oi.Discount)
            AS Net_Revenue,

        (
            (oi.Quantity * oi.Unit_Price)
            - ((oi.Quantity * oi.Unit_Price) * oi.Discount)
            - (oi.Quantity * p.Unit_Cost)
        ) AS Profit

    FROM order_items_clean oi

    JOIN products_clean p
        ON oi.Product_ID = p.Product_ID
) AS sales_data;


SELECT
    o.Customer_ID,
    ROUND(SUM(
        (oi.Quantity * oi.Unit_Price)
        - ((oi.Quantity * oi.Unit_Price) * oi.Discount)
        - (oi.Quantity * p.Unit_Cost)
    ), 2) AS Total_Profit
FROM order_items_clean oi
JOIN orders_clean o
    ON oi.Order_ID = o.Order_ID
JOIN products_clean p
    ON oi.Product_ID = p.Product_ID
GROUP BY o.Customer_ID
ORDER BY Total_Profit DESC
LIMIT 10;

-- mounthly revenue
SELECT
    MONTH(o.Order_Date) AS Month_Number,
    MONTHNAME(o.Order_Date) AS Month,
    ROUND(SUM(
        (oi.Quantity * oi.Unit_Price)
        - ((oi.Quantity * oi.Unit_Price) * oi.Discount)
    ), 2) AS Revenue,
    COUNT(DISTINCT o.Order_ID) AS Orders
FROM order_items_clean oi

JOIN orders_clean o
    ON oi.Order_ID = o.Order_ID

GROUP BY
    MONTH(o.Order_Date),
    MONTHNAME(o.Order_Date)

ORDER BY
    Month_Number;
    

-- Step 7: Category-wise Revenue and Profit
SELECT p.Category,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)-(oi.Quantity*p.Unit_Cost)),2) AS Profit
FROM order_items_clean oi
JOIN orders_clean o ON oi.Order_ID=o.Order_ID
JOIN products_clean p ON oi.Product_ID=p.Product_ID
GROUP BY p.Category
ORDER BY Revenue DESC;

-- Step 8: Product-wise Revenue and Profit
SELECT p.Product_ID,p.Product_Name,p.Category,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)-(oi.Quantity*p.Unit_Cost)),2) AS Profit
FROM order_items_clean oi
JOIN products_clean p ON oi.Product_ID=p.Product_ID
GROUP BY p.Product_ID,p.Product_Name,p.Category
ORDER BY Profit DESC
LIMIT 10;

-- Step 8: Product-wise Revenue and Profit
SELECT p.Product_ID,p.Product_Name,p.Category,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)-(oi.Quantity*p.Unit_Cost)),2) AS Profit
FROM order_items_clean oi
JOIN products_clean p ON oi.Product_ID=p.Product_ID
GROUP BY p.Product_ID,p.Product_Name,p.Category
ORDER BY Profit DESC
LIMIT 10;

-- Step 9: Payment Method Analysis
SELECT o.Payment_Method,
COUNT(DISTINCT o.Order_ID) AS Orders,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue
FROM orders_clean o
JOIN order_items_clean oi ON o.Order_ID=oi.Order_ID
GROUP BY o.Payment_Method
ORDER BY Revenue DESC;

-- Step 10: Customer Segment Analysis
SELECT c.Customer_Segment,
COUNT(DISTINCT c.Customer_ID) AS Customers,
COUNT(DISTINCT o.Order_ID) AS Orders,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID=o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID=oi.Order_ID
GROUP BY c.Customer_Segment
ORDER BY Revenue DESC;

-- Step 11: Acquisition Channel Analysis
SELECT c.Acquisition_Channel,
COUNT(DISTINCT c.Customer_ID) AS Customers,
COUNT(DISTINCT o.Order_ID) AS Orders,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID=o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID=oi.Order_ID
GROUP BY c.Acquisition_Channel
ORDER BY Revenue DESC;

-- Step 12: Order Status Analysis
SELECT o.Order_Status,
COUNT(DISTINCT o.Order_ID) AS Orders,
ROUND(SUM((oi.Quantity*oi.Unit_Price)-((oi.Quantity*oi.Unit_Price)*oi.Discount)),2) AS Revenue
FROM orders_clean o
JOIN order_items_clean oi ON o.Order_ID=oi.Order_ID
GROUP BY o.Order_Status
ORDER BY Orders DESC;

-- Step 13: Marketing Campaign Analysis
SELECT Campaign_Type,
COUNT(*) AS Campaigns,
SUM(Sent) AS Sent,
SUM(Opened) AS Opened,
SUM(Clicked) AS Clicked,
SUM(Converted) AS Converted,
ROUND(SUM(Campaign_Cost),2) AS Cost
FROM marketing_clean
GROUP BY Campaign_Type
ORDER BY Converted DESC;

SELECT * FROM customers_clean LIMIT 10;
SELECT * FROM orders_clean LIMIT 10;

SELECT COUNT(*) AS Total_Customers
FROM customers_clean;

SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders_clean
WHERE Order_Status = 'Delivered';

SELECT SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Total_Revenue
FROM order_items_clean oi
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered';

SELECT SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Total_Profit
FROM order_items_clean oi
JOIN products_clean p ON oi.Product_ID = p.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered';

SELECT ROUND(SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) / COUNT(DISTINCT o.Order_ID),2) AS Average_Order_Value
FROM order_items_clean oi
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered';

SELECT DATE_FORMAT(o.Order_Date,'%Y-%m') AS Month,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM orders_clean o
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY DATE_FORMAT(o.Order_Date,'%Y-%m')
ORDER BY Month;

SELECT DATE_FORMAT(Order_Date,'%Y-%m') AS Month,
COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders_clean
WHERE Order_Status = 'Delivered'
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m')
ORDER BY Month;

SELECT c.State,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.State
ORDER BY Revenue DESC;

SELECT c.State,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
JOIN products_clean p ON oi.Product_ID = p.Product_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.State
ORDER BY Profit DESC;

SELECT p.Category,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM products_clean p
JOIN order_items_clean oi ON p.Product_ID = oi.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY p.Category
ORDER BY Revenue DESC;

SELECT p.Category,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM products_clean p
JOIN order_items_clean oi ON p.Product_ID = oi.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY p.Category
ORDER BY Profit DESC;

SELECT p.Category,
ROUND(
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost))
/
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) * 100,2
) AS Profit_Margin
FROM products_clean p
JOIN order_items_clean oi ON p.Product_ID = oi.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY p.Category
ORDER BY Profit_Margin DESC;

SELECT c.Customer_ID,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_ID
ORDER BY Revenue DESC
LIMIT 10;

SELECT c.Customer_ID,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
JOIN products_clean p ON oi.Product_ID = p.Product_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_ID
ORDER BY Profit DESC
LIMIT 10;

SELECT c.Customer_Segment,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_Segment
ORDER BY Revenue DESC;



SELECT c.Customer_Segment,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
JOIN products_clean p ON oi.Product_ID = p.Product_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_Segment
ORDER BY Profit DESC;

SELECT COUNT(*) AS Repeat_Customers
FROM (
SELECT Customer_ID
FROM orders_clean
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID) > 1
) AS repeat_customers;


SELECT COUNT(*) AS One_Time_Customers
FROM (
SELECT Customer_ID
FROM orders_clean
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID) = 1
) AS one_time_customers;

SELECT ROUND(
SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100,2
) AS Repeat_Purchase_Rate
FROM (
SELECT Customer_ID,
COUNT(DISTINCT Order_ID) AS Order_Count
FROM orders_clean
WHERE Order_Status = 'Delivered'
GROUP BY Customer_ID
) AS customer_orders;

SELECT c.Acquisition_Channel,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Acquisition_Channel
ORDER BY Revenue DESC;

SELECT p.Product_ID,
p.Product_Name,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM products_clean p
JOIN order_items_clean oi ON p.Product_ID = oi.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY p.Product_ID,p.Product_Name
ORDER BY Profit
LIMIT 10;

 SELECT Campaign_Type,
SUM(Sent) AS Sent,
SUM(Opened) AS Opened,
SUM(Clicked) AS Clicked,
SUM(Converted) AS Converted,
ROUND(SUM(Opened) / NULLIF(SUM(Sent),0) * 100,2) AS Open_Rate,
ROUND(SUM(Clicked) / NULLIF(SUM(Sent),0) * 100,2) AS Click_Through_Rate,
ROUND(SUM(Converted) / NULLIF(SUM(Sent),0) * 100,2) AS Conversion_Rate
FROM marketing_clean
GROUP BY Campaign_Type
ORDER BY Conversion_Rate DESC;

SELECT c.Customer_ID,
c.Customer_Name,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Customer_Lifetime_Value
FROM customers_clean c
JOIN orders_clean o ON c.Customer_ID = o.Customer_ID
JOIN order_items_clean oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.Customer_ID,c.Customer_Name
ORDER BY Customer_Lifetime_Value DESC;

SELECT ROUND(oi.Discount,0) AS Discount_Percentage,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) AS Revenue,
SUM((oi.Quantity * oi.Unit_Price * (1 - oi.Discount / 100)) - (oi.Quantity * p.Unit_Cost)) AS Profit
FROM order_items_clean oi
JOIN products_clean p ON oi.Product_ID = p.Product_ID
JOIN orders_clean o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY ROUND(oi.Discount,0)
ORDER BY Discount_Percentage;


