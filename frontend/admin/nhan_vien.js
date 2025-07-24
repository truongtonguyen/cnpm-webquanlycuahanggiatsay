document.addEventListener("DOMContentLoaded", async () => {
  await loadEmployees();

  const form = document.getElementById("add-employee-form");
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const formData = new FormData(form);
    const data = {};

    formData.forEach((value, key) => {
      data[key] = value;
    });

    const res = await fetch("http://localhost:3000/api/nhanvien", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        tenNV: data.tenNV,
        gioiTinh: data.gioiTinh,
        ngaySinh: data.ngaySinh,
        sdtNV: data.sdtNV
      }),
    });

    if (res.ok) {
      alert("Thêm nhân viên thành công!");
      form.reset();
      await loadEmployees();
    } else {
      alert("Thêm nhân viên thất bại!");
    }
  });
});

async function loadEmployees() {
  const res = await fetch("http://localhost:3000/api/nhanvien");
  const employees = await res.json();

  const tbody = document.getElementById("employee-list");
  tbody.innerHTML = "";

  employees.forEach(emp => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${emp.MaNV}</td>
      <td>${emp.TenNV}</td>
      <td>${emp.GioiTinh}</td>
      <td>${emp.NgaySinh}</td>
      <td>${emp.SDT_NV}</td>
      <td><button onclick="deleteEmployee('${emp.MaNV}')">Xoá</button></td>
    `;
    tbody.appendChild(tr);
  });
}

async function deleteEmployee(maNV) {
  if (confirm("Bạn có chắc muốn xoá nhân viên này?")) {
    const res = await fetch(`http://localhost:3000/api/nhanvien/${maNV}`, {
      method: "DELETE",
    });
    if (res.ok) {
      alert("Đã xoá!");
      await loadEmployees();
    } else {
      alert("Xoá thất bại!");
    }
  }
}
