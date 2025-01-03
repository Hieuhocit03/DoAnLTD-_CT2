// controllers/carModelController.js
import db from "../configs/db.js"; // Kết nối database

// Lấy tất cả thông tin từ bảng car_models
export const getAllCarModels = (req, res) => {
  const query = `
      SELECT *
      FROM car_models
    `; // Câu truy vấn SQL để lấy dữ liệu từ bảng car_models

  db.query(query, (err, results) => {
    if (err) {
      // Nếu có lỗi trong quá trình truy vấn
      console.error("Error fetching car models:", err);
      return res.status(500).json({
        success: false,
        message: "Failed to fetch car models",
        error: err.message,
      });
    }

    // Nếu truy vấn thành công, trả về dữ liệu
    return res.status(200).json({
      success: true,
      data: results,
    });
  });
};
