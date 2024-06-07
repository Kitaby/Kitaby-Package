//to revise the get requests function concerning the return value

const Bib = require("../models/biblio");
const Book = require("../models/book.js");
const Reservation = require("../models/reservation");
const User = require("../models/user");
const book_api = require("../middlewares/books_api");
const book_categories = require("../middlewares/categories_api");

 

const addBook = async (req, res) => {
  try {
    //get user
    const bib = await Bib.findOne({ _id: req.body.bibId });

    if (!bib) {
      return res.status(404).json({ error: "bib not found" });
    }

    //it's too early to push
    const isbn = req.body.isbn;
    const quantity = req.body.quantity;
    const existingBookIndex = bib.avalaibleBooks.findIndex(
      (book) => book.isbn === isbn
    );

    if (existingBookIndex !== -1) {
      // If the book with the given ISBN already exists, increment its quantity
      bib.avalaibleBooks[existingBookIndex].quantity += parseInt(quantity);
    } else {
      // If the book with the given ISBN doesn't exist, create a new object and push it to the array
      bib.avalaibleBooks.push({ isbn, quantity: parseInt(quantity) });
    }
    await bib.save();
    /* console.log(bib.name);
    console.log("hi2"); */

    let book = await Book.findOne({ isbn });
    console.log(book);
    if (!book) {
      //get metadata
      const responseData = await book_api(isbn);
      const { title, authors, imageLinks } = responseData.items[0].volumeInfo;
      const image = imageLinks.thumbnail;
      const author = authors[0];
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
    } else {
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

const getExpiredBooks = async (req, res) => {
  try {
    const bib = await Bib.findById(req.params.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "expired",
    });
    const expReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const { name: bookName, image: bookImage,author } = await Book.findOne(
          { isbn: r.isbn },
          { name: 1, image: 1,author:1 }
        );
        const { name: reserverName } = await User.findById(r.reserver, {
          name: 1,
        });
        const tReservation = {
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          data: r.date,
          status: r.status,
          author
        };
        expReservations.push(tReservation);
      })
    );

    return res.json({ expReservations });
  } catch (error) {
    console.log(error);
  }
};

const getReservedBooks = async (req, res) => {
  try {
    const bib = await Bib.findById(req.params.bibId);
    if (!bib) {
      return res.status(404).json({ error: 'No Bib found with provided id' });
    }
    console.log(bib)
    const reservations = await Reservation.find({ bib: bib._id, status: "reserved" });
    if (!reservations.length) {
      return res.status(404).json({ error: 'No reservations found for the provided Bib id' });
    }

    const expReservations = await Promise.all(
      reservations.map(async (r) => {
        const book = await Book.findOne({ isbn: r.isbn });
        if (!book) {
          return res.status(404).json({ error: `No Book found with isbn: ${r.isbn}` });
        }
        return { name: book.title, image: book.image, author: book.author };
      })
    );

    res.json(expReservations);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching reserved books' });
  }
};
const getOnHoldBooks = async (req, res) => {
  try {
    const bib = await Bib.findById(req.params.bibId);
    const reservations = await Reservation.find({
      bib: bib._id,
      status: "on hold",
    });
    res.json({ reservations });
    const expReservations = [];
    await Promise.all(
      reservations.map(async (r) => {
        const { name: bookName, image: bookImage,author } = await Book.findOne(
          { isbn: r.isbn },
          { name: 1, image: 1 ,author:1}
        );
        const { name: reserverName } = await User.find({ _id:r.reserver }, {
          name: 1,
        });
        const tReservation = {
          reserver: r.reserver,
          reserverName,
          isbn: r.isbn,
          bookName,
          bookImage,
          data: r.date,
          status: r.status,
          author
        };
        expReservations.push(tReservation);
      })
    );

    return res.json({ expReservations });
  } catch (error) {
    console.log(error);
  }
};
const getRequestedBooks = async (req, res) => {
  try {
    const bib = await Bib.findById(req.params.bibId);
    if (!bib) {
      return res.status(404).json({ error: 'No Bib found with provided id' });
    }

    const reservations = await Reservation.find({ bib: bib._id, status: "requested" });
    if (!reservations.length) {
      return res.status(404).json({ error: 'No reservations found for the provided Bib id' });
    }

    /* const expReservations = await Promise.all(reservations.map(async (r) => {
      const book = await Book.findOne({ isbn:r.isbn });
      return book;
    })); */


    //res.json(expReservations);
    res.json(reservations);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching requested books' });
  }
};
const requestBook = async (req, res) => {
  try {
    const userId = req.body._id;
    const bibId = req.body.bibId;
    const bookIsbn = req.body.isbn;
    const reservation = new Reservation({
      reserver: userId,
      bib: bibId,
      isbn: bookIsbn,
      status: "requested",
    });

    await reservation.save();
    const user = await User.findById(userId); // Fetch the user by ID
    user.reservations.push(reservation._id);
    await user.save(); // Save the updated user

    const bib = await Bib.findById(bibId); // Fetch the bib by ID
    bib.reservations.push(reservation._id);
    await bib.save(); // Save the updated bib

    return res.json({ reservation });
  } catch (error) {
    console.log(error);
  }
};

