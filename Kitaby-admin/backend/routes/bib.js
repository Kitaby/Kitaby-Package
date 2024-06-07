const express=require('express')

const router=express.Router()

const {showBibs, getAvailableBooks, getReservedBooks,getOnHoldBooks,acceptBookRequest,getRequestedBooks,requestBook, giveBook,addBook ,checkOnHoldBooks,getExpiredBooks, createBib, getUsers, getReservations, getBooks}=require('../controllers/bib')




router.route('/addBook').post(addBook)//done
router.route('/requestBook').post(requestBook)//done
router.route('/getRequestedBooks/:bibId').get(getRequestedBooks)// to change to req.auth
router.route('/acceptBookRequest').patch(acceptBookRequest)//done
//
router.route('/getOnHoldBooks/:bibId').get(getOnHoldBooks)//done
router.route('/getavailablebooks/:bibId').get(getAvailableBooks)
//filters wilaya w author title categories
//before searchin, lowercase
//refuse offer
//email for code to take book
//cancel loan
//save the sent codes
//report admin in case majach
//renew loan expired becomes reserved
//search
//pagination for recommendations


router.route('/getReservedBooks/:bibId').get(getReservedBooks)//done
router.route('/checkOnHoldBooks').get(checkOnHoldBooks)//done
//return only creation date
router.route('/getreservations').get(getReservations)//done
router.route('/givebook').get(giveBook)//done
router.route('/getExpiredBooks/:bibId').get(getExpiredBooks);


router.route('/getusers').get(getUsers)
router.route('/getbooks').get(getBooks)
router.route('/createBib').get(createBib)
router.route('/showBibs').get(showBibs)



module.exports=router
