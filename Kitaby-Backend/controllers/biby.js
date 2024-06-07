const Bib = require("../models/bib");
const Book = require("../models/book");
const Reservation = require("../models/reservation");
const User = require("../models/user");
const book_api = require("../middlewares/books_api");
const book_categories = require("../middlewares/categories_api");
const cron = require("node-cron");




const otpgenerator=require("otp-generator");
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');

const {send_otp_begin,verify_otp_end}=require('./loan')






const addBook = async (req, res) => {
  try {
    //get user
    const bib = await Bib.findOne({ _id: req.auth.bibId });
    console.log("hi1");

    if (!bib) {
      return res.status(404).json({ error: "bib not found" });
    }

    //it's too early to push
    const { isbn, quantity } = req.body;
    console.log(bib.avalaibleBooks);
    const existingBookIndex = bib.avalaibleBooks.findIndex(
      (book) => book.isbn === isbn
    );

    console.log(bib.name);
    console.log("hi2");

    let book = await Book.findOne({ isbn });
    if (!book) {
      //get metadata
      console.log(isbn);

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
          book = new Book({
          isbn,
          title,
          author,
          image,
          bibOwners: [bib._id],
          categories,
        });
        console.log("hi3");

        //create book in the database
        await book.save();
        if (existingBookIndex !== -1) {
          // If the book with the given ISBN already exists, increment its quantity
          bib.avalaibleBooks[existingBookIndex].quantity += parseInt(quantity);
        } else {
          // If the book with the given ISBN doesn't exist, create a new object and push it to the array
          bib.avalaibleBooks.push({ isbn, quantity: parseInt(quantity) });
        }
        await bib.save();
      }
      else {
        console.log("flag ultime")
        return res.status(404).json({message:"book not in google api"})
      }
    } else {
      if (existingBookIndex !== -1) {
        // If the book with the given ISBN already exists, increment its quantity
        bib.avalaibleBooks[existingBookIndex].quantity += parseInt(quantity);
      } else {
        // If the book with the given ISBN doesn't exist, create a new object and push it to the array
        bib.avalaibleBooks.push({ isbn, quantity: parseInt(quantity) });
      }
      await bib.save();
      //add the owner

      if (!book.bibOwners.includes(bib._id)) {
        // If not, push bib._id to the bibOwners array
        book.bibOwners.push(bib._id);

        // Save the updated book document
        await book.save();
      }
    }

    return res.json({ book });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const getAvalaibleBooks = async (req, res) => {
  try {
    const { page = 1, name } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);

    const booksData = bib.avalaibleBooks.map(({ isbn, quantity }) => ({
      isbn,
      quantity,
    }));

    const booksPromises = booksData.map(async ({ isbn, quantity }) => {
      const book = await Book.findOne({ isbn });
      return { ...book.toObject(), quantity };
    });

    let books = await Promise.all(booksPromises);

    if (name) {
      const nameRegex = new RegExp(`^${name}`, "i"); // Case-insensitive regex for matching name
      books = books.filter(
        (book) => nameRegex.test(book.title) || nameRegex.test(book.author)
      );
    }

    const paginatedBooks = books.slice((page - 1) * limit, page * limit);

    return res.json({
      availableBooks: paginatedBooks,
      total: books.length,
      page,
    });
  } catch (error) {
    console.log(error);
  }
};

const getExpiredBooks = async (req, res) => {
  try {
    const { page = 1, name } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: {$in: ["expired", "renew request"] },
    });

    const expReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const {
          title: bookName,
          image: bookImage,
          author,
        } = await Book.findOne(
          { isbn: r.isbn },
          { title: 1, image: 1, author: 1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          _id: r.id,
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          date: r.date,
          status: r.status,
          author,
        };
        expReservations.push(tReservation);
      })
    );

    // Apply filtering based on name or author
    let filteredReservations = expReservations;
    if (name) {
      const nameRegex = new RegExp(`^${name}`, "i"); // Case-insensitive regex for matching name or author
      filteredReservations = expReservations.filter(
        (reservation) =>
          nameRegex.test(reservation.bookName) ||
          nameRegex.test(reservation.author)
      );
    }

    const paginatedReservations = filteredReservations.slice(
      (page - 1) * limit,
      page * limit
    );

    return res.json({
      expiredBooks: paginatedReservations,
      total: filteredReservations.length,
      page,
    });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching expired books." });
  }
};

const getReservedBooks = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "reserved",
    });

    const expReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const {
          title: bookName,
          image: bookImage,
          author,
        } = await Book.findOne(
          { isbn: r.isbn },
          { title: 1, image: 1, author: 1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          _id: r._id,
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          date: r.date,
          status: r.status,
          author,
        };
        expReservations.push(tReservation);
      })
    );

    const paginatedReservations = expReservations.slice(
      (page - 1) * limit,
      page * limit
    );

    return res.json({
      reservedBooks: paginatedReservations,
      total: expReservations.length,
      page,
    });
  } catch (error) {
    console.log(error);
  }
};

