const Specifications = require("../models/specifications.model");
const Category = require("../models/categories.model");


// add - specificatioins
const addSpecification = async (req, res) => {
    try {
        const { category, name } = req.body;
        const findCategory = await Category.findOne({ name: category });
        if (!findCategory)
            return res.status(400).json({ success: false, message: "Category not found" });

        const newObject = new Specifications({ category_id: findCategory._id, name: name });
        newObject.save();

        return res.status(200).json({ success: true, message: "Specification added successfully" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: false, message: "Server Error !" });
    }
};

module.exports = {
    addSpecification,
};
