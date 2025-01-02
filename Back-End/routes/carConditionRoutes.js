// routes/carConditionRoutes.js
import express from "express";
import {
  getCarCondition,
  addCarCondition,
  updateCarCondition,
  deleteCarCondition,
} from "../controllers/carConditionController.js";

const router = express.Router();

// Lấy tình trạng xe theo car_id
router.get("/:car_id", getCarCondition);

// Thêm tình trạng xe mới
router.post("/", addCarCondition);

// Cập nhật tình trạng xe theo condition_id
router.put("/:condition_id", updateCarCondition);

// Xóa tình trạng xe theo condition_id
router.delete("/:condition_id", deleteCarCondition);

export default router;
