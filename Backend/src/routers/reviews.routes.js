const express = require("express");

const router = express.Router();

const { giveReview, getReview, getRating } = require("../controllers/reviews.controller");

// images
const { upload } = require("../utils/storage");

//give-review
router.post("/give-review", upload.array("images", 6), giveReview);

//get-review by product id
router.get("/get-reviews/:productId", getReview);

// get-average-rating
router.get("/get-rating/:productId", getRating);

module.exports = router;
