import mysql from "mysql";

// Tạo kết nối
const connection = mysql.createConnection({
  host: "localhost", // Địa chỉ máy chủ MySQL
  user: "root", // Tên người dùng MySQL
  password: "", // Mật khẩu MySQL
  database: "do_an_app", // Tên cơ sở dữ liệu
});

export default connection;
