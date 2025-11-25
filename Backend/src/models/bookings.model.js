const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema(
    {
        customerId: { type: mongoose.Schema.Types.ObjectId, ref: "customers", required: true },
        productId: { type: mongoose.Schema.Types.ObjectId, ref: "products", required: true },
        count: { type: Number, default: 1 },
        startDateTime: { type: Date, required: true },
        endDateTime: { type: Date, required: true },
        status: {
            type: String,
            enum: [
                "ongoing",
                "started",
                "completed",
                "cancelled by user",
                "cancelled by vendor",
                "pending",
                "confirmed",
            ],
        },
        price: { type: Number, required: true },
    },
    {
        timestamps: true,
    }
);

const Bookings = mongoose.model("bookings", bookingSchema);

module.exports = Bookings;
