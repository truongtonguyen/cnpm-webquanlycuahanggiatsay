CREATE DATABASE IF NOT EXISTS qanlycuahanggs;
USE quanlycuahanggs;

CREATE TABLE KhachHang (
    MaKH VARCHAR(50) PRIMARY KEY,
    TenKH VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    DiaChi VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    SDT_KH VARCHAR(15),
    EmailKH VARCHAR(100)
);

CREATE TABLE DichVu (
    MaDichVu VARCHAR(10) PRIMARY KEY,
    TenDichVu VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    DonGia DECIMAL(18,2)
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    GioiTinh VARCHAR(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    NgaySinh DATE,
    SDT_NV VARCHAR(15)
);

CREATE TABLE CaTruc (
    STT INT PRIMARY KEY,
    TGBatDau TIME,
    TGKetThuc TIME,
    TenCa VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
);

CREATE TABLE Truc (
    MaNV VARCHAR(10),
    STT INT,
    NgayTruc DATE,
    PRIMARY KEY (MaNV, STT, NgayTruc),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (STT) REFERENCES CaTruc(STT)
);

CREATE TABLE NhaCungCap (
    MaNCC VARCHAR(10) PRIMARY KEY,
    TenNCC VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    DiaChiNCC VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    SDT_NCC VARCHAR(15)
);

CREATE TABLE PhanQuyen (
    MaPQ VARCHAR(10) PRIMARY KEY,
    TenPQ VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
);

CREATE TABLE TaiKhoan (
    MaTK VARCHAR(50) PRIMARY KEY,
    TenTK VARCHAR(50),
    MatKhau VARCHAR(50),
    MaPQ VARCHAR(10),
    MaNV VARCHAR(10),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaPQ) REFERENCES PhanQuyen(MaPQ)
);

DROP TABLE IF EXISTS ChiTietDonDat;
DROP TABLE IF EXISTS HoaDon;
DROP TABLE IF EXISTS DonDat;
CREATE TABLE DonDat (
    MaDonDat VARCHAR(10) PRIMARY KEY,
    TenKH VARCHAR(100),
    SDT_KH VARCHAR(15),
    NgayDat DATE,
    MaDichVu VARCHAR(10),
    GhiChu TEXT,
    TrangThai VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    MaKH VARCHAR(10),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);

SELECT * FROM DonDat WHERE TrangThai = 'Chưa xử lý';

CREATE TABLE ChiTietDonDat (
    MaDonDat VARCHAR(10),
    MaDichVu VARCHAR(10),
    DonGia DECIMAL(10,2),
    SoLuong INT,
    ThanhTien DECIMAL(18,2) GENERATED ALWAYS AS (SoLuong * DonGia) STORED,
    DonViTinh VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    PRIMARY KEY (MaDonDat, MaDichVu),
    FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);
SELECT MaDonDat, TenKH, SDT_KH, NgayDat, MaDichVu, GhiChu, TrangThai, MaKH
FROM DonDat
WHERE TrangThai = 'Chưa xử lý';

CREATE TABLE HoaDon (
    MaHD INT PRIMARY KEY AUTO_INCREMENT,
    NgayLap DATE,
    MaDonDat VARCHAR(10) UNIQUE,
    SoLuong INT,
    TrangThai VARCHAR(50),
    FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat)
);

CREATE TABLE NguyenVatLieu (
    MaNVL INT PRIMARY KEY,
    TenNVL VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    Giặtien DECIMAL(18,2)
);

CREATE TABLE PhieuNhap (
    MaPN INT PRIMARY KEY AUTO_INCREMENT,
    NgayNhap DATE,
    DotNhap VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    MaNV VARCHAR(10),
    MaNCC VARCHAR(10),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

CREATE TABLE ChiTietPhieuNhap (
    MaPN INT,
    MaNVL INT,
    SoLuongNhap INT,
    PRIMARY KEY (MaPN, MaNVL),
    FOREIGN KEY (MaPN) REFERENCES PhieuNhap(MaPN),
    FOREIGN KEY (MaNVL) REFERENCES NguyenVatLieu(MaNVL)
);


INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SDT_KH, EmailKH) VALUES
('KH01', 'Nguyen Van A', '123 Le Loi, Q1', '0909123456', 'a.nguyen@gmail.com'),
('KH02', 'Tran Thi B', '456 Tran Hung Dao, Q5', '0911223344', 'b.tran@yahoo.com'),
('KH03', 'Le Van C', '789 Nguyen Hue, Q3', '0933445566', 'c.le@outlook.com');

INSERT INTO DichVu (MaDichVu, TenDichVu, DonGia) VALUES
('DV01', 'Giặt sấy nhanh', 17000),
('DV02', 'Giặt gấu bông', 40000),
('DV03', 'Giặt sấy chăn mền', 20000),
('DV04', 'Giặt sấy rèm - Màn cửa', 25000),
('DV05', 'Giặt hấp quần áo', 45000),
('DV06', 'Vệ sinh túi xách', 40000),
('DV07', 'Giặt sấy Drap', 20000),
('DV08', 'Vệ sinh thảm', 100000),
('DV09', 'Vệ sinh sofa', 100000),
('DV10', 'Vệ sinh giày ', 80000),
('DV11', 'Vệ sinh mũ bảo hiểm', 20000),
('DV12', 'Vệ sinh vali', 100000);

INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, NgaySinh, SDT_NV) VALUES
('NV01', 'Pham Van D', 'Nu', '1995-03-15', '0901234567'),
('NV02', 'Ngo Thi E', 'Nu', '1998-08-22', '0912345678'),
('NV03', 'Lam Thanh T', 'Nu', '1998-06-12', '07888838973');

