const mongoose = require('mongoose');

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

module.exports= mongoose.models.Thread ||mongoose.model('Thread', threadSchema);
