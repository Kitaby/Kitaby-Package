const mongoose=require('mongoose')

const OfferSchema=new mongoose.Schema({

    bookOwner:{
        type:mongoose.Types.ObjectId,
        required:[true,'provide the user a']
    }//mol lktab
    ,

    bookBuyer:{
        type:mongoose.Types.ObjectId,
        //required:[true,'provide the user b']
    },

    demandedBook:{
        type:String,
        required:[true,'provide the book a isbn']
    },

    proposedBooks:{
        type:[String],
        //required:[true,'provide the books b isbn']
    },
    status:{
        type:String
    }

},{timestamps: true})

module.exports=mongoose.model('offer',OfferSchema)