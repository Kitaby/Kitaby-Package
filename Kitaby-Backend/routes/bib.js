const express = require('express');
const router = express.Router();

const bibCtrl = require('../controllers/bib');
const bibauth = require('../middleware/authbib');
const mul = require('../middleware/multer-excel');

router.post('/signup', bibCtrl.signup);
router.post('/login', bibCtrl.login);
router.post('/send_otp',bibCtrl.send_otp);
router.post('/verify_otp',bibCtrl.verify_otp);
router.post('/forgot_password',bibCtrl.forgot_password);
router.post('/reset_password',bibCtrl.reset_password);
router.use('/verify_email',bibCtrl.verify_email);
router.post('/upload_excel',bibauth,mul,bibCtrl.update_excel);



module.exports = router;