const getOnHoldBooks = async (req, res) => {
  try {
    const { page = 1, name } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "on hold",
    });

    const onHoldReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const {
          title: bookName,
          image: bookImage,
          author,
        } = await Book.findOne(
          { isbn: r.isbn },
          { title: 1, image: 1, author: 1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          _id: r.id,
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          date: r.date,
          status: r.status,
          author,
        };
        onHoldReservations.push(tReservation);
      })
    );

    // Apply filtering based on name or author
    let filteredReservations = onHoldReservations;
    if (name) {
      const nameRegex = new RegExp(`^${name}`, "i"); // Case-insensitive regex for matching name or author
      filteredReservations = onHoldReservations.filter(
        (reservation) =>
          nameRegex.test(reservation.bookName) ||
          nameRegex.test(reservation.reserverName)
      );
    }

    const paginatedReservations = filteredReservations.slice(
      (page - 1) * limit,
      page * limit
    );

    return res.json({
      onHoldBooks: paginatedReservations,
      total: filteredReservations.length,
      page,
    });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching on hold books." });
  }
};

const getRequestedBooks = async (req, res) => {
  try {
    const { page = 1, name } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "requested",
    });

    const requestedBooks = [];
    await Promise.all(
      reservations.map(async (r) => {
        const {
          title: bookName,
          image: bookImage,
          author,
        } = await Book.findOne(
          { isbn: r.isbn },
          { title: 1, image: 1, author: 1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          _id: r._id,
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          date: r.date,
          status: r.status,
          author,
        };
        requestedBooks.push(tReservation);
      })
    );

    // Apply filtering based on name
    let filteredBooks = requestedBooks;
    if (name) {
      const nameRegex = new RegExp(`^${name}`, "i"); // Case-insensitive regex for matching name at the beginning
      filteredBooks = requestedBooks.filter((book) =>
        nameRegex.test(book.bookName) || nameRegex.test(book.reserverName)
      );
    }

    const paginatedReservations = filteredBooks.slice(
      (page - 1) * limit,
      page * limit
    );

    return res.json({
      requestedBooks: paginatedReservations,
      total: filteredBooks.length,
      page,
    });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching requested books." });
  }
};


const acceptRenewRequest = async (req, res) => {
  try {
    const r =await Reservation.findByIdAndUpdate(req.body.reservationId, {
      date: new Date(),
      status:'reserved'
    },{new:true});
    return res.json({r})
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const refuseRenewRequest=async(req,res)=>{
  const r=await Reservation.findByIdAndUpdate(req.body.reservationId,{status:"expired"})
  return res.json({r})

}
const getRenewRequests = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const limit = 8;
    const bib = await Bib.findById(req.auth.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "renew request",
    });

    const expReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const {
          title: bookName,
          image: bookImage,
          author,
        } = await Book.findOne(
          { isbn: r.isbn },
          { title: 1, image: 1, author: 1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          _id:r._id,
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          date: r.date,
          status: r.status,
          author,
        };
        expReservations.push(tReservation);
      })
    );

    const paginatedReservations = expReservations.slice(
      (page - 1) * limit,
      page * limit
    );

    return res.json({
      renewRequests: paginatedReservations,
      total: expReservations.length,
      page,
    });
  } catch (error) {
    console.log(error);
  }
};





const acceptBookRequest = async (req, res) => {
  try {
    const { reservationId } = req.body;
    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      { status: "on hold", date: new Date() },
      { new: true }
    );
    const bib = await Bib.findById(reservation.bib);
    const index = bib.avalaibleBooks.findIndex(
      (book) => book.isbn === reservation.isbn
    );

    if (index !== -1) {
      // If the book exists in the avlaibleBooks array
      if (bib.avalaibleBooks[index].quantity === 1) {
        // If the quantity is 1, remove the entire object from the array
        bib.avalaibleBooks.splice(index, 1);
        const book = await Book.findOne({ isbn: reservation.isbn });
        book.bibOwners = book.bibOwners.filter((b) => b.toSting() != bib._id);
        await book.save();
      } else {
        // If the quantity is greater than 1, decrement the quantity by 1
        bib.avalaibleBooks[index].quantity -= 1;
      }

      await bib.save();
    }

    const u=await User.findById(reservation.reserver)
    send_otp_begin(reservationId,u.email);
    

    return res.json({ reservation });
  } catch (error) {
    console.log(error);
  }
};
const calculateDate = (diff, date) => {
  const today = new Date();

  // Calculate the difference in milliseconds
  const differenceMs = today - date;

  // Convert milliseconds to days
  const differenceDays = Math.floor(differenceMs / (1000 * 60 * 60 * 24));

  return differenceDays >= diff;
};

