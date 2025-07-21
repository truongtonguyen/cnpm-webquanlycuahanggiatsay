const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql2");

const app = express();
const PORT = 3000;

// Kết nối database MySQL
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // thay bằng user thật nếu có
  password: "123456", // thay bằng mật khẩu nếu có
  database: "quanlycuahanggs" // tên cơ sở dữ liệu của bạn
});

db.connect((err) => {
  if (err) {
    console.error("❌ Lỗi kết nối CSDL:", err);
    process.exit(1);
  }
  console.log("✅ Đã kết nối MySQL thành công");
});

// Middleware
app.use(cors());
app.use(bodyParser.json());

// -------------------- ĐĂNG NHẬP --------------------

const adminUser = {
  username: "admin",
  password: "123456"
};

app.post("/api/login", (req, res) => {
  const { username, password } = req.body;
  if (username === adminUser.username && password === adminUser.password) {
    res.json({ success: true });
  } else {
    res.json({ success: false, message: "Sai tài khoản hoặc mật khẩu" });
  }
});

// -------------------- ĐẶT ĐƠN HÀNG --------------------
app.post('/dat-lich', (req, res) => {
  const { hoten, sdt, email, diachi, lichhen, dichvu, ghichu } = req.body;

  const maDonDat = `DD${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`;
  const maKH = `KH${Math.floor(Math.random() * 10000).toString().padStart(4, '0')}`;

  // Tạo khách hàng mới
  const insertKH = `
    INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SDT_KH, EmailKH)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(insertKH, [maKH, hoten, diachi, sdt, email], (errKH) => {
    if (errKH) {
      console.error("❌ Lỗi tạo khách hàng:", errKH);
      return res.status(500).send("Lỗi khi thêm khách hàng");
    }

    // Tìm mã dịch vụ theo tên dịch vụ
    const queryDV = `SELECT MaDichVu FROM DichVu WHERE TenDichVu = ?`;
    db.query(queryDV, [dichvu], (errDV, rows) => {
      if (errDV || rows.length === 0) {
        console.error("❌ Lỗi dịch vụ:", errDV);
        return res.status(400).send("Dịch vụ không hợp lệ");
      }

      const maDV = rows[0].MaDichVu;

      const insertDon = `
        INSERT INTO DonDat (MaDonDat, TenKH, SDT_KH, NgayDat, MaDichVu, GhiChu, TrangThai, MaKH)
        VALUES (?, ?, ?, ?, ?, ?, 'Chưa xử lý', ?)
      `;

      db.query(insertDon, [maDonDat, hoten, sdt, lichhen, maDV, ghichu, maKH], (errDon) => {
        if (errDon) {
          console.error("❌ Lỗi đặt hàng:", errDon);
          return res.status(500).send("Lỗi khi đặt hàng");
        }
        res.send("✔️ Đặt lịch thành công!");
      });
    });
  });
});

// -------------------- XEM ĐƠN HÀNG --------------------
app.get('/don-hang', (req, res) => {
  const sql = `
    SELECT 
      dd.MaDonDat, 
      dd.TenKH AS HoTen, 
      dv.TenDichVu, 
      dd.NgayDat AS NgayHen, 
      dd.SDT_KH AS SoDienThoai, 
      dd.GhiChu, 
      dd.TrangThai
    FROM DonDat dd
    JOIN DichVu dv ON dd.MaDichVu = dv.MaDichVu
    WHERE dd.TrangThai = 'Chưa xử lý'
  `;
  db.query(sql, (err, result) => {
    if (err) {
      console.error("❌ Lỗi truy vấn đơn hàng:", err);
      return res.status(500).send("Lỗi truy vấn đơn hàng");
    }
    res.json(result);
  });
});


// -------------------- TRANG TỔNG QUAN --------------------

app.get('/tong-quan', (req, res) => {
  const sql = `
    SELECT 
      (SELECT COUNT(*) FROM DonDat) AS tongDon,
      (SELECT COUNT(*) FROM HoaDon) AS daTaoHD,
      (SELECT COUNT(*) FROM HoaDon WHERE TrangThai = 'Chưa thanh toán') AS chuaTT
  `;
  db.query(sql, (err, rows) => {
    if (err) {
      console.error("❌ Lỗi tổng quan:", err);
      return res.status(500).send("Lỗi tổng quan");
    }
    res.json(rows[0]);
  });
});

// -------------------- LẤY ĐƠN HÀNG CHƯA XỬ LÝ --------------------

app.get('/don-hang', (req, res) => {
  const sql = `
    SELECT dd.MaDon, dd.HoTen, dv.TenDV, dd.NgayHen, dd.SoDienThoai, dd.GhiChu, dd.TrangThai
    FROM DonDat dd
    JOIN DichVu dv ON dd.MaDV = dv.MaDV
    WHERE dd.TrangThai = 'Chưa xử lý'
  `;
  db.query(sql, (err, rows) => {
    if (err) {
      console.error("❌ Lỗi lấy đơn hàng:", err);
      return res.status(500).send("Lỗi đơn hàng");
    }
    res.json(rows);
  });
});

// -------------------- TẠO HÓA ĐƠN --------------------

app.post('/tao-hoa-don', (req, res) => {
  const { maDon, soLuong } = req.body;

  db.query(
    `INSERT INTO HoaDon (MaDon, SoLuong, TrangThai) VALUES (?, ?, 'Chưa thanh toán')`,
    [maDon, soLuong],
    (err, result) => {
      if (err) {
        console.error("❌ Lỗi tạo hóa đơn:", err);
        return res.status(500).send("Lỗi tạo hóa đơn");
      }

      // cập nhật trạng thái đơn hàng
      db.query(
        `UPDATE DonDat SET TrangThai = 'Đã tạo hóa đơn' WHERE MaDon = ?`,
        [maDon],
        (err2) => {
          if (err2) {
            console.error("❌ Lỗi cập nhật đơn hàng:", err2);
            return res.status(500).send("Lỗi cập nhật đơn hàng");
          }
          res.send("Đã tạo hóa đơn");
        }
      );
    }
  );
});

// -------------------- LẤY DANH SÁCH HÓA ĐƠN --------------------

app.get('/hoa-don', (req, res) => {
  const sql = `
    SELECT hd.MaHD, dd.HoTen, dv.TenDV, hd.SoLuong, dv.DonViTinh, dv.DonGia,
           (hd.SoLuong * dv.DonGia) AS ThanhTien, hd.TrangThai
    FROM HoaDon hd
    JOIN DonDat dd ON hd.MaDon = dd.MaDon
    JOIN DichVu dv ON dd.MaDV = dv.MaDV
  `;
  db.query(sql, (err, rows) => {
    if (err) {
      console.error("❌ Lỗi lấy hóa đơn:", err);
      return res.status(500).send("Lỗi hóa đơn");
    }
    res.json(rows);
  });
});

// -------------------- CHẠY SERVER --------------------

app.listen(PORT, () => {
  console.log(`🚀 Server đang chạy tại http://localhost:${PORT}`);
});