INSERT INTO CaTruc (STT, TGBatDau, TGKetThuc, TenCa) VALUES
(1, '07:00:00', '11:00:00', 'Ca sáng'),
(2, '13:00:00', '17:00:00', 'Ca chiều'),
(3, '18:00:00', '22:00:00', 'Ca tối');

INSERT INTO Truc (MaNV, STT, NgayTruc) VALUES
('NV02', 1, '2025-07-18'),
('NV02', 2, '2025-07-19'),
('NV03', 3, '2025-07-18');

INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChiNCC, SDT_NCC) VALUES
('NCC01', 'Tiem Bot Giặt ABC', '12 Nguyen Trai, Q1', '02839451234'),
('NCC02', 'Tiem Hoa chat XYZ', '88 Ly Thuong Kiet, Q10', '02839784567');

INSERT INTO PhanQuyen (MaPQ, TenPQ) VALUES
('PQ01', 'Admin'),
('PQ02', 'Nhan vien');

INSERT INTO TaiKhoan (MaTK, TenTK, MatKhau, MaPQ, MaNV) VALUES
('TK01', 'Admin', 'admin123', 'PQ01', 'NV01'),
('TK02', 'nv2', '123456', 'PQ02', 'NV02'),
('TK03', 'nv3', '123456', 'PQ02', 'NV03');

INSERT INTO DonDat (MaDonDat, TenKH, SDT_KH, NgayDat, MaDichVu, GhiChu, TrangThai, MaKH) VALUES 
('DD01', 'Lam Van C', '0909999999', '2025-07-12', 'DV04', 'Giặt', 'Chưa xử lý', 'KH03'),
('DD02', 'Tran Thi H', '0909999999', '2025-07-4', 'DV06', 'Giặt', 'Chưa xử lý', 'KH01'),
('DD03', 'Lam Thi V', '0909999999', '2025-07-14', 'DV09', 'Giặt gap', 'Chưa xử lý', 'KH02'),
('DD05', 'Nguyen Van B', '0909999999', '2025-07-21', 'DV01', 'Giặt gap', 'Chưa xử lý', 'KH01');

SELECT * FROM DonDat ORDER BY NgayDat DESC;


INSERT INTO ChiTietDonDat (MaDonDat, MaDichVu, DonGia, SoLuong, DonViTinh) VALUES
('DD01', 'DV04', 20000, 3, 'kg'),
('DD05', 'DV01', 17000, 1, 'kg'),
('DD02', 'DV06', 40000, 2, 'Cái'),
('DD03', 'DV09', 20000, 5, 'Chiếc');

INSERT INTO HoaDon (MaDonDat, SoLuong, TrangThai)VALUES 
  ('DD01', 4, 'Chưa thanh toán'),
  ('DD02', 2, 'Đã thanh toán');

INSERT INTO NguyenVatLieu (MaNVL, TenNVL, Giặtien) VALUES
(1, 'Bot Giặt Omo', 35000),
(2, 'Nuoc xa Comfort', 28000),
(3, 'Nuoc tay JaVệl', 20000),
(4, 'Tui nilon lon', 1500),
(5, 'Tui nilon nho', 800),
(6, 'Nuoc Giặt Ariel', 39000),
(7, 'Nuoc lau san', 25000),
(8, 'Hoa chat tay kho', 75000);

INSERT INTO PhieuNhap (NgayNhap, DotNhap, MaNV, MaNCC) VALUES
('2025-07-10', 'Dot 1', 'NV02', 'NCC01'),
('2025-07-15', 'Dot 2', 'NV03', 'NCC02');

INSERT INTO ChiTietPhieuNhap (MaPN, MaNVL, SoLuongNhap) VALUES
(1, 1, 10),
(1, 2, 20),
(2, 3, 15),
(2, 4, 50);


CREATE VIEW View_ThongTinCaNhan AS
SELECT MaNV, TenNV, GioiTinh, NgaySinh, SDT_NV
FROM NhanVien
WHERE CURRENT_USER() = MaNV;

-- Tạo user và phân quyền MySQL
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin123';
GRANT ALL PRIVILEGES ON QuanLyCuaHangGS.* TO 'admin'@'localhost';

CREATE USER 'nhanvien1'@'localhost' IDENTIFIED BY 'NV1123';
CREATE USER 'nhanvien2'@'localhost' IDENTIFIED BY 'NV2123';

GRANT SELECT, INSERT, UPDATE ON QuanLyCuaHangGS.KhachHang TO 'nhanvien1'@'localhost', 'nhanvien2'@'localhost';
GRANT SELECT, INSERT, UPDATE ON QuanLyCuaHangGS.DonDat TO 'nhanvien1'@'localhost', 'nhanvien2'@'localhost';
GRANT SELECT, INSERT ON QuanLyCuaHangGS.HoaDon TO 'nhanvien1'@'localhost', 'nhanvien2'@'localhost';
GRANT SELECT, INSERT, UPDATE ON QuanLyCuaHangGS.PhieuNhap TO 'nhanvien1'@'localhost', 'nhanvien2'@'localhost';

FLUSH PRIVILEGES;


SET FOREIGN_KEY_CHECKS = 0;

-- Tự động xoá tất cả bảng trong CSDL 'quanlycuahanggs'
SET @tables = NULL;
SELECT GROUP_CONCAT('`', table_name, '`') INTO @tables
FROM information_schema.tables
WHERE table_schema = 'quanlycuahanggs';

SET @sql = CONCAT('DROP TABLE IF EXISTS ', @tables);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;
