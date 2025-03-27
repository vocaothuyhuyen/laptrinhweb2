USE BKE;
GO
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
GO

-- 1. Lấy danh sách người dùng theo thứ tự tên Alphabet (A->Z)
SELECT * FROM users ORDER BY user_name ASC;
GO

-- 2. Lấy 07 người dùng theo thứ tự tên Alphabet (A->Z)
SELECT TOP 7 * FROM users ORDER BY user_name ASC;
GO

-- 3. Lấy danh sách người dùng theo thứ tự tên Alphabet (A->Z), trong đó tên có chữ 'a'
SELECT * FROM users WHERE user_name LIKE '%a%' ORDER BY user_name ASC;
GO

-- 4. Lấy danh sách người dùng có tên bắt đầu bằng chữ 'm'
SELECT * FROM users WHERE user_name LIKE 'm%';
GO

-- 5. Lấy danh sách người dùng có tên kết thúc bằng chữ 'i'
SELECT * FROM users WHERE user_name LIKE '%i';
GO

-- 6. Lấy danh sách người dùng có email là Gmail
SELECT * FROM users WHERE user_email LIKE '%@gmail.com';
GO

-- 7. Lấy danh sách người dùng có email là Gmail, tên bắt đầu bằng 'm'
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE 'm%';
GO

-- 8. Lấy danh sách người dùng có email là Gmail, tên có chữ 'i' và độ dài > 5
SELECT * FROM users WHERE user_email LIKE '%@gmail.com' AND user_name LIKE '%i%' AND LEN(user_name) > 5;
GO

-- 9. Lấy danh sách người dùng có tên chứa 'a', chiều dài từ 5-9, email Gmail, tên email chứa 'I'
SELECT * FROM users WHERE user_name LIKE '%a%' AND LEN(user_name) BETWEEN 5 AND 9 AND user_email LIKE '%@gmail.com' AND user_email LIKE '%I%@%';
GO

-- 10. Lấy danh sách người dùng theo điều kiện phức hợp
SELECT * FROM users WHERE 
  (user_name LIKE '%a%' AND LEN(user_name) BETWEEN 5 AND 9) 
  OR (user_name LIKE '%i%' AND LEN(user_name) < 9) 
  OR (user_email LIKE '%@gmail.com' AND user_email LIKE '%i%@%');
GO
