document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("formGiatUi");
  const popup = document.getElementById("thongbao");
  const btnClose = document.getElementById("dongThongBao");
  const noidung = document.getElementById("noidungThongbao");

  form.addEventListener("submit", function (e) {
    e.preventDefault();

    const lichhen = document.getElementById("lichhen").value;
    const hoten = document.getElementById("hoten").value;
    const sdt = document.getElementById("sdt").value;
    const email = document.getElementById("email").value;
    const diachi = document.getElementById("diachi").value;

    noidung.innerText = `Cảm ơn bạn ${hoten}!\n\nLịch hẹn: ${lichhen}\nSĐT: ${sdt}\nEmail: ${email}\nĐịa chỉ: ${diachi}`;
    popup.classList.add("hien-ra");
    form.reset();
  });

  btnClose.addEventListener("click", function () {
    popup.classList.remove("hien-ra");
  });
});

