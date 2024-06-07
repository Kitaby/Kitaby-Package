const Offer = require("../models/offers");
const Book = require("../models/book");
const User = require("../models/user");
const chatModel = require("../models/chat");

const getReceivedOffers = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10; // Default limit to 10 if not specified
  const startIndex = (page - 1) * limit;
  const endIndex = page * limit;

  try {
    const user = await User.findOne({ _id: req.auth.userId });
    console.log(req.auth.userId)
    const offers_received = user.offers_received;
    console.log(offers_received)

    if (!offers_received){
      return     res.json({ offers:[] });
    }
    const totalOffers = offers_received.length;

    const offers = await Promise.all(
      offers_received.slice(startIndex, endIndex).map(async (offer_id) => {
        const offer = await Offer.findById(offer_id);
        const demandedBook = await Book.findOne({ isbn: offer.demandedBook });
        const proposedBooks = await Book.find({ isbn: { $in: offer.proposedBooks } });
        const bookBuyer = await User.findById(offer.bookBuyer);
       
        const buyer = bookBuyer.name;
        const wilaya = bookBuyer.wilaya;

        return { offer, demandedBook, proposedBooks, buyer, wilaya };
      })
    );

    const pagination = {};

    if (endIndex < totalOffers) {
      pagination.next = {
        page: page + 1,
        limit: limit
      };
    }

    if (startIndex > 0) {
      pagination.prev = {
        page: page - 1,
        limit: limit
      };
    }

    res.json({ offers });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server Error" });
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
    const user = await User.findById(req.auth.userId);
    

    const acceptedOffer = await Offer.findByIdAndUpdate(
      offerId,
      { status: "accepted" },
      { new: true }
    );
    user.ownedbooks=user.ownedbooks.filter((isbn)=>isbn!=acceptedOffer.demandedBook)
    await user.save()

    user.offers_received = user.offers_received.filter((offer) => offer.toString() != offerId);
    await user.save()

    let offers_received= user.offers_received;


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
          await bookBuyer.save();
        }
      })
    );
    //here we delete the offers for the owner
    user.offers_received = user.offers_received.filter(
      (offer) => !deleteFromReceivedOffers.includes(offer)
    );
    await user.save();

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
              await user.save();
              const bookOwner = await User.findById(sentOffer.bookOwner);
              bookOwner.offers_received = bookOwner.offers_received.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              await bookOwner.save();
              await Offer.findByIdAndDelete(sentOffer._id);
            } else {
              console.log(sentOffer.proposedBooks);
              sentOffer.proposedBooks = sentOffer.proposedBooks.filter(
                (book) => book != acceptedOffer.demandedBook
              );
              await sentOffer.save();
            }
          }
        });
      })
    );

    // for the acceptedBook we need to delete to
    //delete the received offers of buyers that demanded the accepted book 
    const bookBuyer = await User.findById(acceptedOffer.bookBuyer);
    bookBuyer.ownedbooks=bookBuyer.ownedbooks.filter((isbn)=>isbn!=acceptedBookIsbn)
    await bookBuyer.save()
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
          await secondBuyer.save();
        }
      })
    );
    bookBuyer.offers_received = bookBuyer.offers_received.filter(
      (offer) => !deleteForBuyer.includes(offer)
    );
    await bookBuyer.save();

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
              await bookBuyer.save();
              const bookOwner = await User.findById(sentOffer.bookOwner);
              bookOwner.offers_received = bookOwner.offers_received.filter(
                (offerId) => !offerId.equals(sentOffer._id)
              );
              await bookOwner.save();
              await Offer.findByIdAndDelete(sentOffer._id);
            } else {
              console.log(sentOffer.proposedBooks);
              sentOffer.proposedBooks = sentOffer.proposedBooks.filter(
                (book) => book != acceptedBookIsbn
              );
              await sentOffer.save();
            }
          }
        });
      })

    )
    const book1=await Book.findOne({isbn:acceptedOffer.demandedBook})
    book1.owners=book1.owners.filter((id)=>id.toString()!=req.body.userId)
    await book1.save()
    const book2=await Book.findOne({isbn:acceptedBookIsbn})
    book2.owners=book2.owners.filter((id)=>id.toString()!=acceptedOffer.bookBuyer)
    await book2.save()


    

    const chat = await chatModel.findOne({
      members: { $all: [req.auth.userId, acceptedOffer.bookBuyer] },})
    
    if (!chat){
  
    const newChat = new chatModel({
        members: [req.auth.userId, acceptedOffer.bookBuyer.toString()],
      });
      await newChat.save();
    }

    return res.status(200).json({ message: "offer accepeted", acceptedOffer });

  } catch (error) {
    console.log(error);
    res.status(500).json({ error });
  }
};

const rejectOffer = async (req, res) => {
  try {
  const user = await User.findById(req.auth.userId);
  const { offerId } = req.body;
  const offer = await Offer.findById(offerId);
  const { bookBuyer: bookBuyerId } = offer;
  const bookBuyer = await User.findById(bookBuyerId);
  user.offers_received = user.offers_received.filter((offer) => offer.toString() !== offerId);
  bookBuyer.offers_sent = bookBuyer.offers_sent.filter(
    (offer) => offer.toString() !== offerId
  );

  await user.save();
  await bookBuyer.save();
  await Offer.findByIdAndDelete(offerId)


  return res.json(offer);
  } catch (error) {}
};

const cancelOffer = async (req, res) => {
  const user = await User.findById(req.auth.userId);
  const { offerId } = req.body;
  const offer = await Offer.findById(offerId);
  const { bookOwner: bookOwnerId } = offer;
  const bookOwner = await User.findById(bookOwnerId);
  user.offers_sent = user.offers_sent.filter((offer) => offer.toString() !== offerId);
  bookOwner.offers_received = bookOwner.offers_received.filter(
    (offer) => offer.toString() !== offerId
  );

  await user.save();
  await bookOwner.save();
  await Offer.findByIdAndDelete(offerId)


  return res.json(offer);
};

const postOffer = async (req, res) => {
  const buyer = await User.findOne({ _id: req.auth.userId });
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
    await Owner.save();

    buyer.offers_sent.push(createdOffer._id);
    await buyer.save();

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
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10; // Default limit to 10 if not specified
  const startIndex = (page - 1) * limit;
  const endIndex = page * limit;

  try {
    const user = await User.findOne({ _id: req.auth.userId });
    const offers_sent = user.offers_sent;

    const totalOffers = offers_sent.length;

    const offers = await Promise.all(
      offers_sent.slice(startIndex, endIndex).map(async (offer_id) => {
        const offer = await Offer.findById(offer_id);
        console.log("offer_id :",offer_id,"demanded book : " ,offer.demandedBook)
        const demandedBook = await Book.findOne({ isbn: offer.demandedBook });
        const proposedBooks = await Book.find({ isbn: { $in: offer.proposedBooks } });
        const owner = await User.findById(offer.bookOwner, { name: 1 });
        const bookBuyer = await User.findById(offer.bookBuyer);
        const buyer = bookBuyer.name;
        const wilaya = bookBuyer.wilaya;
        return { offer, proposedBooks,demandedBook, owner,buyer,wilaya };
      })
    );

    

    res.json({ offers });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server Error" });
  }
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
