const express = require("express");

const router = express.Router();

const { addToFavorite, removeFromFavorite, getAllFavorites } = require("../controllers/favorites.controller");

// add to favorites
router.post("/add-to-favorite", addToFavorite);

// remove from the favorites
router.post("/remove-from-favorite", removeFromFavorite);
 
//get favorite products by userId
// router.get("/get-favorite-products", getFavoriteProducts);

router.get("/get-all-favorites", getAllFavorites);


module.exports = router;
