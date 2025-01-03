// routes/carModelRoutes.js
import express from "express";
import { getAllCarModels } from "../controllers/carModelController.js";

const router = express.Router();

// Route: Lấy tất cả car models
router.get("/", getAllCarModels);

export default router;
