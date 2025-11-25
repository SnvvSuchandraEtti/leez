const express = require("express");

const router = express.Router();

const bookingController = require("../controllers/booking.controller");

// 1. Book an item
router.post("/book", bookingController.bookItem);

// 2. Accept a booking request (by vendor)
router.post("/accept", bookingController.acceptBooking);

// 3. Vendor marks product as provided
router.post("/start", bookingController.activeBooking);

// 4. User confirms usage has started
// router.post("/user-started", bookingController.userStartedBooking);

// 5. Cancelled by user
router.post("/cancel/user", bookingController.cancelledByUser);

// 6. Cancelled by admin/vendor
router.post("/cancel/vendor", bookingController.cancelledByVendor);

// 7. Booking returned successfully
router.post("/return", bookingController.returnedSuccessfully);

// Get booking by customerId
router.get("/customer-bookings/:customerId", bookingController.customerBookings);

// Get booking by
router.get("/vendor-bookings/:vendorId", bookingController.vendorBookings);

// request for the vendor by vendorId
// router.get("/requests", bookingController.requests);

// count for all rentals
router.get("/rentals-count/:vendorId", bookingController.rentalsCount);

// booking count for all request
router.get("/requests-count/:vendorId", bookingController.requestsCount);

// all active rentals
router.get("/active-rentals/:vendorId", bookingController.activeRentals);

// all completed rentals
router.get("/completed-rentals/:vendorId", bookingController.completedRentals);

// all completed rentals
router.get("/confirmed-rentals/:vendorId", bookingController.confirmedRentals);

//all pending rentals
router.get("/pending-rentals/:vendorId", bookingController.pendingRentals);

//total revenue
router.get("/total-revenue/:vendorId", bookingController.totalRevenue);

module.exports = router;
