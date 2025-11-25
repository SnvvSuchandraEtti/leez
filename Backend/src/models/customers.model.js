const mongoose = require("mongoose");

const customerSchema = new mongoose.Schema({
    name: { type: String, required: true },
    phoneNo: { type: String },
    email: { type: String, required: true },
    password: { type: String },
    photo: { type: String },
});

const Customers = mongoose.model("customers", customerSchema);

module.exports = Customers;
