const mongoose = require("mongoose");

const reviewSchema = new mongoose.Schema(
    {
        bookingId: { type: mongoose.Schema.Types.ObjectId, ref: "bookings", required: true },
        rating: { type: Number, enum: [1, 2, 3, 4, 5], required: true },
        reviewText: { type: String },
        images: [{ type: String }],
    },
    {
        timestamps: true,
    }
);

const Reviews = mongoose.model("Reviews", reviewSchema);

module.exports = Reviews;
