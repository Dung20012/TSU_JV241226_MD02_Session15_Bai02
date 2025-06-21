# Truy vấn cơ bản
-- 1. Liệt kê tất cả người dùng
SELECT * FROM User;
-- 2. Liệt kê tên và giá của tất cả sản phẩm
SELECT name, price FROM Product;
-- 3. Liệt kê tên danh mục và mô tả 
SELECT name, description FROM Category;
-- 4. Liệt kê mã sản phẩm, tên và số lượng tồn kho
SELECT product_id, name, stock FROM Product;
-- 5. Liệt kê đơn hàng gồm order_id, user_id, total_amount
SELECT order_id, user_id, total_amount FROM `Order`;
-- 6. Liệt kê các bản ghi trong bảng Order_Detail
SELECT * FROM Order_Detail;

# Truy vấn có điều kiện
-- 1. Người dùng có email kết thúc bằng '@gmail.com'
SELECT * FROM User
WHERE email LIKE '%@gmail.com';
-- 2. Sản phẩm có giá > 1 triệu
SELECT * FROM Product
WHERE price > 1000000;
-- 3. Đơn hàng có tổng tiền > 5 triệu
SELECT * FROM `Order`
WHERE total_amount > 5000000;
-- 4. Sản phẩm còn hàng
SELECT * FROM Product
WHERE stock > 0;
-- 5. Đơn hàng tạo sau ngày 2024-06-05
SELECT * FROM `Order`
WHERE created_at > '2024-06-05';
-- 6. Danh mục có tên là “Sách”
SELECT * FROM Category
WHERE name = 'Sách';

# Truy vấn có nhóm dữ liệu (group by)
-- 1. Đếm số sản phẩm thuộc mỗi danh mục
SELECT category_id, COUNT(*) AS so_luong_san_pham
FROM Product
GROUP BY category_id;
-- 2. Tổng số lượng tồn kho theo từng danh mục
SELECT category_id, SUM(stock) AS tong_ton_kho
FROM Product
GROUP BY category_id;
-- 3. Tổng tiền mỗi người đã đặt (theo user_id)
SELECT user_id, SUM(total_amount) AS tong_tien_dat
FROM `Order`
GROUP BY user_id;
-- 4. Số lượng đơn hàng của mỗi người dùng
SELECT user_id, COUNT(*) AS so_luong_don_hang
FROM `Order`
GROUP BY user_id;
-- 5. Số lượng sản phẩm khác nhau trong từng đơn hàng
SELECT order_id, COUNT(product_id) AS so_san_pham_khac_nhau
FROM Order_Detail
GROUP BY order_id;
-- 6. Người dùng có tổng tiền đơn hàng > 10 triệu
SELECT user_id, SUM(total_amount) AS tong_tien
FROM `Order`
GROUP BY user_id
HAVING tong_tien > 10000000;
-- 7. Danh mục có tổng số sản phẩm tồn kho > 100
SELECT category_id, SUM(stock) AS tong_ton_kho
FROM Product
GROUP BY category_id
HAVING tong_ton_kho > 100;
-- 8. Đơn hàng có hơn 2 loại sản phẩm
SELECT order_id, COUNT(product_id) AS so_loai_sp
FROM Order_Detail
GROUP BY order_id
HAVING so_loai_sp > 2;
-- 9. Người dùng có hơn 1 đơn hàng
SELECT user_id, COUNT(*) AS so_don
FROM `Order`
GROUP BY user_id
HAVING so_don > 1;

# Truy vấn sử dụng đầy đủ các mệnh đề
-- 1. 5 sản phẩm có giá cao nhất
SELECT * FROM Product
ORDER BY price DESC
LIMIT 5;
-- 2. Tên sản phẩm và giá, sắp xếp theo price tăng dần
SELECT name, price FROM Product
ORDER BY price ASC;
-- 3. Tất cả đơn hàng + cột VAT = 10% tổng tiền
SELECT order_id, user_id, total_amount, 
       total_amount * 0.1 AS VAT
FROM `Order`;

# Truy vấn lồng
-- 1. Sản phẩm có giá cao hơn giá trung bình
SELECT * FROM Product
WHERE price > (
    SELECT AVG(price) FROM Product
);

-- 2. Người dùng đã từng đặt ít nhất 1 đơn hàng
SELECT * FROM User
WHERE user_id IN (
    SELECT DISTINCT user_id FROM `Order`
);

-- 3. Tên sản phẩm xuất hiện trong đơn hàng có tổng tiền > 20 triệu
SELECT DISTINCT P.name
FROM Product P
JOIN Order_Detail OD ON P.product_id = OD.product_id
WHERE OD.order_id IN (
    SELECT order_id FROM `Order`
    WHERE total_amount > 20000000
);

-- 4. Đơn hàng chứa sản phẩm thuộc danh mục “Điện tử”
SELECT DISTINCT O.*
FROM `Order` O
JOIN Order_Detail OD ON O.order_id = OD.order_id
JOIN Product P ON OD.product_id = P.product_id
JOIN Category C ON P.category_id = C.category_id
WHERE C.name = 'Điện tử';
