const express = require('express');
const router = express.Router();

const auth = require('../middleware/auth');
const forumCtrl = require('../controllers/forum');

router.post('/post_thread',auth, forumCtrl.post_thread);
router.delete('/delete_thread',auth, forumCtrl.delete_thread);
router.post('/like_thread',auth, forumCtrl.like_thread);
router.post('/post_comment',auth, forumCtrl.post_comment);
router.delete('/delete_comment',auth, forumCtrl.delete_comment);
router.post('/like_comment',auth, forumCtrl.like_comment);
router.post('/post_reply',auth, forumCtrl.post_reply);
router.delete('/delete_reply',auth, forumCtrl.delete_reply);
router.post('/like_reply',auth, forumCtrl.like_reply);
router.get('/get_replies',auth,forumCtrl.get_replies);
router.post('/get_comments',auth,forumCtrl.get_comments);
router.get('/get_thread',auth,forumCtrl.get_thread);
router.get('/get_categories',auth,forumCtrl.get_categories);
router.post('/get_threads_of_categories',auth,forumCtrl.get_threads_of_categories);
router.get('/get_replies',auth,forumCtrl.get_replies);
router.post('/report',auth,forumCtrl.report);
router.get('/share_thread',auth,forumCtrl.share_thread);
router.get('/share_comment',auth,forumCtrl.share_comment);
router.get('/share_reply',auth,forumCtrl.share_reply);


module.exports = router;