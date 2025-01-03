import db from "../configs/db.js"; // Kết nối MySQL từ file db.js
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

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

    const payload = {
      id: user.user_id, // ID người dùng
      email: user.email,
      role: user.role, // Có thể thêm thông tin khác nếu cần
    };

    const secretKey = process.env.JWT_SECRET || "secret_key"; // Lấy từ biến môi trường hoặc dùng mặc định
    const token = jwt.sign(payload, secretKey, { expiresIn: "1h" }); // Token có thời hạn 1 giờ

    // Đăng nhập thành công
    return res.status(200).json({
      message: "Đăng nhập thành công",
      token,
    });
  });
};

export const getAllUsers = (req, res) => {
  const sql = "SELECT * FROM users"; // Câu lệnh SQL để lấy tất cả người dùng

  db.query(sql, (error, results) => {
    if (error) {
      console.error(error);
      return res.status(500).json({
        success: false,
        message: "Có lỗi khi lấy danh sách người dùng",
      });
    }

    res.status(200).json({
      success: true,
      data: results, // Trả về dữ liệu người dùng
    });
  });
};

export const updateUserStatus = async (req, res) => {
  try {
    const { userId, status } = req.body; // Lấy userId từ URL
    // Kiểm tra trạng thái hợp lệ
    if (!["active", "locked"].includes(status)) {
      return res.status(400).json({
        success: false,
        message:
          "Trạng thái không hợp lệ. Chỉ chấp nhận 'active' hoặc 'locked'.",
      });
    }

    // Cập nhật trạng thái người dùng trong database
    const sql = "UPDATE users SET status = ? WHERE user_id = ?";
    db.query(sql, [status, userId], (err, result) => {
      if (err) {
        console.error("Lỗi khi cập nhật trạng thái:", err);
        return res.status(500).json({
          success: false,
          message: "Đã xảy ra lỗi khi cập nhật trạng thái người dùng.",
        });
      }

      // Kiểm tra nếu user không tồn tại
      if (result.affectedRows === 0) {
        return res.status(404).json({
          success: false,
          message: "Không tìm thấy người dùng với ID này.",
        });
      }

      return res.status(200).json({
        success: true,
        message: `Trạng thái của người dùng ID ${userId} đã được cập nhật thành '${status}'.`,
      });
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Đã xảy ra lỗi khi cập nhật trạng thái người dùng.",
    });
  }
};

export const getUserById = (req, res) => {
  const { userId } = req.params; // Lấy userId từ tham số URL
  console.log("userId:", userId);

  // Kiểm tra nếu userId không hợp lệ
  if (!userId || isNaN(userId)) {
    return res.status(400).json({ message: "Invalid user ID" });
  }

  // Truy vấn cơ sở dữ liệu để lấy thông tin người dùng
  const query = "SELECT * FROM users WHERE user_id = ?";

  db.query(query, [userId], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ message: "Error fetching user data", error: err });
    }

    if (results.length === 0) {
      // Không tìm thấy người dùng với userId
      return res.status(404).json({ message: "User not found" });
    }

    console.log("Results:", results[0]);

    // Trả về thông tin người dùng
    return res.status(200).json({
      user: results[0], // Lấy người dùng đầu tiên từ kết quả
    });
  });
};

export const updateUser = (req, res) => {
  const { userId } = req.params; // Lấy userId từ tham số của request
  const { name, email, phone, password } = req.body; // Lấy các thông tin từ request body

  // Nếu có mật khẩu mới, hash mật khẩu trước khi lưu
  let hashedPassword = null;
  if (password) {
    hashedPassword = bcrypt.hashSync(password, 10); // Hash mật khẩu với saltRounds = 10
  }

  // Tạo câu lệnh SQL để cập nhật thông tin người dùng
  let query =
    "UPDATE users SET name = ?, email = ?, phone = ?, updated_at = NOW()";
  let values = [name, email, phone];

  // Nếu có mật khẩu mới, thêm nó vào câu lệnh SQL
  if (hashedPassword) {
    query += ", password = ?";
    values.push(hashedPassword);
  }

  // Thêm điều kiện WHERE
  query += " WHERE user_id = ?";
  values.push(userId);

  // Thực thi câu lệnh SQL
  db.query(query, values, (error, result) => {
    if (error) {
      console.error("Error updating user:", error);
      return res.status(500).json({ message: "Failed to update user" });
    }

    if (result.affectedRows > 0) {
      return res.status(200).json({ message: "User updated successfully" });
    } else {
      return res.status(404).json({ message: "User not found" });
    }
  });
};
