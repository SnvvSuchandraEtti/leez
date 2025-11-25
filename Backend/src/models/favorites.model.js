const mongoose = require("mongoose");

const favoriteSchema = new mongoose.Schema({
    productId: { type: mongoose.Schema.Types.ObjectId, ref: "products", required: true },
    customerId: { type: mongoose.Schema.Types.ObjectId, ref: "customers", required: true},
});

const Favourites = mongoose.model("favorites", favoriteSchema);

module.exports = Favourites;

