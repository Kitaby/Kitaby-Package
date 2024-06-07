const mongoose = require('mongoose');

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

module.exports =
    mongoose.models.Comment || mongoose.model('Comment', commentSchema);