const otpGenerator = require("otp-generator");
const { sendMail } = require("../utils/mail");

const OTP = require("../models/otp.model");
const Customer = require("../models/customers.model");

// customer signup
const signup = async (req, res) => {
    try {
        console.log("hello");
        const { email, phoneNo } = req.body;
        const user = await Customer.findOne({ email: email } || { phoneNo: phoneNo });
        if (user) {
            return res
                .status(400)
                .json({ success: true, message: "User already exists with email or password" });
        }

        const otp = otpGenerator.generate(4, {
            specialChars: false,
            lowerCaseAlphabets: false,
            upperCaseAlphabets: false,
        });
        console.log("api");
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
        console.log("creating account");
        const { email, phoneNo, name, password } = req.body;

        const user = await Customer.findOne({ email: email } || { phoneNo: phoneNo });
        if (user) {
            return res
                .status(400)
                .json({ success: true, message: "User already exists with email or password" });
        }

        const customerObject = new Customer({
            email: email,
            phoneNo: phoneNo,
            name: name,
            password: password,
        });

        console.log("created account");
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
        console.log("verify otp");
        const { email, otp, phoneNo, name, password } = req.body;
        console.log(req.body);
          if (!email || !otp || !phoneNo || !name || !password) {
  return res.status(400).json({ success: false, message: "Missing required fields" });
}
        const otpObject = await OTP.findOne({ email: email, otp: otp });
        if (!otpObject) {
            return res.status(400).json({ success: false, message: "Not a valid OTP" });
        }
        const response = await fetch("http://localhost:5001/api/customer/create-account", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                email: email,
                phoneNo: phoneNo,
                name:name,
                password: password,
            }),
        });

        const data = await response.json();
        console.log("POST Response:", data);

        return res.status(200).json({
            success: true,
            message: "OTP verification successful and post account created",
            postResponse: data,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: "Server error!" });
    }
};

// customer login
const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log(req.body);
        const user = await Customer.findOne({ email: email } || { phoneNo: email });
        if (user.length == 0) {
            return res.status(400).json({ success: false, message: "No user exists" });
        }
        if (user.password == password) {
            return res.status(200).json({ success: true, message: "User login successful" });
        } else {
            return res.status(400).json({ success: false, message: "Wrong password" });
        }
    } catch (err) {
        console.log("Error is : ", err);
        return res.status(500).json({ success: false, message: "Server error !" });
    }
};
//customer details
const customer_details = async (req, res) => {
    try {
        const { id } = req.params;
        const customer = await Customer.findById(id);

        if (!customer) {
            return res.status(404).json({ success: false, message: "Customer not found" });
        }

        return res.status(200).json({ success: true, "Customer-details": customer });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};
//updateotp
const generateOtpForUpdate = async (req, res) => {
    try {
        const { email, phoneNo } = req.body;

        if (!email || !phoneNo) {
            return res.status(400).json({ success: false, message: "Email and phone number are required" });
        }
        await OTP.deleteMany({ email }); 

        const otp = await otpGenerator.generate(4, {
            upperCaseAlphabets: false,
            lowerCaseAlphabets: false,
            specialChars: false,
        });

        const otpDoc = new OTP({ email, otp, createdAt: new Date() });
        await otpDoc.save();

        const mailResult = await sendMail(
            email,
            "OTP for Signup",
            `Your OTP for signing up to Leez is ${otp}. It is valid for 10 minutes.`
        );

        return res.status(200).json({
            success: true,
            message: "OTP sent successfully to email",
            otpId: otpDoc._id,
        });

    } catch (err) {
        console.error("Signup OTP error:", err);
        return res.status(500).json({ success: false, message: "Server error while sending OTP" });
    }
};
//profile update

const verifyOtpAndUpdateCustomer = async (req, res) => {
    try {
        const { customerId, email, otp, name, phoneNo, photo, password } = req.body;

        console.log(req.file);

        if (!customerId || !email || !otp) {
            return res.status(400).json({ success: false, message: "Missing OTP or customer ID" });
        }

        const validOtp = await OTP.findOne({ email, otp});

        if (!validOtp) {
            return res.status(400).json({ success: false, message: "Invalid or expired OTP" });
        }

        const updateFields = {};
        if (name) updateFields.name = name;
        if (phoneNo) updateFields.phoneNo = phoneNo;
        if (req.file?.filename) updateFields.photo = req.file.filename;
        if (password) updateFields.password = password;

        const updatedCustomer = await Customer.findByIdAndUpdate(customerId, updateFields, {
            new: true,
        });

        if (!updatedCustomer) {
            return res.status(404).json({ success: false, message: "Customer not found" });
        }

        await OTP.deleteOne({ _id: validOtp._id });

        return res.status(200).json({
            success: true,
            message: "OTP verified and customer updated successfully",
            customer: updatedCustomer,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: "Server error" });
    }
};

module.exports = {
    signup,
    login,
    createAccount,
    verifyOtp,
    customer_details,
    generateOtpForUpdate,
    verifyOtpAndUpdateCustomer
};
