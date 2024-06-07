const express = require("express");

const router = express.Router();

const {
  getBookByCategory,
  getWishlist,
  getCollection,
  getAllBooks,
  getBooks,
  getBookInfo,
  getRecommendations,
  addRating,
  getRatings,
  isBookAvailable,
  isBookOwned,
  calculateRating,
} = require("../controllers/home");

const auth = require("../middleware/auth");
router.get("/getrecommendations", auth, getRecommendations);
router.get("/getAllBooks",auth, getAllBooks);
router.get("/getBooks",auth, getBooks);
router.get("/getBook/:isbn",auth, getBookInfo);
router.get("/getCollection/:id",auth, getCollection);
router.get("/getWishlist/:id",auth, getWishlist);
router.get("/:category",auth, getBookByCategory);
router.post("/addRating",auth, addRating);
router.get("/getRatings/:isbn", getRatings);
router.get("/isbookavailable/:isbn", isBookAvailable)
router.get("/isbookowned/:isbn", isBookOwned)
router.get("/calculaterating/:isbn", auth, calculateRating)
module.exports = router;
