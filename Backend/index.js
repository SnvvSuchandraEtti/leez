const express = require("express");
const cors = require("cors");
require("dotenv").config();

const { connectToDB } = require("./config/connection");

const customerRouter = require("./src/routers/customer.routes");
const vendorRouter = require("./src/routers/vendor.routes");
const categoryRouter = require("./src/routers/category.routes");
const specificationRouter = require("./src/routers/specifications.routes");
const productRouter = require("./src/routers/products.routes");
const favouritesRouter = require("./src/routers/favorites.routes");
const bookingRouter = require("./src/routers/booking.routes");
const reviewRouter = require("./src/routers/reviews.routes");

connectToDB(process.env.MONGO_DB_URL)
    .then(() => {
        console.log("MongoDB connected successfully");
    })
    .catch((err) => {
        console.log("MongoDB connection error : ", err);
    });

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/customer", customerRouter);

app.use("/api/vendor", vendorRouter);

app.use("/api/category", categoryRouter);

app.use("/api/specifications", specificationRouter);

app.use("/api/products", productRouter);

app.use("/api/favorites", favouritesRouter);

app.use("/api/bookings", bookingRouter);

app.use("/api/review", reviewRouter);

const port = 5001;

setInterval(() => {
    try {
        fetch("https://leez-app.onrender.com");
    } catch (e) {}
}, 840000);

app.listen(port, () => {
    console.log(`Server is running at port ${port}`);
});
