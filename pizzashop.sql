-- ======================
-- 1. SCHEMA CREATION
-- ======================

CREATE TABLE Pizzas (
    pizza_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(20),
    size VARCHAR(10),
    price DECIMAL(5,2)
);

CREATE TABLE Sides (
    side_id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(5,2)
);

CREATE TABLE Desserts (
    dessert_id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(5,2)
);

CREATE TABLE Beverages (
    beverage_id INT PRIMARY KEY,
    name VARCHAR(50),
    size VARCHAR(10),
    price DECIMAL(5,2)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY,
    order_id INT,
    item_type VARCHAR(20),
    item_ref_id INT,
    size VARCHAR(10),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- ======================
-- 2. INSERT SAMPLE DATA
-- ======================

-- Pizzas
INSERT INTO Pizzas VALUES (1, 'Margherita', 'Special', 'Regular', 13);
INSERT INTO Pizzas VALUES (2, 'Margherita', 'Special', 'Large', 15);
INSERT INTO Pizzas VALUES (3, 'Diavola', 'Special', 'Regular', 16);
INSERT INTO Pizzas VALUES (4, 'Diavola', 'Special', 'Large', 19);
INSERT INTO Pizzas VALUES (5, 'Parmigiana', 'Special', 'Regular', 15);
INSERT INTO Pizzas VALUES (6, 'Parmigiana', 'Special', 'Large', 18);
INSERT INTO Pizzas VALUES (7, 'Quattro formaggi', 'Special', 'Regular', 16);
INSERT INTO Pizzas VALUES (8, 'Quattro formaggi', 'Special', 'Large', 19);
INSERT INTO Pizzas VALUES (9, 'Napolitana', 'Signature', 'Regular', 16);
INSERT INTO Pizzas VALUES (10, 'Napolitana', 'Signature', 'Large', 18);
INSERT INTO Pizzas VALUES (11, 'Pepperoni', 'Signature', 'Regular', 15);
INSERT INTO Pizzas VALUES (12, 'Pepperoni', 'Signature', 'Large', 17);
INSERT INTO Pizzas VALUES (13, 'Seafood', 'Signature', 'Regular', 17);
INSERT INTO Pizzas VALUES (14, 'Seafood', 'Signature', 'Large', 20);
INSERT INTO Pizzas VALUES (15, 'Hawaiian', 'Signature', 'Regular', 15);
INSERT INTO Pizzas VALUES (16, 'Hawaiian', 'Signature', 'Large', 17);

-- Sides
INSERT INTO Sides VALUES (1, 'Garlic Bread', 6);
INSERT INTO Sides VALUES (2, 'Chicken Wings', 7);
INSERT INTO Sides VALUES (3, 'Breadsticks', 6);
INSERT INTO Sides VALUES (4, 'Caesar Salad', 7);

-- Desserts
INSERT INTO Desserts VALUES (1, 'Ice Cream', 6);
INSERT INTO Desserts VALUES (2, 'Chocolate Brownie', 7);
INSERT INTO Desserts VALUES (3, 'Banoffee Pie', 8);
INSERT INTO Desserts VALUES (4, 'Fruit Salad', 5);

-- Beverages
INSERT INTO Beverages VALUES (1, 'Coca Cola', '33CL', 3);
INSERT INTO Beverages VALUES (2, 'Coca Cola', '1.5L', 6);
INSERT INTO Beverages VALUES (3, '7 Up', '33CL', 3);
INSERT INTO Beverages VALUES (4, '7 Up', '1.5L', 6);
INSERT INTO Beverages VALUES (5, 'Fanta', '33CL', 3);
INSERT INTO Beverages VALUES (6, 'Fanta', '1.5L', 6);
INSERT INTO Beverages VALUES (7, 'Sparkling Water', '33CL', 2);
INSERT INTO Beverages VALUES (8, 'Sparkling Water', '1.5L', 4);

-- Customers
INSERT INTO Customers VALUES (1, 'Alice Johnson', 'alice@email.com', '9876543210');
INSERT INTO Customers VALUES (2, 'Bob Smith', 'bob@email.com', '9876543211');
INSERT INTO Customers VALUES (3, 'Charlie Davis', 'charlie@email.com', '9876543212');

-- Orders
INSERT INTO Orders VALUES (1, 1, '2025-07-05');
INSERT INTO Orders VALUES (2, 2, '2025-07-06');
INSERT INTO Orders VALUES (3, 1, '2025-07-07');
INSERT INTO Orders VALUES (4, 3, '2025-07-08');

-- Order_Items
INSERT INTO Order_Items VALUES (1, 1, 'Pizza', 3, 'Regular', 1);
INSERT INTO Order_Items VALUES (2, 1, 'Beverage', 1, '33CL', 1);
INSERT INTO Order_Items VALUES (3, 2, 'Pizza', 16, 'Large', 1);
INSERT INTO Order_Items VALUES (4, 2, 'Side', 1, NULL, 2);
INSERT INTO Order_Items VALUES (5, 2, 'Beverage', 6, '1.5L', 1);
INSERT INTO Order_Items VALUES (6, 3, 'Dessert', 2, NULL, 1);
INSERT INTO Order_Items VALUES (7, 3, 'Beverage', 7, '33CL', 1);
INSERT INTO Order_Items VALUES (8, 4, 'Pizza', 14, 'Large', 1);
INSERT INTO Order_Items VALUES (9, 4, 'Side', 3, NULL, 1);

-- ======================
-- 3. ANALYTICAL QUERIES
-- ======================

-- Total Revenue
SELECT 
    SUM(CASE 
            WHEN item_type = 'Pizza' THEN P.price * OI.quantity
            WHEN item_type = 'Side' THEN S.price * OI.quantity
            WHEN item_type = 'Dessert' THEN D.price * OI.quantity
            WHEN item_type = 'Beverage' THEN B.price * OI.quantity
        END) AS total_revenue
FROM Order_Items OI
LEFT JOIN Pizzas P ON OI.item_type = 'Pizza' AND OI.item_ref_id = P.pizza_id
LEFT JOIN Sides S ON OI.item_type = 'Side' AND OI.item_ref_id = S.side_id
LEFT JOIN Desserts D ON OI.item_type = 'Dessert' AND OI.item_ref_id = D.dessert_id
LEFT JOIN Beverages B ON OI.item_type = 'Beverage' AND OI.item_ref_id = B.beverage_id;

-- Most Popular Item
SELECT 
    item_type,
    item_ref_id,
    SUM(quantity) AS total_sold
FROM Order_Items
GROUP BY item_type, item_ref_id
ORDER BY total_sold DESC
LIMIT 1;

-- Orders by Customer
SELECT 
    C.name,
    COUNT(DISTINCT O.order_id) AS total_orders,
    SUM(CASE 
            WHEN item_type = 'Pizza' THEN P.price * OI.quantity
            WHEN item_type = 'Side' THEN S.price * OI.quantity
            WHEN item_type = 'Dessert' THEN D.price * OI.quantity
            WHEN item_type = 'Beverage' THEN B.price * OI.quantity
        END) AS total_spent
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
JOIN Order_Items OI ON O.order_id = OI.order_id
LEFT JOIN Pizzas P ON OI.item_type = 'Pizza' AND OI.item_ref_id = P.pizza_id
LEFT JOIN Sides S ON OI.item_type = 'Side' AND OI.item_ref_id = S.side_id
LEFT JOIN Desserts D ON OI.item_type = 'Dessert' AND OI.item_ref_id = D.dessert_id
LEFT JOIN Beverages B ON OI.item_type = 'Beverage' AND OI.item_ref_id = B.beverage_id
GROUP BY C.name;

-- Daily Sales Summary
SELECT 
    order_date,
    COUNT(DISTINCT O.order_id) AS total_orders,
    SUM(CASE 
            WHEN item_type = 'Pizza' THEN P.price * OI.quantity
            WHEN item_type = 'Side' THEN S.price * OI.quantity
            WHEN item_type = 'Dessert' THEN D.price * OI.quantity
            WHEN item_type = 'Beverage' THEN B.price * OI.quantity
        END) AS daily_revenue
FROM Orders O
JOIN Order_Items OI ON O.order_id = OI.order_id
LEFT JOIN Pizzas P ON OI.item_type = 'Pizza' AND OI.item_ref_id = P.pizza_id
LEFT JOIN Sides S ON OI.item_type = 'Side' AND OI.item_ref_id = S.side_id
LEFT JOIN Desserts D ON OI.item_type = 'Dessert' AND OI.item_ref_id = D.dessert_id
LEFT JOIN Beverages B ON OI.item_type = 'Beverage' AND OI.item_ref_id = B.beverage_id
GROUP BY order_date
ORDER BY order_date;

-- Top 3 Best-Selling Pizzas
SELECT 
    P.name,
    P.size,
    SUM(OI.quantity) AS total_sold
FROM Order_Items OI
JOIN Pizzas P ON OI.item_type = 'Pizza' AND OI.item_ref_id = P.pizza_id
GROUP BY P.name, P.size
ORDER BY total_sold DESC
LIMIT 3
