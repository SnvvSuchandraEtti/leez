const Vendor = require("../models/vendors.model");
const Category = require("../models/categories.model");
const Product = require("../models/products.model");
const ProductSpecifications = require("../models/product_specificatioins.model");
const Specifications = require("../models/specifications.model");

const mongoose = require("mongoose");
// add product
const addProduct = async (req, res) => {
    try {
        //   console.log("Request Body:", JSON.stringify(req.body, null, 2));

        // console.log("hello");
        const { email, name, category, price, description, count, longitude, latitude } = req.body;
        console.log(req.body);
        const vendorId = await Vendor.findOne({ email: email });
        const categoryId = await Category.findOne({ name: category });

        console.log("hello");
        const product = await Product.findOne({
            vendorId: vendorId._id,
            name: name,
            categoryId: categoryId._id,
        });

        console.log(product);

        console.log("hello");

        if (product) {
            return res.status(400).json({ success: false, message: "Product already exists" });
        }

        const imageUrls = req.files.map((file) => file.filename);

        const newProduct = new Product({
            vendorId: vendorId._id,
            name: name,
            categoryId: categoryId._id,
            price: price,
            description: description,
            count: count,
            longitude: parseFloat(longitude),
            latitude: parseFloat(latitude),
            images: imageUrls,
        });

        await newProduct.save();
        const productId = await Product.findOne({ name: name });

        console.log(newProduct);

        // build specifications manually from form-data
        const specifications = [];
        for (let i = 0; i < 4; i++) {
            const key = req.body[`specifications[${i}].key`];
            const value = req.body[`specifications[${i}].value`];
            const specification = await Specifications.findOne({ name: key });
            console.log(specification);
            const productSpecifications = new ProductSpecifications({
                specificationId: specification._id,
                value: value,
                productId: productId._id,
            });

            await productSpecifications.save();
        }
        return res.status(200).json({ success: true, message: "Product added successfully" });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: true, message: "Server Error !" });
    }
};

// get all products
const getAllProducts = async (req, res) => {
    try {
        // const products = await Category.aggregate([
        //     {
        //         $lookup: {
        //             from: "products",
        //             localField: "_id",
        //             foreignField: "categoryId",
        //             as: "result",
        //         },
        //     },
        //     {
        //         $unwind: {
        //             path: "$result",
        //         },
        //     },
        //     {
        //         $lookup: {
        //             from: "favorites",
        //             localField: "result._id",
        //             foreignField: "productId",
        //             as: "status",
        //         },
        //     },
        //     {
        //         $unwind: {
        //             path: "$status",
        //             preserveNullAndEmptyArrays: true,
        //         },
        //     },
        // ]);

        const products = await Category.aggregate([
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "categoryId",
                    as: "product",
                },
            },
            {
                $unwind: "$product",
            },

            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                    preserveNullAndEmptyArrays: true,
                },
            },

            {
                $lookup: {
                    from: "reviews",
                    localField: "bookings._id",
                    foreignField: "bookingId",
                    as: "review",
                },
            },
            {
                $unwind: {
                    path: "$review",
                    preserveNullAndEmptyArrays: true,
                },
            },

            {
                $group: {
                    _id: "$product._id",
                    ratings: { $push: "$review.rating" },
                    productDetails: { $first: "$product" },
                },
            },

            {
                $project: {
                    _id: 1,
                    averageRating: {
                        $cond: [
                            {
                                $eq: [
                                    {
                                        $size: {
                                            $filter: {
                                                input: "$ratings",
                                                as: "r",
                                                cond: { $ne: ["$$r", null] },
                                            },
                                        },
                                    },
                                    0,
                                ],
                            },
                            null,
                            { $avg: "$ratings" },
                        ],
                    },
                    productDetails: 1,
                },
            },
            {
                $lookup: {
                    from: "favorites",
                    localField: "_id",
                    foreignField: "productId",
                    as: "status",
                },
            },
            {
                $unwind: {
                    path: "$status",
                    preserveNullAndEmptyArrays: true,
                },
            },
            {
                $project: {
                    _id: 0,
                    result: "$productDetails",
                    averageRating: 1,
                    status: 1,
                },
            },
        ]);
        return res
            .status(200)
            .json({ success: true, message: "Product get successfully", products: products });
    } catch (err) {
        console.log("Error is: ", err);
        return res.status(500).json({ success: true, message: "Server Error !" });
    }
};

