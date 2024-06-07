const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const OtpStuffSchema=mongoose.Schema({
    phone: { type: String, required: true, unique: true },
    expires:{type:Number,required:true},
    done:{type:Boolean}
});

OtpStuffSchema.plugin(uniqueValidator);

module.exports = mongoose.model('OtpStuff', OtpStuffSchema);