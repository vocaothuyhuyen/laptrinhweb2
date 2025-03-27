USE BKE;
GO
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
GO

-- 1. Liệt kê các hóa đơn của khách hàng
SELECT o.user_id, u.user_name, o.order_id 
FROM orders o
JOIN users u ON o.user_id = u.user_id;
GO

-- 2. Liệt kê số lượng các hóa đơn của khách hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name;
GO

-- 3. Liệt kê thông tin hóa đơn
SELECT o.order_id, u.user_name, COUNT(od.product_id) AS total_products
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, u.user_name;
GO


-- 4. Liệt kê thông tin mua hàng của người dùng
SELECT o.user_id, u.user_name, o.order_id, STRING_AGG(p.product_name, ', ') AS product_names
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY o.user_id, o.order_id;
GO

-- 5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất
SELECT TOP 7 u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_orders DESC;
GO

-- 6. Liệt kê 7 người dùng mua sản phẩm có tên "Samsung" hoặc "Apple"
SELECT DISTINCT TOP 7 u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%';
GO

-- 7. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS total_price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY u.user_id, u.user_name, o.order_id;
GO


-- 8. Mỗi user chỉ chọn ra 1 đơn hàng có giá tiền lớn nhất
SELECT user_id, user_name, order_id, total_price
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS total_price,
           RANK() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) DESC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) ranked_orders
WHERE rnk = 1;
GO


-- 9. Mỗi user chỉ chọn ra 1 đơn hàng có giá tiền nhỏ nhất
SELECT user_id, user_name, order_id, total_price, total_products
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS total_price, COUNT(od.product_id) AS total_products,
           RANK() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) ASC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) ranked_orders
WHERE rnk = 1;
GO


-- 10. Mỗi user chỉ chọn ra 1 đơn hàng có số sản phẩm lớn nhất
SELECT user_id, user_name, order_id, total_price, total_products
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS total_price, COUNT(od.product_id) AS total_products,
           RANK() OVER (PARTITION BY u.user_id ORDER BY COUNT(od.product_id) DESC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) ranked_orders
WHERE rnk = 1;
GO
