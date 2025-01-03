import express from "express";
import {
  registerUser,
  loginUser,
  getAllUsers,
  updateUserStatus,
  getUserById,
  updateUser,
} from "../controllers/authControllers.js";

const router = express.Router();

// Route đăng ký
router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/users", getAllUsers);
router.put("/users/:userId", updateUserStatus);
router.get("/users/:userId", getUserById);
router.put("/:userId", updateUser);

export default router;
