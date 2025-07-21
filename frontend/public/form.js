document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("formGiatUi");
  const popup = document.getElementById("thongbao");
  const btnClose = document.getElementById("dongThongBao");
  const noidung = document.getElementById("noidungThongbao");

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    const dichvu = form.dichvu.value;
    const lichhen = form.lichhen.value;
    const hoten = form.hoten.value;
    const sdt = form.sdt.value;
    const email = form.email.value;
    const diachi = form.diachi.value;
    const ghichu = form.ghichu.value;

    fetch("http://localhost:3000/dat-lich", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        dichvu, lichhen, hoten, sdt, email, diachi, ghichu
      })
    })
    .then(res => {
      if (!res.ok) {
        throw new Error("Gửi thất bại");
      }
      return res.text();
    })
    .then(msg => {
      noidung.innerText = `✔️ ${msg}\n\nCảm ơn bạn ${hoten}!\nLịch hẹn: ${lichhen}\nSĐT: ${sdt}\nEmail: ${email}\nĐịa chỉ: ${diachi}`;
      popup.classList.add("hien-ra");
      form.reset();
    })
    .catch(err => {
      alert("❌ Gửi thất bại. Vui lòng thử lại!");
      console.error(err);
    });
  });

  btnClose.addEventListener("click", function () {
    popup.classList.remove("hien-ra");
  });
});
