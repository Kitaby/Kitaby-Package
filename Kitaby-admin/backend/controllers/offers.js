const Offer = require("../models/offers");
const Book = require("../models/book");
const User = require("../models/user");

const getReceivedOffers = async (req, res) => {
  //offers li rahoum waslinlah
 try {
  const user = await User.findOne({ _id: req.params.id });
  const offers_received = user.offers_received;
  const booksIsbn=[]

  const offers = await Promise.all(
    offers_received.map(async (offer_id) => {

      const offer = await Offer.findById(offer_id);
      const demandedBook=await Book.findOne( {isbn:offer.demandedBook})
      const proposedBooks=await Book.findOne( {isbn:offer.proposedBooks})
      const bookBuyer=await User.findById(offer.bookBuyer)
      const buyer=bookBuyer.name
      const wilaya=bookBuyer.wilaya
      
      return {offer,demandedBook,proposedBooks,buyer,wilaya};
    })
  );
  res.json({offers});
 } catch (error) {
  console.log(error)
  
 }
};

const getOffer = async (req, res) => {
  const offer = Offer.findById(req.params.offer_id);
  return offer;
};

const acceptOffer = async (req, res) => {
  try {
    //delete the exchanged book from the other offers

    //we delete from those who were asking for the book so when the user and the isbn matches the others offer

    const { acceptedBookIsbn, offerId } = req.body;
    const user = await User.findById(req.body.userId);
    

    const acceptedOffer = await Offer.findByIdAndUpdate(
      offerId,
      { status: "accepted" },
      { new: true }
    );
    user.ownedbooks=user.ownedbooks.filter((isbn)=>isbn!=acceptedOffer.demandedBook)
    user.save()

    let offers_received = user.offers_received;
    offers_received = offers_received.filter((offer) => offer != offerId);

    const deleteFromReceivedOffers = [];
    // in this promise we delete the received offers that contains the demanded book ,we delete them for the owner and for the buyer
    await Promise.all(
      offers_received.map(async (offerId) => {
        //we get the received offers of the owner then we delete the offers asking for that book

        const receivedOffer = await Offer.findById(offerId);

        if (receivedOffer.demandedBook == acceptedOffer.demandedBook) {
          //we can send notification here
          deleteFromReceivedOffers.push(offerId);
          await Offer.findByIdAndDelete(receivedOffer._id);

          //here we delete the offer for the buyer (sender)
          const bookBuyer = await User.findById(receivedOffer.bookBuyer);
          bookBuyer.offers_sent = bookBuyer.offers_sent.filter((offer) => {
            return !offer.equals(offerId);
          });
          bookBuyer.save();
        }
      })
    );
    //here we delete the offers for the owner
    user.offers_received = user.offers_received.filter(
      (offer) => !deleteFromReceivedOffers.includes(offer)
    );
    user.save();

    //here we have to delete the book from the offers that the owner has sent
    const offers_sent = user.offers_sent;
    await Promise.all(
      offers_sent.map(async (offerId) => {
        const sentOffer = await Offer.findById(offerId);
        sentOffer.proposedBooks.map(async (proposedBook) => {
          console.log(proposedBook);
          if (proposedBook === acceptedOffer.demandedBook) {
            if (sentOffer.proposedBooks.length === 1) {
              user.offers_sent = user.offers_sent.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              user.save();
              const bookOwner = await User.findById(sentOffer.bookOwner);
              bookOwner.offers_received = bookOwner.offers_received.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              bookOwner.save();
              await Offer.findByIdAndDelete(sentOffer._id);
            } else {
              console.log(sentOffer.proposedBooks);
              sentOffer.proposedBooks = sentOffer.proposedBooks.filter(
                (book) => book != acceptedOffer.demandedBook
              );
              sentOffer.save();
            }
          }
        });
      })
    );

    // for the acceptedBook we need to delete to
    //delete the received offers of buyers that demanded the accepted book 
    const bookBuyer = await User.findById(acceptedOffer.bookBuyer);
    bookBuyer.ownedbooks=bookBuyer.ownedbooks.filter((isbn)=>isbn!=acceptedBookIsbn)
    bookBuyer.save()
    const receivedOffers = bookBuyer.offers_received;
    const deleteForBuyer=[]
    await Promise.all(
      receivedOffers.map(async (offerId) => {
        const offer = await Offer.findById(offerId);
        if (offer.demandedBook == acceptedBookIsbn) {
          deleteForBuyer.push(offerId);
          await Offer.findByIdAndDelete(offerId);

          //here we delete the offer for the buyer (sender)
          const secondBuyer = await User.findById(offer.bookBuyer);
          secondBuyer.offers_sent = secondBuyer.offers_sent.filter((offer) => {
            return !offer.equals(offerId);
          });
          secondBuyer.save();
        }
      })
    );
    bookBuyer.offers_received = bookBuyer.offers_received.filter(
      (offer) => !deleteForBuyer.includes(offer)
    );
    bookBuyer.save();

    //delete the offers that the buyer sent with the accepted book

    const sentOffers=bookBuyer.offers_sent
    Promise.all(
      sentOffers.map(async (offerId) => {
        const sentOffer = await Offer.findById(offerId);
        sentOffer.proposedBooks.map(async (proposedBook) => {
          if (proposedBook === acceptedBookIsbn) {
            if (sentOffer.proposedBooks.length === 1) {
              bookBuyer.offers_sent = bookBuyer.offers_sent.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              bookBuyer.save();
              const bookOwner = await User.findById(sentOffer.bookOwner);
              bookOwner.offers_received = bookOwner.offers_received.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              bookOwner.save();
              await Offer.findByIdAndDelete(sentOffer._id);
            } else {
              console.log(sentOffer.proposedBooks);
              sentOffer.proposedBooks = sentOffer.proposedBooks.filter(
                (book) => book != acceptedBookIsbn
              );
              sentOffer.save();
            }
          }
        });
      })

    )
    const book1=await Book.findOne({isbn:acceptedOffer.demandedBook})
    book1.owners=book1.owners.filter((id)=>id!=req.body.userId)
    book1.save()
    const book2=await Book.findOne({isbn:acceptedBookIsbn})
    book2.owners=book2.owners.filter((id)=>id!=acceptedOffer.bookBuyer)
    book2.save()

    
    return res.status(200).json({ message: "offer accepeted", acceptedOffer });

  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

const rejectOffer = async (req, res) => {
  try {
    await Offer.findByIdAndDelete(req.body.offer_id);
  } catch (error) {}
};

const cancelOffer = async (req, res) => {
  const user = await User.findById(req.auth.userId);
  const { offerId } = req.body;
  const offer = await Offer.findById(offerId);
  const { bookOwner: bookOwnerId } = offer;
  const bookOwner = await User.findById(bookOwnerId);
  user.offers_sent = user.offers_sent.filter((offer) => offer !== offerId);
  bookOwner.offers_received = user.offers_sent.filter(
    (offer) => offer !== offerId
  );

  return res.json(offer);
};

const postOffer = async (req, res) => {
  const buyer = await User.findOne({ _id: req.body.id });
  if (!buyer) {
    return res.status(404).json({ error: "User not found" });
  }

  const bookBuyer = buyer._id;
  const { proposedBooks, demandedBook, bookOwner } = req.body;

  const offer = {
    bookOwner,
    proposedBooks,
    demandedBook,
    bookBuyer,
    status: "on hold",
  };

  try {
    const createdOffer = await Offer.create(offer);
    const Owner = await User.findById(bookOwner);

    Owner.offers_received.push(createdOffer._id);
    Owner.save();

    buyer.offers_sent.push(createdOffer._id);
    buyer.save();

    // Respond with success message or data if needed
    res
      .status(201)
      .json({ message: "Offer created successfully", offer: createdOffer });
  } catch (error) {
    console.error("Error creating offer:", error);
    // Respond with an error message
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const getSentOffers = async (req, res) => {
  const user = await User.findOne({ _id: req.params.id });
  const offers_sent = user.offers_sent;

  const offers = await Promise.all(
    offers_sent.map(async (offer_id) => {

      const offer = await Offer.findById(offer_id);
      const demandedBook=await Book.findOne({isbn:offer.demandedBook})
      return {offer,demandedBook};
    })
  );
  res.json({offers});
};

module.exports = {
  getOffer,
  getReceivedOffers,
  getSentOffers,
  acceptOffer,
  postOffer,
  cancelOffer,
  rejectOffer,
  
};
