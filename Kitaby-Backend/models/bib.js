const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const bibSchema = mongoose.Schema({
    photo:{type:String,default:"images/LIBRARY.jpg"},
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    name: { type:String,required:true},
    phone:{type:String,required:true,unique: true},
    address:{type:String,required:true,unique: true},
    wilaya:{type:String,required:true,default:'sidi bel abbes'},
    com_reg_num:{type:String,required:true,unique: true},
    admis:{type:Boolean,required:true,default:false},
    avalaibleBooks:[{
        isbn: {
            type: String,
            ref: 'book' 
        },
        quantity: {
            type:Number,
            default:1,
        }
    }],
    reservations:[{
        type:mongoose.Schema.Types.ObjectId,
        ref:'Reservation'
    }],
    //fields for auth features only:
    verified: {type: Boolean, required:true},
    verifyLink:{type:String,unique:true},
    resetPasswordToken:{type:String},
    resetPasswordExpires:{type:String}
},{ timestamps: true });

bibSchema.plugin(uniqueValidator);

module.exports = mongoose.model('Bib', bibSchema);