const express=require('express');
const { findUserChats,createChat, findChat } = require('../controllers/chat');

const router=express.Router();

router.post("/",createChat)

router.get("/",findUserChats)

router.get("/find/:firstId/:secondId",findChat)

module.exports=router




