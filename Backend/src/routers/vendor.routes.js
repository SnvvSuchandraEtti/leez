const express = require("express");

const router = express.Router();

const vendorController = require("../controllers/vendor.controller");

// image
const { upload } = require("../utils/storage");

//signup
router.post("/signup", vendorController.signup);

//login
router.post("/login", vendorController.login);

//verify-otp
router.post("/verify-otp", vendorController.verifyOtp);

//create account
router.post("/create-account", vendorController.createAccount);

//update profile
router.get("/get-vendor-products", vendorController.getVendorProducts);

module.exports = router;
