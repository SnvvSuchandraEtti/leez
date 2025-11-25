const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
    {
        vendorId: { type: mongoose.Schema.Types.ObjectId, ref: "owners", required: true },
        name: { type: String, required: true },
        categoryId: { type: mongoose.Schema.Types.ObjectId, ref: "categories", required: true },
        price: { type: Number, required: true },
        availbilityStatus: { type: Boolean },
        description: { type: String },
        views: { type: Number, default: 0 },
        images: [String],
        longitude: { type: Number, required: true },
        latitude: { type: Number, required: true },
        count: { type: Number, default: 1 },
    },
    {
        timestamps: true,
    }
);

const Products = mongoose.model("products", productSchema);

module.exports = Products;
