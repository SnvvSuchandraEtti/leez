const express = require("express");

const router = express.Router();

const {
    addProduct,
    getAllProducts,
    getProductsByCategory,
    getProductDetailsById,
} = require("../controllers/products.controller");

// images
const { upload } = require("../utils/storage");
const Products = require("../models/products.model");

// add-product
router.post("/add-product", upload.array("images", 10), addProduct);

// update-product

// delete-prodcut

// get product details by b
router.get("/products-by-category/:categoryId", getProductsByCategory);

// get all product details
router.get("/all-products", getAllProducts);

router.get("/get-product-by-id", getProductDetailsById);

module.exports = router;
