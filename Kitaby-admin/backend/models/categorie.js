const mongoose = require('mongoose');


const categorieSchema = mongoose.Schema({
    title: { type:String,required:true},
    follows: { type:Number, required: true,default:0 },
    threads:[{id:{type:mongoose.Types.ObjectId},mark:{type:Number,default:0}}], //comments
    followers:{type:[mongoose.Types.ObjectId]},
    mark:{type:Number,required:true,default:0}
  });

  module.exports=mongoose.model('Categorie', categorieSchema);