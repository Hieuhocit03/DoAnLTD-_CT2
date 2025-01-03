// controllers/carConditionController.js
import db from "../configs/db.js";

// Lấy tình trạng xe theo car_id
export const getCarCondition = (req, res) => {
  const carId = req.params.car_id;

  const query = "SELECT * FROM car_condition WHERE car_id = ?";
  db.query(query, [carId], (err, results) => {
    if (err) {
      console.error("Error fetching data: ", err);
      return res
        .status(500)
        .json({ message: "Failed to load car condition", error: err });
    }

    res.status(200).json(results);
  });
};

// Thêm tình trạng xe mới
export const addCarCondition = (req, res) => {
  const {
    car_id,
    km_driven,
    owners_count,
    license_type,
    accessories,
    registration_expiry,
    origin,
    status,
    warranty_policy,
  } = req.body;

  const query = `
    INSERT INTO car_condition (
      car_id, km_driven, owners_count, license_type, accessories, 
      registration_expiry, origin, status, warranty_policy
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    query,
    [
      car_id,
      km_driven,
      owners_count,
      license_type,
      accessories,
      registration_expiry,
      origin,
      status,
      warranty_policy,
    ],
    (err, result) => {
      if (err) {
        console.error("Error inserting data: ", err);
        return res
          .status(500)
          .json({ message: "Failed to add car condition", error: err });
      }

      res.status(201).json({ message: "Car condition added successfully" });
    }
  );
};

// Cập nhật tình trạng xe theo condition_id
export const updateCarCondition = (req, res) => {
  const conditionId = req.params.condition_id;
  const {
    km_driven,
    owners_count,
    license_type,
    accessories,
    registration_expiry,
    origin,
    status,
    warranty_policy,
  } = req.body;

  const query = `
    UPDATE car_condition SET
      km_driven = ?, owners_count = ?, license_type = ?, accessories = ?, 
      registration_expiry = ?, origin = ?, status = ?, warranty_policy = ?
    WHERE condition_id = ?
  `;

  db.query(
    query,
    [
      km_driven,
      owners_count,
      license_type,
      accessories,
      registration_expiry,
      origin,
      status,
      warranty_policy,
      conditionId,
    ],
    (err, result) => {
      if (err) {
        console.error("Error updating data: ", err);
        return res
          .status(500)
          .json({ message: "Failed to update car condition", error: err });
      }

      res.status(200).json({ message: "Car condition updated successfully" });
    }
  );
};

// Xóa tình trạng xe theo condition_id
export const deleteCarCondition = (req, res) => {
  const conditionId = req.params.condition_id;

  const query = "DELETE FROM car_condition WHERE condition_id = ?";
  db.query(query, [conditionId], (err, result) => {
    if (err) {
      console.error("Error deleting data: ", err);
      return res
        .status(500)
        .json({ message: "Failed to delete car condition", error: err });
    }

    res.status(200).json({ message: "Car condition deleted successfully" });
  });
};
