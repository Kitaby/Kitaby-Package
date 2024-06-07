const express=require('express')

const router=express.Router()
const multer = require('../middleware/multer-config')
const auth = require('../middleware/auth');
const {change_pp, delete_pp} = require('../controllers/profile');

const {postBookInCollection, postBookInWishlist}=require("../controllers/profile")

router.route("/postBookInCollection").post(postBookInCollection)
router.route("/postInWishList").post(postBookInWishlist)
router.post('/change_pp',auth,multer, change_pp);
router.delete('/delete_pp',auth, delete_pp);


module.exports = router;