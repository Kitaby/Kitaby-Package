const User = require('../models/user');
const fs = require('fs');
const  { Thread, Comment , Reply , Categorie ,Report} = require('../models/forum');
const Book = require("../models/book");
const Offer = require("../models/offers");
const Bib = require("../models/bib");
const Reservation = require("../models/reservation");
const book_categories = require("../middlewares/categories_api");
const book_api = require("../middlewares/books_api");
const formatDateToYYYYMMDD = require("../utils/formatDate");

exports.change_pp =(req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        if (req.file){
            user.photo='images/'+req.file.filename
            user.save().then(()=>res.status(200).json({message:"success"}))
            .catch(error => res.status(500).json({ error }));
        }else {res.status(404).json({message:"no file sent"})}
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_profile =(req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        const info={
            email:user.email,
            name:user.name,
            phone:user.phone,
            categories: user.categories,
            photo:user.photo,
            exchanges:user.offers_received.length+user.offers_sent.length,
            books:user.ownedbooks.length,
            wilaya:user.wilaya
        }
        res.status(200).json({ message: 'success',info:info});
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_post =(req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        res.status(200).json({ message: 'success' ,pp:user.photo,name:user.name});
    })
    .catch(error => res.status(500).json({ error }));
};

exports.change_profile =(req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        if(req.body.wilaya){user.wilaya=req.body.wilaya}
        if(req.body.categories){
            const already = new Set([...user.categories].filter(x => req.body.categories.includes(x)));
            const newfollow = req.body.categories.filter(x=> !already.has(x))
            const newunfollow = user.categories.filter(x=> !already.has(x))
            newfollow.forEach(async element => {
                Categorie.findOne({title:element})
                .then(async ca=>{
                    if(ca){
                        ca.follows++
                        ca.followers.push(user._id)
                        await ca.save()
                    }
                })
                .catch(error => res.status(500).json({ error }));
            });
            newunfollow.forEach(async element=>{
                Categorie.findOne({title:element})
                .then(async ca=>{
                    if(ca){
                        ca.follows--
                        const index=ca.followers.indexOf(user._id)
                        if((!(index ===-1))&&(index !==( ca.followers.length -1))) {
                            [ca.followers[index], ca.followers[ca.followers.length - 1]] = [ca.followers[ca.followers.length - 1], ca.followers[index]];
                        }
                        await ca.save()
                    }
                })
                .catch(error => res.status(500).json({ error }));
            })
        }
        user.save().then(()=>res.status(200).json({message:"success"}))
        .catch(error => res.status(500).json({ error }));
    })
    .catch(error => res.status(500).json({ error }));
};


exports.delete_pp = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        fs.unlink('../images/'+req.auth.userId+'.jpg',(error)=>{
            if (error){
                res.status(500).json({ error })
            }
            else {
                user.photo='images/default.jpg'
                user.save()
                .then(()=> res.status(200).json({message:'success'}))
            }
        })
    })
    .catch(error => res.status(500).json({ error }));
};


exports.getResrvations = async (req, res) => {
    try {
      const {page=1,limit=8}=req.query
      console.log('hi')
      const userId = req.auth.userId;
      const reservations = await Reservation.find({ reserver: userId });
      console.log(userId);
      let rs = [];
      await Promise.all(
        reservations.map(async (r) => {
          console.log(r);
          const {
            title: bookName,
            image: bookImage,
            author,
          } = await Book.findOne(
            { isbn: r.isbn },
            { title: 1, image: 1, author: 1 }
          );
          const { name: bibName } = await Bib.findById(r.bib, {
            name: 1,
          });
          const tReservation = {
            _id:r._id,
            bibName,
            isbn: r.isbn,
            bookName,
            bookImage,
            date: r.date,
            status: r.status,
            author,
          };
  
          rs.push(tReservation);
        })
      );
      rs = rs.slice((page - 1) * limit, page * limit);
      return res.json({ rs });
    } catch (error) {
  
      console.log(error);
      res.status(500).json({ message: "An error occurred while getting reservations." });
    }
  };


