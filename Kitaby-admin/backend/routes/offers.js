const express=require('express')

const router=express.Router()

const {getReceivedOffers,getOffer,acceptOffer,postOffer, getSentOffers}=require('../controllers/offers')



router.route('/getReceivedOffers/:id').get(getReceivedOffers)
router.route('/getSentOffers/:id').get(getSentOffers)

router.route('/:id').get(getOffer)
router.route('/acceptOffer').patch(acceptOffer)

router.route('/postOffer').post(postOffer)

module.exports=router