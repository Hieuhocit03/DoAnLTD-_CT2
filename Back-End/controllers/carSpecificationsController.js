import db from "../configs/db.js"; // Dùng import để lấy database config

// Lấy thông số xe theo car_id
export const getCarSpecifications = (req, res) => {
  const carId = req.params.car_id;

  const query = "SELECT * FROM car_specifications WHERE car_id = ?";

  db.query(query, [carId], (err, results) => {
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

// Thêm thông số xe mới
export const addCarSpecification = (req, res) => {
  const {
    car_id,
    version,
    transmission,
    fuel_type,
    body_style,
    seats,
    drivetrain,
    engine_type,
    horsepower,
    torque,
    engine_capacity,
    fuel_consumption,
    airbags,
    ground_clearance,
    doors,
    weight,
    payload_capacity,
    car_model_id,
  } = req.body;

  const query = `
    INSERT INTO car_specifications (
      car_id, version, transmission, fuel_type, body_style, seats, drivetrain,
      engine_type, horsepower, torque, engine_capacity, fuel_consumption,
      airbags, ground_clearance, doors, weight, payload_capacity, car_model_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    query,
    [
      car_id,
      version,
      transmission,
      fuel_type,
      body_style,
      seats,
      drivetrain,
      engine_type,
      horsepower,
      torque,
      engine_capacity,
      fuel_consumption,
      airbags,
      ground_clearance,
      doors,
      weight,
      payload_capacity,
      car_model_id,
    ],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ message: "Có lỗi khi thêm thông số xe", error: err });
      }

      return res.status(201).json({ message: "Thông số xe đã được thêm" });
    }
  );
};

// Cập nhật thông số xe theo specification_id
export const updateCarSpecification = (req, res) => {
  const specificationId = req.params.specification_id;
  const {
    version,
    transmission,
    fuel_type,
    body_style,
    seats,
    drivetrain,
    engine_type,
    horsepower,
    torque,
    engine_capacity,
    fuel_consumption,
    airbags,
    ground_clearance,
    doors,
    weight,
    payload_capacity,
    car_model_id,
  } = req.body;

  const query = `
    UPDATE car_specifications SET
      version = ?, transmission = ?, fuel_type = ?, body_style = ?, seats = ?, drivetrain = ?,
      engine_type = ?, horsepower = ?, torque = ?, engine_capacity = ?, fuel_consumption = ?,
      airbags = ?, ground_clearance = ?, doors = ?, weight = ?, payload_capacity = ?, car_model_id = ?
    WHERE specification_id = ?
  `;

  db.query(
    query,
    [
      version,
      transmission,
      fuel_type,
      body_style,
      seats,
      drivetrain,
      engine_type,
      horsepower,
      torque,
      engine_capacity,
      fuel_consumption,
      airbags,
      ground_clearance,
      doors,
      weight,
      payload_capacity,
      car_model_id,
      specificationId,
    ],
    (err, result) => {
      if (err) {
        return res
          .status(500)
          .json({ message: "Có lỗi khi cập nhật thông số xe", error: err });
      }

      return res.status(200).json({ message: "Thông số xe đã được cập nhật" });
    }
  );
};

// Xóa thông số xe theo specification_id
export const deleteCarSpecification = (req, res) => {
  const specificationId = req.params.specification_id;

  const query = "DELETE FROM car_specifications WHERE specification_id = ?";

  db.query(query, [specificationId], (err, result) => {
    if (err) {
      return res
        .status(500)
        .json({ message: "Có lỗi khi xóa thông số xe", error: err });
    }

    return res.status(200).json({ message: "Thông số xe đã được xóa" });
  });
};
