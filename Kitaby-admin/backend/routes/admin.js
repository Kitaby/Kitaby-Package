const express = require("express");

const router = express.Router();
const {
    getUsers,
    getBooks,
    getUserNum,
    getBookNum,
    getReports,
    getOffers,
    getBibs,
    getReservations,
    getBookInfo,
    getBookHistory,
    getExchangeHistory,
    getReservationHistory,
    getUserHistory,
    getBibHistory,
    deleteUser,
    getBibInfo,
    getUserInfo,
    getPendingBibs,
    acceptBib,
    rejectBib,
    deleteReported,
    banUser,
    getBibsNotRegistered,
} = require('../controllers/admin.controller')

router.route("/getusers").get(getUsers)
router.route("/getbooks").get(getBooks)
router.route("/getusernumbers").get(getUserNum)
router.route("/getbooknumbers").get(getBookNum)
router.route("/getoffers").get(getOffers)
router.route("/getbibs").get(getBibs)
router.route("/getbibsnotregistered").get(getBibsNotRegistered)
router.route("/getreports").get(getReports)
router.route("/getbookinfo/:title").get(getBookInfo)
router.route("/getlibrarydemandes").get()
router.route("/getbookhistory").get(getBookHistory)
router.route("/getreservationhistory").get(getReservationHistory)
router.route("/getexchangehistory").get(getExchangeHistory)
router.route("/getuserhistory").get(getUserHistory)
router.route("/getbibhistory").get(getBibHistory)
router.route("/").get() 
router.route("/deleteUser").delete(deleteUser) 
router.route("/getreservations").get(getReservations) 
router.route("/getbibinfo/:title").get(getBibInfo)
router.route("/getuserinfo/:name").get(getUserInfo)
router.route("/getPendingBibs").get(getPendingBibs)
router.route("/acceptbib/:name").get(acceptBib)
router.route("/rejectbib/:name").delete(rejectBib)
router.route("/deletereported/:id").delete(deleteReported)
router.route("/banuser/:id").get(banUser)


module.exports = router;