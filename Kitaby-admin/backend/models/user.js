const mongoose = require("mongoose");
const uniqueValidator = require('mongoose-unique-validator');
// const bcrypt=require('bcryptjs')
// const jwt=require('jsonwebtoken')
require("dotenv").config();

const UserSchema = new mongoose.Schema({
  banned:{type:Boolean,required:true,default:false},
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: { type: String, required: true },//for testing, it is gonna be false
  phone: { type: String, required: true, unique: true },
  categories: { type: [String], required: false },
  verified: { type: Boolean, required: true },
  verifyLink: { type: String, unique: true },
  ownedbooks: { type: [String] }, //list of isbn
  cart: { type: [String] }, //ancient wishlist , list of isbn same for wishlist
  wishlist: { type: [String] },
  offers_received: { type: [mongoose.Types.ObjectId] }, //see offers models
  offers_sent: { type: [mongoose.Types.ObjectId] },
  photo:{type:String,default:"../images/default.jpg"},
  resetPasswordToken: { type: String },
  resetPasswordExpires: { type: String },
  wilaya: { type: String },
  reservations: { type: [mongoose.Types.ObjectId] },
}, {timestamps:true});
UserSchema.plugin(uniqueValidator);
// UserSchema.pre('save',async function(next){
// const salt=await bcrypt.genSalt(10)
// this.password=await bcrypt.hash(this.password,salt)
// next()
// })

// UserSchema.methods.createToken=function(){
//     return jwt.sign({userID:this._id,name:this.name},process.env.JWT_SECRET,{expiresIn:process.env.JWT_LIFETIME})
// }

// UserSchema.methods.comparePasswords=async function(password){
//     return await bcrypt.compare(password,this.password)
// }

module.exports = mongoose.model("user", UserSchema);