// get products by category
const getProductsByCategory = async (req, res) => {
    try {
        const { categoryId } = req.params;
        console.log(categoryId);

        const category = await Category.findOne({ name: categoryId });
        console.log(category);

        const products = await Category.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(category),
                },
            },
            {
                $lookup: {
                    from: "products",
                    localField: "_id",
                    foreignField: "categoryId",
                    as: "product",
                },
            },
            {
                $unwind: "$product",
            },

            {
                $lookup: {
                    from: "bookings",
                    localField: "product._id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                    preserveNullAndEmptyArrays: true,
                },
            },

            {
                $lookup: {
                    from: "reviews",
                    localField: "bookings._id",
                    foreignField: "bookingId",
                    as: "review",
                },
            },
            {
                $unwind: {
                    path: "$review",
                    preserveNullAndEmptyArrays: true,
                },
            },

            {
                $group: {
                    _id: "$product._id",
                    ratings: { $push: "$review.rating" },
                    productDetails: { $first: "$product" },
                },
            },

            {
                $project: {
                    _id: 1,
                    averageRating: {
                        $cond: [
                            {
                                $eq: [
                                    {
                                        $size: {
                                            $filter: {
                                                input: "$ratings",
                                                as: "r",
                                                cond: { $ne: ["$$r", null] },
                                            },
                                        },
                                    },
                                    0,
                                ],
                            },
                            null,
                            { $avg: "$ratings" },
                        ],
                    },
                    productDetails: 1,
                },
            },
            {
                $lookup: {
                    from: "favorites",
                    localField: "_id",
                    foreignField: "productId",
                    as: "status",
                },
            },
            {
                $unwind: {
                    path: "$status",
                    preserveNullAndEmptyArrays: true,
                },
            },
            {
                $project: {
                    _id: 0,
                    result: "$productDetails",
                    averageRating: 1,
                    status: 1,
                },
            },
        ]);

        console.log(products);
        // console.log(categoryDoc);
        // if (!categoryDoc) {
        //     return res.status(404).json({ success: false, message: "Category not found" });
        // }

        // const products = await Category.aggregate([
        //     {
        //         $match: {
        //             name: categoryId,
        //         },
        //     },
        //     {
        //         $lookup: {
        //             from: "products",
        //             localField: "_id",
        //             foreignField: "categoryId",
        //             as: "result",
        //         },
        //     },
        //     {
        //         $unwind: {
        //             path: "$result",
        //         },
        //     },
        //     {
        //         $lookup: {
        //             from: "favorites",
        //             localField: "result._id",
        //             foreignField: "productId",
        //             as: "status",
        //         },
        //     },
        //     {
        //         $unwind: {
        //             path: "$status",
        //             preserveNullAndEmptyArrays: true,
        //         },
        //     },
        // ]);

        // console.log(products);

        return res.status(200).json({
            success: true,
            message: "All Products get successful",
            // categoryId: categoryDoc._id,
            products: products,
        });
    } catch (error) {
        console.error("Error fetching category ID:", error);
        return res.status(500).json({ success: false, message: "Server Error" });
    }
};

// get product details by  Id
const getProductDetailsById = async (req, res) => {
    try {
        const { productId } = req.query;

        console.log(productId);

        const product = await Product.aggregate([
            {
                $match: {
                    _id: new mongoose.Types.ObjectId(productId),
                },
            },
            {
                $lookup: {
                    from: "bookings",
                    localField: "_id",
                    foreignField: "productId",
                    as: "bookings",
                },
            },
            {
                $unwind: {
                    path: "$bookings",
                    preserveNullAndEmptyArrays: true,
                },
            },
            {
                $lookup: {
                    from: "reviews",
                    localField: "bookings._id",
                    foreignField: "bookingId",
                    as: "review",
                },
            },
            {
                $unwind: {
                    path: "$review",
                    preserveNullAndEmptyArrays: true,
                },
            },
            {
                $group: {
                    _id: "$_id",
                    ratings: {
                        $push: {
                            $cond: [
                                { $ne: ["$review.rating", null] },
                                "$review.rating",
                                "$$REMOVE",
                            ],
                        },
                    },
                    productDetails: { $first: "$$ROOT" },
                },
            },
            {
                $project: {
                    _id: 0,
                    productDetails: {
                        _id: "$productDetails._id",
                        vendorId: "$productDetails.vendorId",
                        name: "$productDetails.name",
                        categoryId: "$productDetails.categoryId",
                        price: "$productDetails.price",
                        description: "$productDetails.description",
                        views: "$productDetails.views",
                        images: "$productDetails.images",
                        longitude: "$productDetails.longitude",
                        latitude: "$productDetails.latitude",
                        count: "$productDetails.count",
                        createdAt: "$productDetails.createdAt",
                        updatedAt: "$productDetails.updatedAt",
                        __v: "$productDetails.__v",
                    },
                    averageRating: {
                        $cond: [{ $eq: [{ $size: "$ratings" }, 0] }, null, { $avg: "$ratings" }],
                    },
                },
            },
        ]);
        const specifications = await ProductSpecifications.aggregate([
            {
                $match: {
                    productId: new mongoose.Types.ObjectId(productId),
                },
            },
            {
                $lookup: {
                    from: "specifications",
                    localField: "specificationId",
                    foreignField: "_id",
                    as: "result",
                },
            },
            {
                $project: {
                    value: 1,
                    key: "$result.name",
                    _id: 0,
                },
            },
            {
                $unwind: {
                    path: "$key",
                },
            },
        ]);

        return res.json({ success: true, productDetails: product, specifications: specifications });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ success: false, message: "Servor Error" });
    }
};

module.exports = {
    addProduct,
    getAllProducts,
    getProductsByCategory,
    getProductDetailsById,
};
