import express from "express";
import connectDB from "./configs/db.js";
import bodyParser from "body-parser";
import userRoutes from "./routes/authRoutes.js";

const app = express();

app.use(bodyParser.json());

app.use("/api/users", userRoutes);

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
