import express from "express";
import connectDB from "./configs/db.js";
import bodyParser from "body-parser";
import userRoutes from "./routes/authRoutes.js";
import carRoutes from "./routes/carRoutes.js";
import brandRoutes from "./routes/brandRoutes.js";
import carSpecificationsRoutes from "./routes/carSpecificationsRoutes.js";
import carConditionRoutes from "./routes/carConditionRoutes.js";
import carModelRoutes from "./routes/carModelRoutes.js";
import cors from "cors";

const app = express();

app.use(cors());

app.use(bodyParser.json());

app.use("/api/users", userRoutes);
app.use("/api/cars", carRoutes);
app.use("/api/brands", brandRoutes);
app.use("/api/car-specifications", carSpecificationsRoutes);
app.use("/api/car-conditions", carConditionRoutes);
app.use("/api/car-models", carModelRoutes);

connectDB.connect((err) => {
  if (err) {
    console.error("Kết nối MySQL thất bại:", err);
  } else {
    console.log("Kết nối MySQL thành công!");
  }
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
