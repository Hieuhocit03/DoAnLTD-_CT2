import db from "../configs/db.js"; // Kết nối DB (giả định bạn đã có module này)

// Lấy danh sách xe
export const getCars = (req, res) => {
  const query = `
    SELECT 
      * 
    FROM cars
  `;
  db.query(query, (err, results) => {
    if (err) {
      return res
        .status(500)
        .json({ message: "Lỗi khi lấy danh sách xe", error: err });
    }
    res.status(200).json(results);
  });
};

// Lấy thông tin chi tiết của một xe
export const getCarById = (req, res) => {
  const { id } = req.params;
  const query = "SELECT * FROM cars WHERE car_id = ?";
  db.query(query, [id], (err, results) => {
    if (err) {
      return res
        .status(500)
        .json({ message: "Lỗi khi lấy thông tin chi tiết xe", error: err });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy xe với ID này" });
    }
    res.status(200).json(results);
  });
};

// Thêm xe mới
export const addCar = (req, res) => {
  const {
    name,
    brand_id,
    year,
    price,
    status,
    location,
    description,
    image_url,
    seller_id,
  } = req.body;

  if (!name || !brand_id || !year || !price || !location || !seller_id) {
    return res
      .status(400)
      .json({ message: "Vui lòng cung cấp đầy đủ thông tin" });
  }

  const query = `
    INSERT INTO cars (name, brand_id, year, price, status, location, description, image_url, seller_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(
    query,
    [
      name,
      brand_id,
      year,
      price,
      status || "Chờ duyệt",
      location,
      description,
      image_url,
      seller_id,
    ],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ message: "Lỗi khi thêm xe mới", error: err });
      }
      res
        .status(201)
        .json({ message: "Thêm xe thành công", carId: result.insertId });
    }
  );
};

// Xóa xe
export const deleteCar = (req, res) => {
  const { id } = req.params;
  const query = "DELETE FROM cars WHERE car_id = ?";
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Lỗi khi xóa xe", error: err });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy xe với ID này" });
    }
    res.status(200).json({ message: "Xóa xe thành công" });
  });
};

// Sửa xe
export const updateCar = (req, res) => {
  const { id } = req.params;
  const {
    name,
    brand_id,
    year,
    price,
    status,
    location,
    description,
    image_url,
    seller_id,
  } = req.body;

  const query = `
    UPDATE cars
    SET 
      name = ?, 
      brand_id = ?, 
      year = ?, 
      price = ?, 
      status = ?, 
      location = ?, 
      description = ?, 
      image_url = ?, 
      seller_id = ?
    WHERE car_id = ?
  `;
  db.query(
    query,
    [
      name,
      brand_id,
      year,
      price,
      status,
      location,
      description,
      image_url,
      seller_id,
      id,
    ],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ message: "Lỗi khi cập nhật xe", error: err });
      }
      if (result.affectedRows === 0) {
        return res
          .status(404)
          .json({ message: "Không tìm thấy xe với ID này" });
      }
      res.status(200).json({ message: "Cập nhật xe thành công" });
    }
  );
};
