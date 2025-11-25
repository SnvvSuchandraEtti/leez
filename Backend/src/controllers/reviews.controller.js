const mongoose = require("mongoose");
const Reviews = require("../models/reviews.model");
const Bookings = require("../models/bookings.model");

// give review
const giveReview = async (req, res) => {
    try {
        const { bookingId, rating, reviewText } = req.body;

        const imageUrls = req.files.map((file) => file.filename);

        const review = new Reviews({
            bookingId: new mongoose.Types.ObjectId(bookingId),
            rating: rating,
            reviewText: reviewText,
            images: imageUrls,
        });

        await review.save();
        return res.status(200).json({ success: true, message: "Review get successfully" });
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: true, message: "Server Error !" });
    }
};

// get-reviews
const getReview = async (req, res) => {
    try {
        const { productId } = req.params;
        console.log(req.params);

        const productObjectId = new mongoose.Types.ObjectId(productId);
        const reviews = await Bookings.aggregate([
            {
                $match: {
                    productId: productObjectId,
                },
            },
            {
                $lookup: {
                    from: "customers",
                    localField: "customerId",
                    foreignField: "_id",
                    as: "customer",
                },
            },
            {
                $unwind: {
                    path: "$customer",
                },
            },
            {
                $project: {
                    productId: 1,
                    customer: 1,
                },
            },
            {
                $lookup: {
                    from: "reviews",
                    localField: "_id",
                    foreignField: "bookingId",
                    as: "review",
                },
            },
            {
                $unwind: {
                    path: "$review",
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "Reviews get Successfully", reviews: reviews });
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: true, message: "Server Error !" });
    }
};

// get-rating
const getRating = async (req, res) => {
    try {
        const { productId } = req.params;
        console.log(req.params);

        const productObjectId = new mongoose.Types.ObjectId(productId);

        const rating = await Bookings.aggregate([
            {
                $match: {
                    productId: productObjectId,
                },
            },
            {
                $lookup: {
                    from: "customers",
                    localField: "customerId",
                    foreignField: "_id",
                    as: "customer",
                },
            },
            {
                $unwind: {
                    path: "$customer",
                },
            },
            {
                $project: {
                    productId: 1,
                    customer: 1,
                },
            },
            {
                $lookup: {
                    from: "reviews",
                    localField: "_id",
                    foreignField: "bookingId",
                    as: "review",
                },
            },
            {
                $unwind: {
                    path: "$review",
                },
            },
            {
                $project: {
                    rating: "$review.rating",
                    productId: 1,
                },
            },
            {
                $group: {
                    _id: "productId",
                    averageRating: { $avg: "$rating" },
                },
            },
        ]);
        return res.status(200).json({
            success: true,
            message: "Average Rating provided successfully",
            averageRating: rating,
        });
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: true, message: "Server Error !" });
    }
};

module.exports = {
    giveReview,
    getReview,
    getRating,
};
