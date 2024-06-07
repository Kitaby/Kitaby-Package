const User = require("../models/user");
const Book = require("../models/book");
const Offer=require("../models/offers");
const Reservation=require("../models/reservation")
const book_categories = require("../middlewares/categories_api");
const book_api = require("../middlewares/books_api");
const reservation = require("../models/reservation");

const postBookInCollection = async (req, res) => {
  try {
    //get user
    const user = await User.findOne({ _id: req.body._id });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    //it's too early to push 
    const { isbn } = req.body;
    user.ownedbooks.push(isbn);
    user.save();

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
      book.owners.push(user._id);
      book.save();
    }

    return res.json(book);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const postBookInWishlist = async (req, res) => {
  try {
    //get user
    const user = await User.findOne({ _id: req.body._id });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const { isbn } = req.body;
    user.wishlist.push(isbn);
    user.save();

    return res.json("book added");
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const deleteBookFromWishlist = async (req, res) => {
  const user = await User.findById(req.auth.userId);
  const { bookIsbn } = req.body;
  user.wishlist = user.wishlist.filter((isbn) => isbn !== bookIsbn);

  return res.json({ user });
};
const deleteBookFromCollection = async (req, res) => {
  const user = await User.findById(req.auth.userId);
  const { bookIsbn } = req.body;
  user.ownedbooks = user.ownedbooks.filter((isbn) => isbn !== bookIsbn);

  const offers_received = user.offers_received;

  const deleteFromReceivedOffers = [];
  await Promise.all(
    offers_received.map(async (offerId) => {
      //we get the received offers of the owner then we delete the offers asking for that book

      const receivedOffer = await Offer.findById({ offerId });
      if (receivedOffer.demandedBook === bookIsbn) {
        //we can send notification here
        deleteFromReceivedOffers.push(offerId);
        await Offer.findByIdAndDelete(receivedOffer._id);

        //here we delete the offer for the buyer (sender)
        const bookBuyer = await User.findById(receivedOffer.bookBuyer);
        bookBuyer.offers_sent = bookBuyer.offers_sent.filter(
          (offer) => offer !== offerId
        );
      }
    })
  );
  //here we delete the offers for the owner
  user.offers_received = user.offers_received.filter(
    (offer) => !deleteFromReceivedOffers.includes(offer.id)
  );

  //here we have to delete the book from the offers that the owner has sent
  const offers_sent = user.offers_sent;
  await Promise.all(
    offers_sent.map(async (offerId) => {
      const sentOffer = await Offer.findById(offerId);
      sentOffer.proposedBooks.map(async (proposedBook) => {
        if (proposedBook === bookIsbn) {
          if (sentOffer.proposedBooks.length === 1) {
            user.offers_sent = user.offers_sent.filter(
              (offerId) => offerId !== sentOffer._id
            );
            const bookOwner = await User.findById(sentOffer.bookOwner);
            bookOwner.offers_received = bookOwner.offers_received.filter(
              (offerId) => offerId !== sentOffer._id
            );
            await Offer.findByIdAndDelete(sentOffer._id);
          } else {
            sentOffer.proposedBooks = sentOffer.proposedBooks.filter(
              (book) => book !== acceptedBookIsbn
            );
          }
        }
      });
    })
  );

  return res.json({ user });
};




const getResrvations=async(req,res)=>{
  const {userId}=req.body
  const reservations=await Reservation.find({reserver:userId})
  const rs=[]
  await Promise.all(

  )
}
//can sum up those two in one



const fs = require('fs');

const change_pp = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        if (!req.file){
            return res.status(400).json({message:"no file in request"})
        }
        user.photo=req.protocol+'://'+req.get('host')+'/images/'+req.file.filename
        user.save()
        res.status(200).json({message:"success"})
    })
    .catch(error => res.status(500).json({ error }));
};

// exports.change_wilaya = (req, res, next) => {
//     User.findOne({ _id:req.auth.userId})
//     .then(user => {
//         if (!user) {
//             return res.status(400).json({ message: 'user not found' });
//         }
//         user.wilaya= ???
//         return res.status(200).json({message:"success"})
//     })
//     .catch(error => res.status(500).json({ error }));
// };

// exports.change_categories = (req, res, next) => {
//     User.findOne({ _id:req.auth.userId})
//     .then(user => {
//         if (!user) {
//             return res.status(400).json({ message: 'user not found' });
//         }
//         user.wilaya= ???
//         return res.status(200).json({message:"success"})
//     })
//     .catch(error => res.status(500).json({ error }));
// };

const delete_pp = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user) {
            return res.status(400).json({ message: 'user not found' });
        }
        fs.unlink('../images/'+req.auth.userId,(error)=>{
            if (error){
                res.status(500).json({ error })
            }
            else {
                user.photo=req.protocol+'://'+req.get('host')+'/images/default.jpg'
                user.save()
                .then(()=> res.status(200).json({message:'success'}))
            }
        })
    })
    .catch(error => res.status(500).json({ error }));
};

module.exports = {
  postBookInCollection,
  postBookInWishlist,
  change_pp,
  delete_pp,
};