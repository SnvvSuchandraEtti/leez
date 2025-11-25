const otpGenerator = require("otp-generator");
const { sendMail } = require("../utils/mail");
const OTP = require("../models/otp.model");
const Vendor = require("../models/vendors.model");
const Products = require("../models/products.model");

const mongoose = require("mongoose");

// vendor signup
const signup = async (req, res) => {
    try {
        const { email, phoneNo } = req.body;
        const user = await Vendor.findOne({ email: email } || { phoneNo: phoneNo });
        if (user) {
            return res
                .status(400)
                .json({ success: true, message: "User already exists with email or password" });
        }

        const otp = otpGenerator.generate(4, { specialChars: false });
        const userOtpObject = new OTP({ email: email, otp: otp });
        userOtpObject.save();
        const status = sendMail(
            email,
            "Otp is valid for 10 minutes",
            `Your otp for signup in leez is ${otp}`
        );
        if (!status) return res.status(500).json({ success: true, message: "Mail error" });
        return res.status(200).json({ success: true, message: "Otp sent successfully" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server error !" });
    }
};
      
// create account after validation
const createAccount = async (req, res) => {
    try {
        const { email, phoneNo, name, password } = req.body;
        const customerObject = new Vendor({
            email: email,
            phoneNo: phoneNo,
            name: name,
            password: password,
        });
        await customerObject.save();
        return res.status(200).json({ success: true, message: "Account creation successful" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server error !" });
    }
};
     
// verify otp
const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        const otpObject = await OTP.find({ email: email, otp: otp });
        if (otpObject.length == 0) {
            return res.status(200).json({ success: true, message: "Not a valid otp" });
        }
        return res.status(200).json({ success: true, message: "Otp verification successful" });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ success: false, message: "Server error!" });
    }
};
     
// vendor login
const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log(body);

        const user = await Vendor.findOne({ email: email } || { phoneNo: email });
        if (user.length == 0) {
            return res.status(400).json({ success: false, message: "No user exists" });
        }
        if (user.password === password) {
            return res.status(200).json({ success: true, message: "User login successful" });
        } else {
            return res.status(400).json({ success: false, message: "Wrong password" });
        }
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: false, message: "Server error !" });
    }
};
    
//get all products of vendor
const getVendorProducts = async (req, res) => {
    try {
        const { vendorId } = req.query;
        console.log(vendorId);
        const vendorObjectId = new mongoose.Types.ObjectId("684fb005ef0c1addb3ee47f3");

        const vendor = await Vendor.findById(vendorObjectId);
        console.log(vendor);
        const products = await Products.find({ vendorId: vendorObjectId });

        return res.json({
            success: true,
            message: "vendor products get successful",
            products: products,
        });
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: false, message: "Server error !" });
    }
};
    


module.exports = {
    signup,
    login,
    createAccount,
    verifyOtp,
    getVendorProducts,
};