exports.postBookInCollection = async (req, res) => {
  try {
    //get user
    const user = await User.findOne({ _id: req.auth.userId });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    //it's too early to push
    const { isbn } = req.body;
    

    const book = await Book.findOne({ isbn });
    if (!book) {
      //get metadata

      const responseData = await book_api(isbn);
      if (responseData.items){
        const { title, authors, imageLinks, description } = responseData.items[0].volumeInfo;
        let image='https://nnp.wustl.edu/img/bookCovers/genericBookCover.jpg'
        if (imageLinks) {image = imageLinks.thumbnail}
        let author='katib'
        if(authors){
            author=authors.join(",")
        }
        const categories = await book_categories(isbn);
        const book = {
          description,
          isbn,
          title,
          author,
          image,
          owners: [user._id],
          categories,
        };
        user.ownedbooks.push(isbn);
        await user.save()
  
        //create book in the database
        await Book.create(book);
      }
    } else {
      //add the owner
    if (!book.owners.includes(user._id) && !user.wishlist.includes(isbn)){
      user.ownedbooks.push(isbn);
      await user.save();
      book.owners.push(user._id);
      await book.save();
    }

    }

    return res.json(book);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
  

exports.postBookInWishlist = async (req, res) => {
  try {
    //get user
    const user = await User.findOne({ _id: req.auth.userId });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    //it's too early to push
    const { isbn } = req.body;
    

    const book = await Book.findOne({ isbn });
    if (!book) {
      //get metadata

      const responseData = await book_api(isbn);
      const { title, authors, imageLinks } = responseData.items[0].volumeInfo;
      const image = imageLinks.thumbnail;
      const author = authors[0];
      const categories = await book_categories(isbn);
      const book = {
        isbn,
        title,
        author,
        image,
        owners: [user._id],
        categories,
      };

      //create book in the database
      await Book.create(book);
    } else {
      //add the owner
    if (!user.wishlist.includes(isbn)){
      user.wishlist.push(isbn);
      await user.save();
      
    }

    }

    return res.json(book);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
  
  
  exports.cancelReservation = async (req, res) => {
    const { reservationId } = req.body;
    const r = await Reservation.findById(reservationId);
    const reserverId = r.reserver;
    const reserver = await User.findById(reserverId);
    reserver.reservations = reserver.reservations.filter(
      (id) => id.toString() != reservationId
    );
    reserver.save();
    r.save();
  
    const bibId = r.bib;
    const bib = await Bib.findById(bibId);
    bib.reservations = bib.reservations.filter((id) => id.toString() != reservationId);
  
    if (r.status=='on hold'){
      const existingBookIndex = bib.avalaibleBooks.findIndex(
        (isbn) => isbn === r.isbn
      );
      if (existingBookIndex === -1) {
        // If the book wasn't available before, add it back to the available books
        bib.avalaibleBooks.push({ isbn: r.isbn, quantity: 1 });
        const book = await Book.findOne({ isbn: r.isbn });
        book.bibOwners.push(bibId)
        await book.save();
      } else {
        // If the book was available, increment the quantity by 1
        bib.avalaibleBooks[existingBookIndex].quantity += 1;
      }
    }
  
    bib.save();
    await Reservation.findByIdAndDelete(reservationId)
    return res.json({message:'deleted'})
  };
  
  exports.renewRequest = async (req, res) => {
    const { reservationId } = req.body;
    const r = await Reservation.findByIdAndUpdate(
      reservationId,
      { status: "renew request" },
      { new: true }
    );
  
    return res.json({ r });
  };
  
  
  exports.endBookReservation=async (req,res)=>{
    const r=await Reservation.findByIdAndUpdate(req.body.reservationId,{status:"expired",date:new Date()});
    return res.json({ message:"deleted" })
  }
  
  exports.requestBook = async (req, res) => {
    try {
      const userId=req.auth.userId
      const { bibId, bookIsbn } = req.body;
      const reservation = new Reservation({
        reserver: userId,
        bib: bibId,
        isbn: bookIsbn,
        status: "requested",
      });
  
      await reservation.save();
      const user = await User.findById(userId);
      user.reservations.push(reservation._id);
      const bib = await Bib.findById(bibId);
      bib.reservations.push(reservation._id);
      await user.save();
      await bib.save();
      return res.json({ message:"deleted" });
    } catch (error) {
      console.log(error);
    }
  };