const checkOnHoldBooks = async () => {
  const reservations = await Reservation.find({ status: "on hold" });

  await Promise.all(
    reservations.map(async (r) => {
      if (calculateDate(3, r.date)) {
        const bib = await Bib.findById(r.bib);
        bib.avalaibleBooks.push(r.isbn);
        bib.reservations = bib.reservations.filter((res) => res != r._id);
        await bib.save();
        const reserver = await User.findById(r.reserver);
        reserver.reservations = reserver.reservations.filter(
          (res) => res != r._id
        );
        await reserver.save();
        await Reservation.findByIdAndDelete(r._id);
      }
    })
  );
};
const checkReservedBooks = async () => {
  const reservations = await Reservation.find({ status: "reserved" });
  
  await Promise.all(
    reservations.map(async (r) => {
      console.log("haha")
      if (calculateDate(15, r.date)) {
        console.log(r._id)
        await Reservation.findByIdAndUpdate(r._id,{status:'expired'});
      }
    })
  );
};

const giveBook = async (req, res) => {
  const { reservationId,code } = req.body;
  const reservation=await Reservation.findById(reservationId);
  const u=await User.findById(reservation.reserver);
  let b;
  console.log(reservationId,code,u.email)
  try {
    b=(await verify_otp_end(reservationId,code,u.email)).bool
  } catch (error) {
    return res.json("code invalid" );
  }

  if (b==true){
    
    const r = await Reservation.findByIdAndUpdate(reservationId, {
      status: "reserved",
      date: new Date(),
    });
    return res.json({ r });
  }
  else {
    return res.json("code invalid" );
  }
};

const returnBook = async (req, res) => {
  try {
    const { reservationId,code } = req.body;
    const reservation = await Reservation.findById(reservationId);
    const u=await User.findById(reservation.reserver);
    let b;
    console.log(reservationId,code,u.email)
    try {
      b=(await verify_otp_end(reservationId,code,u.email)).bool
    } catch (error) {
      return res.json("code invalid" );
    }
    if (b==true){
    const reserver = await User.findById(reservation.reserver);
    const book = await Book.findOne({ isbn: reservation.isbn });
    const bib = await Bib.findById(reservation.bib);
    reserver.reservations = reserver.reservations.filter(
      (r) => !r.equals(reservation._id)
    );
    await reserver.save();

    if (!book.bibOwners.includes(bib._id)) {
      // If not, push bib._id to the bibOwners array
      book.bibOwners.push(bib._id);

      // Save the updated book document
      await book.save();
    }

    const existingBookIndex = bib.avalaibleBooks.findIndex(
      (book) => book.isbn === reservation.isbn
    );

    if (existingBookIndex !== -1) {
      // If the book with the given ISBN already exists, increment its quantity
      bib.avalaibleBooks[existingBookIndex].quantity += parseInt(1);
    } else {
      const isbn = reservation.isbn;
      // If the book with the given ISBN doesn't exist, create a new object and push it to the array
      bib.avalaibleBooks.push({ isbn, quantity: 1 });
    }
    await bib.save();

    await Reservation.findByIdAndDelete(reservation._id);

    return res.json({ reservation });
  } else{
    return res.json("code invalid")
  }

    }catch(error){
      console.log(error)
      return res.status(500).json({ error: "Internal Server Error" });
    }

};

const refuseBookRequest=async(req,res)=>{
  try {
    const r=await Reservation.findByIdAndDelete(req.body.reservationId);
  return res.json({r})
  } catch (error) {
    console.log(error)
  }
}
//*/5 * * * * *
cron.schedule('0 0 * * *', () => {
  console.log("Running checkOnHoldBooks job");
  checkOnHoldBooks();
  checkReservedBooks();

});


const reportUser=async (req,res)=>{
  const userId=req.body.userId;
  return res.json({userId})
}


const OtpStuff=require('../models/otpstuff');
const jwt = require('jsonwebtoken');
const client = require("twilio")(process.env.Twilio_accountSid,process.env.Twilio_authToken);
const { networkInterfaces } = require('os');



const wlanIPv4 = Object.keys(networkInterfaces()).reduce((ipv4, interfaceName) => {
    if (interfaceName.startsWith('wlan')) {
        const interfaceInfo = networkInterfaces()[interfaceName].find(
            info => !info.internal && info.family === 'IPv4'
        );
        if (interfaceInfo) {
            return interfaceInfo.address;
        }
    }
    return ipv4; 
}, null);

module.exports = {
  reportUser,
  refuseRenewRequest,
  refuseBookRequest,
  getAvalaibleBooks,
  getReservedBooks,
  getOnHoldBooks,
  acceptBookRequest,
  getRequestedBooks,
  giveBook,
  addBook,
  checkOnHoldBooks,
  getExpiredBooks,
  returnBook,
  
  getRenewRequests,
  acceptRenewRequest,
  
};