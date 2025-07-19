CREATE DATABASE QuanLyCuaHangGS;
USE QuanLyCuaHangGS;


CREATE TABLE KhachHang (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100),
    DiaChi NVARCHAR(200),
    SDT_KH VARCHAR(15),
    EmailKH VARCHAR(100)
);

CREATE TABLE DichVu (
    MaDichVu VARCHAR(10) PRIMARY KEY,
    TenDichVu NVARCHAR(100),
    DonGia DECIMAL(18, 2),
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(100),
    GioiTinh NVARCHAR(5),
    NgaySinh DATE,
    SDT_NV VARCHAR(15)
);

CREATE TABLE CaTruc (
    STT INT PRIMARY KEY,
    TGBatDau TIME,
    TGKetThuc TIME,
    TenCa NVARCHAR(50)
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
    TenNCC NVARCHAR(100),
    DiaChiNCC NVARCHAR(200),
    SDT_NCC VARCHAR(15)
);

CREATE TABLE PhanQuyen (
    MaPQ VARCHAR(10) PRIMARY KEY,
    TenPQ NVARCHAR(50)
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

CREATE TABLE DonDat (
    MaDonDat VARCHAR(10) PRIMARY KEY,
    NgayDat DATE,
    TrangThai NVARCHAR(50),
    MaKH VARCHAR(10),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE ChiTietDonDat (
    MaDonDat VARCHAR(10),
    MaDichVu VARCHAR(10),
    DonGia DECIMAL(10, 2),
    SoLuong INT,
    ThanhTien AS (SoLuong * DonGia) PERSISTED,
    DonViTinh NVARCHAR(50),
    PRIMARY KEY (MaDonDat, MaDichVu),
    FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);

CREATE TABLE HoaDon (
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    NgayLap DATE,
    MaDonDat VARCHAR(10) UNIQUE,
    FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat)
);

CREATE TABLE NguyenVatLieu (
    MaNVL INT PRIMARY KEY,
    TenNVL NVARCHAR(100),
    GiaTien DECIMAL(18,2)
);

CREATE TABLE PhieuNhap (
    MaPN INT PRIMARY KEY IDENTITY(1,1),
    NgayNhap DATE,
    DotNhap NVARCHAR(50),
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

-----------------------------------------------------------------------

INSERT INTO KhachHang VALUES
('KH01', N'Nguyễn Văn A', N'123 Lê Lợi, Q1', '0909123456', 'a.nguyen@gmail.com'),
('KH02', N'Trần Thị B', N'456 Trần Hưng Đạo, Q5', '0911223344', 'b.tran@yahoo.com'),
('KH03', N'Lê Văn C', N'789 Nguyễn Huệ, Q3', '0933445566', 'c.le@outlook.com');

INSERT INTO DichVu VALUES
('DV01', N'Giặt chăn mềm', 20000),
('DV02', N'Giặt sấy nhanh', 17000),
('DV03', N'Vệ sinh túi xách', 40000);

INSERT INTO NhanVien VALUES
('NV01', N'Phạm Văn D', N'Nữ', '1995-03-15', '0901234567'),
('NV02', N'Ngô Thị E', N'Nữ', '1998-08-22', '0912345678'),
('NV03', N'Lâm Thanh T', N'Nữ', '1998-06-12', '07888838973');

INSERT INTO CaTruc VALUES
(1, '07:00', '11:00', N'Ca sáng'),
(2, '13:00', '17:00', N'Ca chiều'),
(3, '18:00', '22:00', N'Ca tối');

INSERT INTO Truc VALUES
('NV02', 1, '2025-07-18'),
('NV02', 2, '2025-07-19'),
('NV03', 3, '2025-07-18');

INSERT INTO NhaCungCap VALUES
('NCC01', N'Tiệm Bột Giặt ABC', N'12 Nguyễn Trãi, Q1', '02839451234'),
('NCC02', N'Tiệm Hóa chất XYZ', N'88 Lý Thường Kiệt, Q10', '02839784567');

INSERT INTO PhanQuyen VALUES
('PQ01', N'Admin'),
('PQ02', N'Nhân viên');

INSERT INTO TaiKhoan VALUES
('TK01', 'Admin', 'admin123', 'PQ01', 'NV01'),
('TK02', 'nv2', '123456', 'PQ02', 'NV02'),
('TK03', 'nv3', '123456', 'PQ02', 'NV03');

INSERT INTO DonDat VALUES
('DD01', '2025-07-18', N'Đã giao', 'KH01'),
('DD02', '2025-07-19', N'Chờ xử lý', 'KH02'),
('DD03', '2025-07-19', N'Đã thanh toán', 'KH03');

INSERT INTO ChiTietDonDat VALUES
('DD01', 'DV01', 20000, 3, N'kg'),
('DD01', 'DV02', 17000, 1, N'kg'),
('DD02', 'DV03', 40000, 2, N'Cai'),
('DD03', 'DV01', 20000, 5, N'kg');

INSERT INTO HoaDon (NgayLap, MaDonDat) VALUES
('2025-07-18', 'DD01'),
('2025-07-19', 'DD03');

INSERT INTO NguyenVatLieu (MaNVL, TenNVL, GiaTien) VALUES
(1, N'Bột giặt Omo', 35000),
(2, N'Nước xả Comfort', 28000),
(3, N'Nước tẩy Javel', 20000),
(4, N'Túi nilon lớn', 1500),
(5, N'Túi nilon nhỏ', 800),
(6, N'Nước giặt Ariel', 39000),
(7, N'Nước lau sàn', 25000),
(8, N'Hóa chất tẩy khô', 75000);

-----------------------------------------------------------------------
USE QuanLyCuaHangGS;

CREATE LOGIN Admin_GS WITH PASSWORD = 'Admin123';
CREATE USER Admin_GS FOR LOGIN Admin_GS;
ALTER ROLE db_owner ADD MEMBER Admin_GS;


CREATE LOGIN NhanVien1 WITH PASSWORD = 'NV1123';
CREATE USER NhanVien1 FOR LOGIN NhanVien1;

CREATE LOGIN NhanVien2 WITH PASSWORD = 'NV2123';
CREATE USER NhanVien2 FOR LOGIN NhanVien2;
-- Cấp quyền
CREATE ROLE NhanVienRole;
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO NhanVienRole;
GRANT SELECT, INSERT, UPDATE ON dbo.DonDat TO NhanVienRole;
GRANT SELECT, INSERT ON dbo.HoaDon TO NhanVienRole;
GRANT SELECT, INSERT, UPDATE ON dbo.PhieuNhap TO NhanVienRole;

ALTER ROLE NhanVienRole ADD MEMBER NhanVien1;
ALTER ROLE NhanVienRole ADD MEMBER NhanVien2;
------------------------------------------------------------

CREATE VIEW View_ThongTinCaNhan
AS
SELECT MaNV, TenNV, GioiTinh, NgaySinh, SDT_NV
FROM NhanVien
WHERE USER_NAME() = MaNV;

GRANT SELECT ON View_ThongTinCaNhan TO NhanVien1;
GRANT SELECT ON View_ThongTinCaNhan TO NhanVien2;

DENY DELETE ON NhanVien TO NhanVienRole;
DENY DELETE ON NhaCungCap TO NhanVienRole;
