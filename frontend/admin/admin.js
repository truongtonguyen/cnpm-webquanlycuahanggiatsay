// admin.js

function logout() {
  localStorage.removeItem("admin_logged_in");
  window.location.href = "dang_nhap.html";
}

if (location.pathname.includes("dang_nhap.html")) {
  document.getElementById("loginForm")?.addEventListener("submit", async function (e) {
    e.preventDefault();
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    const res = await fetch("http://localhost:3000/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password })
    });

    const data = await res.json();
    if (data.success) {
      localStorage.setItem("admin_logged_in", true);
      location.href = "trang_chu_admin.html";
    } else {
      document.getElementById("errorMsg").textContent = data.message || "Sai thông tin đăng nhập";
    }
  });
}

if (!localStorage.getItem("admin_logged_in") && !location.pathname.includes("dang_nhap.html")) {
  location.href = "dang_nhap.html";
}

if (location.pathname.includes("don_hang.html")) {
  fetch("http://localhost:3000/api/orders")
    .then(res => res.json())
    .then(data => {
      const tbody = document.getElementById("orderTableBody");
      data.forEach((order, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
          <td>${index + 1}</td>
          <td>${order.full_name}</td>
          <td>${order.service}</td>
          <td>${order.appointment_date}</td>
          <td>${order.phone}<br>${order.email}</td>
          <td>${order.note || "-"}</td>
          <td><a href="tao_hoa_don.html?orderId=${order.id}" class="btn">Tạo hóa đơn</a></td>
        `;
        tbody.appendChild(row);
      });
    });
}

if (location.pathname.includes("tao_hoa_don.html")) {
  const params = new URLSearchParams(location.search);
  const orderId = params.get("orderId");

  document.getElementById("invoiceForm")?.addEventListener("submit", async function (e) {
    e.preventDefault();
    const quantity = parseFloat(document.getElementById("quantity").value);
    const unit = document.getElementById("unit").value;
    const unit_price = parseInt(document.getElementById("unit_price").value);
    const total_price = quantity * unit_price;

    await fetch("http://localhost:3000/api/invoices", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ order_id: orderId, quantity, unit, unit_price, total_price })
    });

    alert("Đã tạo hóa đơn");
    location.href = "hoa_don.html";
  });
}

if (location.pathname.includes("hoa_don.html")) {
  fetch("http://localhost:3000/api/invoices")
    .then(res => res.json())
    .then(data => {
      const tbody = document.getElementById("invoiceTableBody");
      data.forEach((inv, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
          <td>${index + 1}</td>
          <td>${inv.full_name || "-"}</td>
          <td>${inv.service || "-"}</td>
          <td>${inv.quantity}</td>
          <td>${inv.unit}</td>
          <td>${inv.unit_price}</td>
          <td>${inv.total_price}</td>
          <td>${inv.status}</td>
        `;
        tbody.appendChild(row);
      });
    });
}
