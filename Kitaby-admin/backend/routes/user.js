const express = require('express');
const router = express.Router();

const auth = require('../middleware/auth');
const userCtrl = require('../controllers/user');

router.post('/signup', userCtrl.signup);
router.post('/login', userCtrl.login);
router.post('/send_otp',userCtrl.send_otp);
router.post('/verify_otp',userCtrl.verify_otp);
router.post('/forgot_password',userCtrl.forgot_password);
router.post('/reset_password',userCtrl.reset_password);
router.use('/verify_email',userCtrl.verify_email);
router.post('/signout',auth,userCtrl.signout);



module.exports = router;