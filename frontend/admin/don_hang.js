// donhang.js
document.addEventListener("DOMContentLoaded", () => {
  fetch("http://localhost:3000/don-hang")
    .then(res => res.json())
    .then(data => {
      const tbody = document.getElementById("donHangTableBody");
      tbody.innerHTML = "";
      data.forEach((don, i) => {
        tbody.innerHTML += `
          <tr>
            <td>${i + 1}</td>
            <td>${don.HoTen}</td>
            <td>${don.TenDichVu}</td>
            <td>${don.NgayHen}</td>
            <td>${don.SoDienThoai}</td>
            <td>${don.GhiChu}</td>
            <td><button>Tạo hóa đơn</button></td>
          </tr>
        `;
      });
    });
});
