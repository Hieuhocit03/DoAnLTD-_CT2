import db from "../configs/db.js"; // Kết nối MySQL từ file db.js
import bcrypt from "bcrypt";

// Hàm đăng ký người dùng
export const registerUser = async (req, res) => {
  const { name, email, password, phone, role = "user" } = req.body;

  try {
    // Kiểm tra nếu email đã tồn tại
    const emailCheckQuery = "SELECT * FROM users WHERE email = ?";
    db.query(emailCheckQuery, [email], async (err, results) => {
      if (err) {
        return res.status(500).json({ message: "Lỗi hệ thống", error: err });
      }

      if (results.length > 0) {
        return res.status(400).json({ message: "Email đã tồn tại" });
      }

      // Hash password bằng bcrypt
      const saltRounds = 10; // Độ mạnh của thuật toán bcrypt
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      // Thêm người dùng vào cơ sở dữ liệu
      const insertQuery = `
        INSERT INTO users (role, name, email, password, phone, status)
        VALUES (?, ?, ?, ?, ?, 'active')
      `;
      db.query(
        insertQuery,
        [role, name, email, hashedPassword, phone],
        (err, result) => {
          if (err) {
            return res.status(500).json({
              message: "Lỗi hệ thống khi thêm người dùng",
              error: err,
            });
          }
          return res
            .status(201)
            .json({ message: "Đăng ký thành công", userId: result.insertId });
        }
      );
    });
  } catch (error) {
    return res.status(500).json({ message: "Đã xảy ra lỗi", error });
  }
};

// Hàm đăng nhập
export const loginUser = (req, res) => {
  const { email, password } = req.body;

  // Kiểm tra email và mật khẩu có được cung cấp không
  if (!email || !password) {
    return res
      .status(400)
      .json({ message: "Vui lòng cung cấp email và mật khẩu" });
  }

  // Truy vấn cơ sở dữ liệu để tìm người dùng với email
  const query = "SELECT * FROM users WHERE email = ?";
  db.query(query, [email], async (err, results) => {
    if (err) {
      return res
        .status(500)
        .json({ message: "Đã xảy ra lỗi truy vấn", error: err });
    }

    if (results.length === 0) {
      // Không tìm thấy email trong cơ sở dữ liệu
      return res.status(404).json({ message: "Email không tồn tại" });
    }

    // So sánh mật khẩu người dùng nhập với mật khẩu đã hash trong DB
    const user = results[0]; // Lấy người dùng đầu tiên từ kết quả
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ message: "Mật khẩu không chính xác" });
    }

    // Đăng nhập thành công
    return res.status(200).json({
      message: "Đăng nhập thành công",
      user: {
        id: user.user_id,
        name: user.name,
        email: user.email,
        role: user.role,
        status: user.status,
      },
    });
  });
};
