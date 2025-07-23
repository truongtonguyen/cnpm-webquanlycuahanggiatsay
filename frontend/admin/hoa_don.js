fetch("http://localhost:3000/hoa-don")
  .then(response => response.json())
  .then(data => {
    const tbody = document.querySelector("table tbody");
    data.forEach((hoaDon, index) => {
      const row = document.createElement("tr");
      row.innerHTML = `
  <td>${index + 1}</td>
  <td>${hoaDon.TenKH}</td>
  <td>${hoaDon.TenDichVu}</td>
  <td>${hoaDon.SoLuong}</td>
  <td>---</td>
  <td>${hoaDon.DonGia}</td>
  <td>${hoaDon.ThanhTien}</td>
  <td>${hoaDon.TrangThai}</td>
`;

      tbody.appendChild(row);
    });
  })
  .catch(err => {
    console.error("Lỗi tải hóa đơn:", err);
  });
