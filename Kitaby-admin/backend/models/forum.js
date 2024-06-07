const mongoose = require('mongoose');



const replySchema = mongoose.Schema({
    author_id: {type:mongoose.Types.ObjectId, required: true},
    author_name:{type:String,required:true},
    author_photo:{type:String,required:true},
    upvotes: { type:Number, required: true,default:0 },
    upvoters: { type:[mongoose.Types.ObjectId]},
    content:{type:String,required:true},
    created_at: {type:Date, required:true},
    reply_to:{type:mongoose.Types.ObjectId, required: true}  //comment OR reply
});

const commentSchema = mongoose.Schema({
    author_id: {type:mongoose.Types.ObjectId, required: true},
    author_name:{type:String,required:true},
    author_photo:{type:String,required:true},
    upvotes: { type:Number, required: true,default:0 },
    upvoters: { type:[mongoose.Types.ObjectId]},
    content:{type:String,required:true},
    created_at: {type:Date, required:true},
    reply_to:{type:mongoose.Types.ObjectId, required: true},  //thread
    replies:{type:[mongoose.Types.ObjectId]}, //replies
    mark:{type:Number,required:true,default:0},
    last_interaction: {type:Date, required:true}
});

const threadSchema = mongoose.Schema({
    author_id: {type:mongoose.Types.ObjectId, required: true},
    author_name:{type:String,required:true},
    author_photo:{type:String,required:true},
    upvotes: { type:Number, required: true,default:0 },
    upvoters: { type:[mongoose.Types.ObjectId]},
    title: { type:String,required:true},
    content:{type:String,required:true},
    created_at: {type:Date, required:true},
    reply_to: {type:mongoose.Types.ObjectId, required:true},
    replies:[{id:{type:mongoose.Types.ObjectId},mark:{type:Number,default:0}}], //comments
    mark:{type:Number,required:true,default:0},
    last_interaction: {type:Date, required:true}
});

const reportSchema = mongoose.Schema({
    description: { type:[String]},
    model:{type:String,required:true},
    reported: {type:mongoose.Types.ObjectId, required:true,unique:true},
    reporters:{type:[mongoose.Types.ObjectId]},
    reports:{type:Number,required:true,default:1},
  });

const categorieSchema = mongoose.Schema({
    title: { type:String,required:true},
    follows: { type:Number, required: true,default:0 },
    threads:[{id:{type:mongoose.Types.ObjectId},mark:{type:Number,default:0}}], //comments
    followers:{type:[mongoose.Types.ObjectId]},
    mark:{type:Number,required:true,default:0}
  });


const Comment = mongoose.model('Comment', commentSchema);
const Reply = mongoose.model('Reply', replySchema);
const Thread = mongoose.model('Thread', threadSchema);
const Categorie = mongoose.model('Categorie', categorieSchema);
const Report = mongoose.model('Report', reportSchema);

module.exports = { Thread, Comment , Reply , Categorie ,Report};