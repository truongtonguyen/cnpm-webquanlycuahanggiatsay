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
            <td><button class="btn-tao-hoa-don" data-madon="${don.MaDonDat}">Tạo hóa đơn</button>
</td>
          </tr>
        `;
      });
    });
});


document.addEventListener("click", function (e) {
  if (e.target.classList.contains("btn-tao-hoa-don")) {
    const maDon = e.target.dataset.madon;
    if (!maDon) {
      alert("Không có mã đơn hàng");
      return;
    }
    console.log("Đang chuyển tới tạo hóa đơn cho:", maDon);
    window.location.href = `tao_hoa_don.html?maDon=${encodeURIComponent(maDon)}`;
  }
});

