const express = require("express");

const router = express.Router();

const {
  getWishlist,
  getCollection,
  getAllBooks,
  getBooks,
  getBookInfo,
  getLibsBooks,
  getRecommendations,
  addRating,
  getRatings,
  isBookAvailable,
  isBookOwned,
  calculateRating,recentlyAdded
} = require("../controllers/home");

const auth = require("../middleware/auth");

router.get("/getAllBooks",auth, getAllBooks);
router.get("/getBooks",auth, getBooks);
router.get("/getCollection",auth, getCollection);
router.get("/getWishlist",auth, getWishlist);
router.get("/getBook/:isbn",auth, getBookInfo);
router.get('/getLibsBooks', getLibsBooks)
router.get("/getrecommendations", auth, getRecommendations);
router.post("/addRating",auth, addRating);
router.get("/getRatings/:isbn",auth, getRatings);
router.get('/isBookAvailable/:isbn',auth, isBookAvailable)
router.get('/isBookOwned/:isbn',auth, isBookOwned)
router.get('/calculateRating/:isbn',auth, calculateRating)
router.get('/recent',auth, recentlyAdded)
module.exports = router;
