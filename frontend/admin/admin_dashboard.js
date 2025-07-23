document.addEventListener("DOMContentLoaded", () => {
  fetch("http://localhost:3000/tong-quan")
    .then(res => res.json())
    .then(data => {
      document.getElementById("total-orders").textContent = data.tongDon;
      document.getElementById("total-invoices").textContent = data.daTaoHD;
      document.getElementById("pending-invoices").textContent = data.chuaTT;
    })
    .catch(err => {
      console.error("❌ Lỗi tải tổng quan:", err);
      alert("Lỗi khi tải dữ liệu tổng quan");
    });
});