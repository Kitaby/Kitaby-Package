const mongoose = require('mongoose');

const reportSchema = mongoose.Schema({
    description: { type:[String]},
    model:{type:String,required:true},
    reported: {type:mongoose.Types.ObjectId, required:true,unique:true},
    reporters:{type:[mongoose.Types.ObjectId]},
    reports:{type:Number,required:true,default:1},
  }, { timestamps: true });
  module.exports = mongoose.models.Report || mongoose.model('Report', reportSchema);
  //changed because of the error: OverwriteModelError: Cannot overwrite `Report` model once compiled.