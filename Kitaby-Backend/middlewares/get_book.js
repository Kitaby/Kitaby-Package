
const Book=require("../models/book")

const get_book=async (isbn)=>{
    const book=await Book.findOne({isbn})
    //const {name,author,categories,image,description}=book
    //we return book to check the quantity 
    return book

}

module.exports=get_book