const urlParams = new URLSearchParams(window.location.search);
const maDon = urlParams.get("maDon");

if (!maDon) {
  alert("Không tìm thấy mã đơn hàng");
  window.location.href = "don_hang.html";
}

const form = document.getElementById("invoiceForm");
form.addEventListener("submit", function (e) {
  e.preventDefault();

  const soLuong = document.getElementById("quantity").value;

  fetch("http://localhost:3000/tao-hoa-don", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      maDon: maDon,
      soLuong: soLuong
    })
  })
    .then(res => {
      if (!res.ok) throw new Error("Lỗi tạo hóa đơn");
      return res.text();
    })
    .then(msg => {
      alert("✅ " + msg);
      window.location.href = "hoa_don.html";
    })
    .catch(err => {
      console.error("❌ Lỗi fetch:", err);
      alert("❌ Lỗi khi tạo hóa đơn");
    });
});
