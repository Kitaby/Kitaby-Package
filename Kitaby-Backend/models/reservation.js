const mongoose=require('mongoose')

const ReservationSchema=new mongoose.Schema({

    reserver:{
        type:mongoose.Types.ObjectId,
        required:[true,'provide the reserver id']
    }
    ,

    bib:{
        type:mongoose.Types.ObjectId,
        required:[true,'provide the bib name']
    },
    isbn:{
        type:String,
        required:[true,'provide the book isbn']
    },
    date:{
        type:Date,
        default:new Date()
    },
    status:{
        type:String,
        enum:['requested','on hold','expired','reserved']
    },

}, {timestamps:true})

module.exports=mongoose.model('reservation',ReservationSchema)