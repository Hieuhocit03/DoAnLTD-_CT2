import express from "express";
import {
  getCarSpecifications,
  addCarSpecification,
  updateCarSpecification,
  deleteCarSpecification,
} from "../controllers/carSpecificationsController.js";

const router = express.Router();

// Lấy thông số xe theo car_id
router.get("/:car_id", getCarSpecifications);

// Thêm thông số xe mới
router.post("/", addCarSpecification);

// Cập nhật thông số xe theo specification_id
router.put("/:specification_id", updateCarSpecification);

// Xóa thông số xe theo specification_id
router.delete("/:specification_id", deleteCarSpecification);

export default router;
