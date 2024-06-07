const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const userSchema = mongoose.Schema({
  banned:{type:Boolean,required:true,default:false},
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type:String,required:true},
  phone:{type:String,required:true,unique: true},
  categories: {type: [String], required:true,default:[]},
  verified: {type: Boolean, required:true},
  verifyLink:{type:String,unique:true},
  ownedbooks: {type :[String],default:[]}, //list of isbn
  cart:{type:[String],default:[]},                //ancient wishlist , list of isbn same for wishlist
  wishlist:{type:[String],default:[]},
  offers_received:{type:[mongoose.Types.ObjectId],default:[]}, //see offers models
  offers_sent:{type:[mongoose.Types.ObjectId],default:[]},
  photo:{type:String,default:"images/default.jpg"},
  wilaya:{type:String,required:true,default:"Tlemcen"},
  resetPasswordToken:{type:String},
  resetPasswordExpires:{type:String},
  reservations:{type:[mongoose.Types.ObjectId],default:[]}
},{timestamps: true});

userSchema.plugin(uniqueValidator);

module.exports = mongoose.model('User', userSchema);