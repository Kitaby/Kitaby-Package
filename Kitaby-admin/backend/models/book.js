const mongoose = require('mongoose');



const BookSchema=new mongoose.Schema({
    isbn:{
        type:String,
        required:[true,'provide the books isbn'],
        unique: true,
    }
    ,

    title:{
        type:String,
        required:[true,'provide the books title']
    },
    image:{
        type:String,
        required:[true,'provide the books image']
    },
    author:{
        type: String,
        default: 'unknown', //for testing only
        required:[true,'provide the books author']
    },

    language:{
        type:String,
        //required:[true,'provide the books language']
    },

    description:{
        type:String,
        //required:[true,'provide the book description']
    },

    categories:{
    type:[String],
        required:[true,'provide the books category']
    },


    bibOwners: [{
        type: String, required: true ,
    }],
    owners:{
        type:[mongoose.Types.ObjectId],
        required:[true,'no user'],
        ref:'USER'
    },
    reviews: [{
        username: { type: String, required: true },
        rating: { type: Number, required: true },
        comment: { type: String, required: false }
    }]
    
    
}, {timestamps:true})

const Book=mongoose.model('book',BookSchema)

module.exports=Book

module.exports.bookSchema = BookSchema;
