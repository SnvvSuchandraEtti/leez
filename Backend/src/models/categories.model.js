const mongoose = require("mongoose");

const categorySchmea = new mongoose.Schema({
    name: { type: String, required: true },
});

const Category = mongoose.model("categories", categorySchmea);

module.exports = Category;
