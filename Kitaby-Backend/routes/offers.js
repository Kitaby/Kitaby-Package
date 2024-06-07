const express=require('express')

const router=express.Router()

const {getReceivedOffers,getOffer,acceptOffer,postOffer, getSentOffers,rejectOffer,cancelOffer}=require('../controllers/offers')



router.route('/getReceivedOffers').get(getReceivedOffers)
router.route('/getSentOffers').get(getSentOffers)

router.route('/').get(getOffer)
router.route('/acceptOffer').patch(acceptOffer)
router.route('/rejectOffer').patch(rejectOffer)
router.route('/cancelOffer').patch(cancelOffer)
router.route('/postOffer').post(postOffer)

module.exports=router