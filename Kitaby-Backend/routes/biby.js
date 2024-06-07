const express=require('express')
const auth=require('../middleware/auth')
const router=express.Router()

const { getAvalaibleBooks,getReservedBooks,returnBook,getOnHoldBooks
    ,acceptBookRequest,getRequestedBooks,
     giveBook,addBook ,checkOnHoldBooks,getExpiredBooks,
    
    getRenewRequests,
    acceptRenewRequest,
    refuseBookRequest,
    refuseRenewRequest,
    reportUser,
}=require('../controllers/biby')





router.route('/getAvalaibleBooks').get(getAvalaibleBooks)
router.route('/addBook').post(addBook)
router.route('/getReservedBooks').get(getReservedBooks)
router.route('/getRequestedBooks').get(getRequestedBooks)
router.route('/acceptBookRequest').patch(acceptBookRequest)
router.route('/getOnHoldBooks').get(getOnHoldBooks)
router.route('/getExpiredBooks').get(getExpiredBooks)
router.route('/giveBook').put(giveBook)

router.route('/getRenewRequests').get(getRenewRequests);
router.route('/acceptRenewRequest').put(acceptRenewRequest)
router.route('/returnBook').put(returnBook)

router.route('/refuseBookRequest').put(refuseBookRequest)
router.route('/refuseRenewRequest').put(refuseRenewRequest)
router.route('/reportUser').post(reportUser)



module.exports = router;