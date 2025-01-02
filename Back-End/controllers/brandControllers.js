// controllers/brandController.js
import db from "../configs/db.js"; // Dùng import để lấy database config

// Lấy danh sách các hãng xe
export const getBrands = (req, res) => {
  const query = "SELECT brand_id, name FROM brands"; // Câu truy vấn SQL lấy tên hãng xe từ bảng brands

  db.query(query, (err, results) => {
    if (err) {
      // Nếu có lỗi trong truy vấn, trả về lỗi
      return res
        .status(500)
        .json({ message: "Có lỗi khi truy vấn dữ liệu", error: err });
    }

    // Trả về dữ liệu dưới dạng JSON
    return res.status(200).json(results);
  });
};
