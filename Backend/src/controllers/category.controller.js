const Category = require("../models/categories.model");

// create category
const createCategory = async (req, res) => {
    try {
        const { category } = req.body;
        const findCategory = await Category.findOne({ name: category });
        if (findCategory)
            return res.status(400).json({ success: true, message: "Category already exists" });
        const object = new Category({ name: category });
        object.save();
        return res.status(200).json({ success: true, message: "Category added successfully" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ status: false, msg: "Sever error !" });
    }
};

module.exports = {
    createCategory,
};
