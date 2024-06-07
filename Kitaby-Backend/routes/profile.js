const express = require('express');
const router = express.Router();

const multer = require('../middleware/multer-config')
const auth = require('../middleware/auth');
const profileCtrl = require('../controllers/profile');

router.post('/change_pp',auth,multer, profileCtrl.change_pp);
router.delete('/delete_pp',auth, profileCtrl.delete_pp);
router.post('/change_profile',auth, profileCtrl.change_profile);
router.get('/get_post',auth, profileCtrl.get_post);
router.get('/get_profile',auth, profileCtrl.get_profile);
router.get('/getReservations',auth, profileCtrl.getResrvations);
router.post('/requestBook',auth, profileCtrl.requestBook);
router.post('/postBookInCollection',auth, profileCtrl.postBookInCollection);
router.post('/postInWishList',auth, profileCtrl.postBookInWishlist);
router.put('/renewRequest',auth, profileCtrl.renewRequest);
router.put('/cancelReservation',auth, profileCtrl.cancelReservation);
router.put('/endBookReservation',auth, profileCtrl.endBookReservation);

module.exports = router;