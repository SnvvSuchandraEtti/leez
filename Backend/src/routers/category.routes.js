const express = require("express");

const router = express.Router();

const { createCategory } = require("../controllers/category.controller");


//create-category
router.post("/create-category", createCategory);


module.exports = router;


