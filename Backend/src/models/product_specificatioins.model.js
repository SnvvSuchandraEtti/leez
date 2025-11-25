const mongoose = require("mongoose");

const productSpecificationSchema = new mongoose.Schema({
    specificationId: { type: mongoose.Schema.Types.ObjectId, ref: "specifications" },
    value: { type: String, required: true },
    productId: { type: mongoose.Schema.Types.ObjectId, ref: "products" },
});

const ProductSpecifications = mongoose.model("productSpecifications", productSpecificationSchema);

module.exports = ProductSpecifications;