const getUsers = async (req, res) => { 
  try {
    const users = await User.find({});
    return res.json({ users });
  } catch (error) {
    console.log(error);
  }

}

const acceptBookRequest = async (req, res) => {
  try {
    const reservationId  = req.body.reservationId;
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
        const book=await Book.findOne({isbn:reservation.isbn})
        book.bibOwners=book.bibOwners.filter((b)=>b!=bib._id)
        await book.save()
      } else {
        // If the quantity is greater than 1, decrement the quantity by 1
        bib.avalaibleBooks[index].quantity -= 1;
      }

      await bib.save();
    }
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

  return differenceDays > diff;
};

const checkOnHoldBooks = async (req, res) => {
  const reservations = await Reservation.find({ status: "on hold" });
  console.log(reservations);
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
  res.send(reservations);
};
const giveBook = async (req, res) => {
  try {
    const reservationId = req.body.reservationId;
    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      { status: "reserved", date: new Date() },
      { new: true }
    );
    return res.json({ reservation });
  } catch (error) {
    console.log(error);
  }
};


const returnBook=async (req,res)=>{
  const {reservationId}=req.body
  const reservation=await Reservation.findById(reservationId)
  const reserver=await User.findById(reservation.reserver)

}
const getAvailableBooks = async (req, res) => {
  try {
    const bib = await Bib.findById(req.params.bibId);

    const booksData = bib.avalaibleBooks.map(({ isbn, quantity }) => ({ isbn, quantity }));

    // Fetch the books based on the extracted ISBNs
    const books = await Promise.all(booksData.map(async ({ isbn, quantity }) => {
      const book = await Book.findOne({ isbn });
      if (book) {
        return { ...book.toObject(), quantity }; // Merge book data with quantity
      } else {
        console.log(`Book with ISBN ${isbn} not found`);
        return null;
      }
    }));


    //filters:
    const { wilaya, categories, title, author, name } = req.query;
  const queryObj = {};

  if (title) {
    queryObj.title = { $regex: title, $options: "i" };
  }
  if (author) {
    queryObj.author = { $regex: author, $options: "i" };
  }
  if (name) {
    queryObj.$or = [
      { title: { $regex: name, $options: "i" } },
      { author: { $regex: name, $options: "i" } },
    ];
  }
  if (wilaya) {
    queryObj.wilaya = wilaya;
  }
  
  if (categories) {
    const categoryArray = Array.isArray(categories) ? categories : [categories];
    queryObj.categories = { $in: categoryArray };
    }


    //return res.json({ books: availableBooks });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
const getReservations = async (req, res) => {
  try {
    const reservations = await Reservation.find({});
    return res.json({ reservations });
  } catch (error) {
    console.log(error);
  }
}
//_________________________________________________________________________________
//for testing purposes
const createBib = async (req, res) => {
  try {
    const bib = new Bib({
      name: req.body.name,
      avalaibleBooks: req.body.avalaibleBooks,
      reservations: req.body.reservations,
    });
    await bib.save();
    return res.json({ bib });
  } catch (error) {
    console.log(error);
  }
}
const getBooks = async (req, res) => {
  try {
    const books = await Book.find({});
    return res.json({ books });
  } catch (error) {
    console.log(error);
  }
}

const showBibs = async (req, res) => {
  try {
    const bibs = await Bib.find({});
    return res.json({ bibs });
  } catch (error) {
    console.log(error);
  }
};
module.exports = {
  getReservedBooks,
  getOnHoldBooks,
  acceptBookRequest,
  getRequestedBooks,
  requestBook,
  giveBook,
  addBook,
  checkOnHoldBooks,
  getExpiredBooks,
  createBib,
  showBibs,
  getAvailableBooks,
  getUsers,
  getReservations,
  getBooks
};
