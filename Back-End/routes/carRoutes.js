import express from "express";
import {
  getCars,
  getCarById,
  addCar,
  deleteCar,
  updateCar,
  updateCarStatus,
  getCarsBySeller,
} from "../controllers/carControllers.js";

const router = express.Router();

// Lấy danh sách xe
router.get("/", getCars);

// Lấy thông tin chi tiết của một xe
router.get("/:id", getCarById);

// Thêm xe mới
router.post("/", addCar);

// Xóa xe
router.delete("/:id", deleteCar);

// Sửa thông tin xe
router.put("/:id", updateCar);
router.put("/cars/status", updateCarStatus);
router.get("/cars/seller/:sellerId", getCarsBySeller);

export default router;
