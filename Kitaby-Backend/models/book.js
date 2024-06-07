const mongoose=require('mongoose')
const uniqueValidator = require('mongoose-unique-validator');

const bookSchema=new mongoose.Schema({
    reviews: {type:[{
        username: { type: String, required: true },
        rating: { type: Number, required: true },
        comment: { type: String, required: false }
    }],default:[]},
    isbn:{
        type:String,
        required:[true,'provide the books isbn'],
        unique: true,
    },
    title:{
        type:String,
        required:[true,'provide the books title']
    },
    image:{
        type:String,
        required:[true,'provide the books image']
    },
    author:{
        type:String,
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
    bibOwners: {
        type:[mongoose.Types.ObjectId],
        required:true
    },
    owners:{
        type:[mongoose.Types.ObjectId],
        required:[true,'no user'],
        ref:'USER'
    }
},{timestamps: true})

bookSchema.plugin(uniqueValidator);

module.exports = mongoose.model('Book', bookSchema);