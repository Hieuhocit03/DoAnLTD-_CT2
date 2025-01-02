// routes/brandRoutes.js
import express from "express";
import { getBrands } from "../controllers/brandControllers.js"; // Dùng import cho controller

const router = express.Router();

// Định nghĩa route để lấy danh sách các hãng xe
router.get("/", getBrands);

export default router; // Xuất router
