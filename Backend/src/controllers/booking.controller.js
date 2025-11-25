const Customers = require("../models/customers.model");
const Products = require("../models/products.model");
const Vendors = require("../models/vendors.model");
const Bookings = require("../models/bookings.model");

const mongoose = require("mongoose");

// book an product
const bookItem = async (req, res) => {
    try {
        const { productId, customerId, count, startDateTime, endDateTime, price } = req.body;
        const productObjectId = new mongoose.Types.ObjectId(productId);
        const customerObjectId = new mongoose.Types.ObjectId(customerId);

        const booking = new Bookings({
            customerId: customerObjectId,
            productId: productObjectId,
            count: count,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            status: "pending",
            price: price,
        });

        await booking.save();

        return res.status(200).json({
            success: true,
            message: "Your booking is placed successfully. Owner will need to accept your request",
        });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// accept the request by the vendor
const acceptBooking = async (req, res) => {
    try {
        const { bookingId } = req.body;
        const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
        const booking = await Bookings.findOneAndUpdate(
            { _id: bookingObjectId },
            { status: "confirmed" },
            { new: true }
        );
        return res.status(200).json({ success: true, message: "Your request is confirmed" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// start the initiation
const activeBooking = async (req, res) => {
    try {
        const { bookingId } = req.body;
        const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
        const booking = await Bookings.findOneAndUpdate(
            { _id: bookingObjectId },
            { status: "active" },
            { new: true }
        );
        return res.status(200).json({ success: true, message: "Picked up the vehicle or object" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// // ongoing
// const userStartedBooking = async (req, res) => {
//     try {
//         const { bookingId } = req.body;
//         const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
//         const booking = await Bookings.findOneAndUpdate(
//             { _id: bookingObjectId },
//             { status: "ongoing" },
//             { new: true }
//         );
//         return res.status(200).json({ success: true, message: "Your are started" });
//     } catch (err) {
//         console.log("Error is: ", err);
//         return res.status(500).json({ success: false, message: "Server Error !" });
//     }
// };

// cancelled by the use
const cancelledByUser = async (req, res) => {
    try {
        const { bookingId } = req.body;
        const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
        const booking = await Bookings.findOneAndUpdate(
            { _id: bookingObjectId },
            { status: "cancelled by user" },
            { new: true }
        );
        return res.status(200).json({ success: true, message: "User cancelled the booking" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// cancelled by the admin or refuse the request
const cancelledByVendor = async (req, res) => {
    try {
        const { bookingId } = req.body;
        const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
        const booking = await Bookings.findOneAndUpdate(
            { _id: bookingObjectId },
            { status: "cancelled by vendor" },
            { new: true }
        );
        return res
            .status(200)
            .json({ success: true, message: "Admin cancelled the booking or request" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// returned sucessful
const returnedSuccessfully = async (req, res) => {
    try {
        const { bookingId } = req.body;
        const bookingObjectId = new mongoose.Types.ObjectId(bookingId);
        const booking = await Bookings.findOneAndUpdate(
            { _id: bookingObjectId },
            { status: "returned" },
            { new: true }
        );
        return res
            .status(200)
            .json({ success: true, message: "Returned the product successfully" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// customer bookings
const customerBookings = async (req, res) => {
    try {
        const { customerId } = req.params;
        const customerObjectId = new mongoose.Types.ObjectId(customerId);

        const booking = await Bookings.aggregate([
            {
                $match: {
                    customerId: customerObjectId,
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
                $lookup: {
                    from: "products",
                    localField: "productId",
                    foreignField: "_id",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
        ]);

        return res.status(200).json({
            success: true,
            message: "Customer bookings get successful",
            bookings: booking,
        });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// vendor bookings
const vendorBookings = async (req, res) => {
    try {
        const { vendorId } = req.params;
        const vendorObjectId = new mongoose.Types.ObjectId(vendorId);

        const booking = await Bookings.aggregate([
            {
                $match: {
                    vendorId: vendorObjectId,
                },
            },
            {
                $limit: 1,
            },
            {
                $project: {
                    vendorId: 1,
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "_id",
                    foreignField: "productId",
                    as: "booking",
                },
            },
            {
                $unwind: {
                    path: "$booking",
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "booking.productId",
                    foreignField: "_id",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
        ]);

        return res.status(200).json({
            success: true,
            message: "vendor bookings get successful",
            bookings: booking,
        });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

//count of all rentals
const rentalsCount = async (req, res) => {
    try {
        const { vendorId } = req.params;
        console.log(vendorId);
        const count = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [
                        { "bookings.status": "active" },
                        { "bookings.status": "confirmed" },
                        { "bookings.status": "returned" },
                    ],
                },
            },
            {
                $group: {
                    _id: "_id",
                    myCount: { $sum: 1 },
                },
            },
            {
                $project: {
                    count: "$myCount",
                    _id: 0,
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "Count provided for all rentals", count: count });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// count of all request
const requestsCount = async (req, res) => {
    try {
        const { vendorId } = req.params;
        // console.log(vendorId);
        const count = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [{ "bookings.status": "pending" }],
                },
            },
            {
                $group: {
                    _id: "_id",
                    myCount: { $sum: 1 },
                },
            },
            {
                $project: {
                    requests: "$myCount",
                    _id: 0,
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "Count provided for all requests", count: count });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// active rentals
const activeRentals = async (req, res) => {
    try {
        const { vendorId } = req.params;
        // console.log(vendorId);
        const bookings = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                    // _id: vendorId,
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [{ "bookings.status": "active" }],
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "All ongoing orders", bookings: bookings });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

//completed rentals
const completedRentals = async (req, res) => {
    try {
        const { vendorId } = req.params;
        // console.log(vendorId);
        const completedBookings = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [{ "bookings.status": "returned" }],
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "All completed orders", bookings: completedBookings });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

//upcoming rentals
const confirmedRentals = async (req, res) => {
    try {
        const { vendorId } = req.params;
        // console.log(vendorId);
        const confirmedBookings = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [{ "bookings.status": "confirmed" }],
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "All confirmed orders", bookings: confirmedBookings });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// pending requests
const pendingRentals = async (req, res) => {
    try {
        const { vendorId } = req.params;
        // console.log(vendorId);
        const pendingBookings = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $match: {
                    $or: [{ "bookings.status": "pending" }],
                },
            },
        ]);

        return res
            .status(200)
            .json({ success: true, message: "All pending orders", bookings: pendingBookings });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

// accepted request
// same as upcomfing

// total revenue
const totalRevenue = async (req, res) => {
    try {
        const { vendorId } = req.params;
        const totalRevenue = await Vendors.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(vendorId),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "vendorId",
                    as: "product",
                },
            },
            {
                $unwind: {
                    path: "$product",
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                },
            },
            {
                $group: {
                    _id: "_id",
                    totalRevenue: {
                        $sum: { $toInt: "$bookings.price" },
                    },
                },
            },
            {
                $project: {
                    totalRevenue: 1,
                    _id: 0,
                },
            },
        ]);

        return res.status(200).json({
            success: true,
            message: "Total revenue get successfully",
            totalRevenue: totalRevenue,
        });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

module.exports = {
    bookItem,
    acceptBooking,
    activeBooking,
    // startBooking,
    // userStartedBooking,
    cancelledByUser,
    cancelledByVendor,
    returnedSuccessfully,
    customerBookings,
    vendorBookings,
    rentalsCount,
    requestsCount,
    activeRentals,
    completedRentals,
    confirmedRentals,
    pendingRentals,
    totalRevenue,
};
