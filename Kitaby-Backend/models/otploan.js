const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const OtpLoanSchema=mongoose.Schema({
    loan_id: {type:mongoose.Types.ObjectId, required: true, unique: true },
    crypted_otp: { type: String, required: true},
    expires:{type:Number,required:true},
    done:{type:Boolean,required:true}
});

//hash otp+loanId and save it here, send otp and loanId here , you can replace loanId by bibname+bookname+username or whatever u want , 

OtpLoanSchema.plugin(uniqueValidator);

module.exports = mongoose.model('Otploan', OtpLoanSchema);