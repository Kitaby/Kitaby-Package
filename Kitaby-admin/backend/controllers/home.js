const { query } = require("express");
const Book = require("../models/book");
const User = require("../models/user");
const Bib = require("../models/biblio");
const Offer = require("../models/offers");
const Reservation = require("../models/reservation");
const book_api = require("../middlewares/books_api");

const getCollection = async (req, res) => {
  try {
    //we got the image link in the book, schema
    const user = await User.findOne({ _id: req.params.id });
    const isbn_list = user.ownedbooks;
    const books_list = await Promise.all(
      isbn_list.map(async (isbn) => {
        const book = await Book.findOne(
          { isbn },
          { title: 1, author: 1, image: 1 }
        );

        return book;
      })
    );

    res.json({ books_list });
  } catch (error) {
    console.error("Error getting collection:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

const getWishlist = async (req, res) => {
  try {
    //we got the image link in the book, schema
    const user = await User.findOne({ _id: req.params.id });
    const isbn_list = user.wishlist;
    const books_list = await Promise.all(
      isbn_list.map(async (isbn) => {
        const book = await Book.findOne(
          { isbn },
          { title: 1, author: 1, image: 1 }
        );

        return book;
      })
    );

    res.json({ books_list });
  } catch (error) {
    console.error("Error getting collection:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

// const getWishlist =async (req,res)=>{
// }

const getBookByCategory = async (req, res) => {
  //pass the category in the req.body
};

// const getBook=async (req,res)=>{
//     const bookId=req.params.id
//     const book=await Book.findOne({_id:bookId})
//     res.status(200).json(book)

// }

const getAllBooks = async (req, res) => {
  let query = Book.find();

  const page = Number(req.query.page) || 1;
  const limit = Number(req.query.limit) || 8;

  const skip = (page - 1) * limit;

  query = query.skip(skip).limit(limit);
  const books = await query;
  const allBooks = [];

  // Iterate over each book
  books.forEach((book) => {
    // If the book has owners
    if (book.owners && book.owners.length > 0) {
      book.owners.forEach((owner) => {
        const tBook = {
          _id: book.id,
          title: book.title,
          isbn: book.isbn,
          image: book.image,
          author: book.author,
          categories: book.categories,
          owner: owner,
        };
        allBooks.push(tBook);
      });
    }
  });
  res.json({ allBooks });
};

const getBooks = async (req, res) => {
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
  // if (wilaya) {
  //   queryObj.wilaya = wilaya;
  // }
  //https://example.com/api/books?category=fiction&category=thriller&category=mystery&page=1&limit=10
  //and then i make {category}=req.query , i will get that category=[fiction,thriller,mystery]?

  if (categories) {
    const categoryArray = Array.isArray(categories) ? categories : [categories];
    queryObj.categories = { $in: categoryArray };
  }

  try {
    let query = Book.find(queryObj);

    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 8;

    const skip = (page - 1) * limit;

    query = query.skip(skip).limit(limit);
    const books = await query;
    const allBooks = [];

    // Iterate over each book
    books.forEach((book) => {
      // If the book has owners
      if (book.owners && book.owners.length > 0) {
        book.owners.forEach(async (owner) => {
          const { name: ownerName, wilaya: ownerWilaya } = await User.findById(
            owner,
            {
              name: 1,
              wilaya: 1,
            }
          );
          const tBook = {
            _id: book.id,
            title: book.title,
            isbn: book.isbn,
            image: book.image,
            author: book.author,
            categories: book.categories,
            owner: ownerName,
            wilaya: ownerWilaya,
          };
          if (wilaya == tBook.wilaya) {
            allBooks.push(tBook);
          }
        });
      }
    });
    return res.json(allBooks);
  } catch (error) {}
};
const getBookInfo = async (req, res) => {
  try {
    const book = await Book.findOne({ isbn: req.params.isbn});
    if (!book) {
      return res.status(404).json({ error: 'Book not found' });
    }
    res.send(book);
  } catch (error) {
    return res.status(500).json({ error: 'Internal server error' });
  }
};

const getLibsBooks = async (req, res) => {
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
  //https://example.com/api/books?category=fiction&category=thriller&category=mystery&page=1&limit=10
  //and then i make {category}=req.query , i will get that category=[fiction,thriller,mystery]?

  if (categories) {
    const categoryArray = Array.isArray(categories) ? categories : [categories];
    queryObj.categories = { $in: categoryArray };
  }

  try {
    let query = Book.find(queryObj);

    const page = Number(req.query.page) || 1;
    const limit = Number(req.query.limit) || 8;

    const skip = (page - 1) * limit;

    query = query.skip(skip).limit(limit);
    const books = await query;
    const allBooks = [];

    // Iterate over each book
    books.forEach((book) => {
      // If the book has owners
      if (book.bibOwners && book.bibOwners.length > 0) {
        book.bibOwners.forEach(async (bib) => {
          const { name: bibName, wilaya: bibWilaya } = await Bib.findById(bib, {
            name: 1,
            wilaya: 1,
          });
          const tBook = {
            _id: book.id,
            title: book.title,
            isbn: book.isbn,
            image: book.image,
            author: book.author,
            categories: book.categories,
            bib: bibName,
            wilaya: bibWilaya,
          };
          if (wilaya == tBook.wilaya) {
            allBooks.push(tBook);
          }
        });
      }
    });
    return res.json(allBooks);
  } catch (error) {
    console.log(error);
  }
};

//Book recommendations function:
const getRecommendations = async (req, res) => {
  try {
    const user = await User.findById(req.auth.userId);
    //get the preferred categories of the user
    const categories = user.categories;
    console.log("user categories: ",categories);
    // Fetch books that belong to preferred categories
    const books = await Book.find();
    const potentialBooks = [];

    for (let i = 0; i < books.length; i++) {
      const intersection = books[i].categories.map((category) =>
        categories.includes(category)
      );
      if (intersection) {
        potentialBooks.push(books[i]);
      }
    }
    // Calculate similarity scores and sort recommendations
    const recommendations = potentialBooks
      .map((book) => ({
        book,
        similarityScore: calculateSimilarity(book.categories, categories),
      }))
      .sort((a, b) => b.similarityScore - a.similarityScore);
    
    //console.log(recommendations.map((recommendation) => recommendation.book));
    let recommendedBooks = recommendations.map((recommendation) => recommendation.book);
    console.log(recommendedBooks);
    // Limit the number of books to 10
    
    // Log recommendations into the console
    /* recommendedBooks.forEach(book => {
      console.log(`${book.title} - Similarity Score: ${calculateSimilarity(book.categories, categories)}`);
    }); */
    const recommendedBooksPage = getRecommendationsPage(recommendedBooks, req.query.i);
    
    res.send({ rec: recommendedBooksPage });
    
  } catch (error) {
    console.error("Error getting recommendations:", error);
    throw new Error("Internal server error");
  }
};

const getRecommendationsPage = (recommendedBooks, page) => { 
  const limit = 8;
  page = Number(page);
  if (isNaN(page) || page < 1) {
    page = 1;
  }
  const skip = (page - 1) * limit;
  const recommendedBooksPage = recommendedBooks.slice(skip, skip + limit);
  return recommendedBooksPage.map((book) => {
    return {
      isbn:book.isbn,
      title: book.title,
      author: book.author, 
      image: book.image,
    }
  });
}

const calculateSimilarity = (categoriesA, categoriesB) => {
  const intersection = categoriesA.filter((category) =>
    categoriesB.includes(category)
  );
  const union = [...new Set([...categoriesA, ...categoriesB])];
  return intersection.length / union.length;
};

const addRating = async (req, res) => {
  try {
    const rating = req.body.rating;
    const comment = req.body.comment;
    const isbn = req.body.isbn;
    const user = await User.findById(req.auth.userId );
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    console.log(user);
    const username = user.name;
    const pfp = user.photo;
    // Use user's name for the username field
    console.log(username);
    const book = await Book.findOne({ isbn });
    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }
    
    // Push the review object with the correct field names
    await Book.updateOne({ isbn }, { $push: { reviews: { rating, comment, username, pfp } } });
    res.status(200).json({ message: "Rating added successfully!" });
  } catch (error) {
    console.error("Error adding rating:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const calculateRating = async (req, res) => {
  try {
    const isbn = req.params.isbn;
    const book = await Book.findOne({ isbn });
    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }
    const reviews = book.reviews;

    if (reviews.length === 0) {
      return res.status(200).json({ averageRating: "No reviews yet" });
    }

    const totalRating = reviews.reduce((total, review) => total + review.rating, 0);
    const averageRating = Math.floor(totalRating / reviews.length);

    res.status(200).json({ averageRating });
  } catch (error) {
    console.error("Error calculating rating:", error);
    res.status(500).json({ message: "Internal server error" });
  }
}

const getRatings = async (req, res) => {
  try {
    const page = req.query.page;
    const limit = 8;
    const skip = (page - 1) * limit;

    const book = await Book.findOne({ isbn: req.params.isbn });
    const ratings = book.reviews;

    if (isNaN(page) || page < 1) {
      return res.status(200).send({ratings:ratings});
    } else {
      const paginatedRatings = ratings.slice(skip, skip + limit);
      return res.status(200).send({ratings:paginatedRatings});
    }
  } catch (error) {
    console.log(error);
  }
}
const isBookOwned = async(req, res) => { 
  try {
    const isbn = req.params.isbn;
    const user = await User.findById(req.body.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const collection = user.ownedbooks;

    const wishlist = user.wishlist;

    const reservations = user.reservations;
  
    

let reservationsList = await Promise.all(
  reservations.map(async id => {
    const reservation = await Reservation.findOne({_id:id, isbn:isbn});
    //console.log("reserv", reservation);
    if (reservation){
      return {
        exists: true,
        date: reservation.date,
        status: reservation.status
      };
    } else {
      return {
        reservations: false
      };
    }
  })
)
reservationsList = reservationsList.filter((reservation) => 
  reservation.reservations !== false
);
    console.log("reservations list: ", reservationsList)
    let reservation;
    if (reservationsList.every((item) => item.reservations === false)) {
      reservation = false;
    } else {
      reservation = reservationsList[0];
    }

    //if (reservation !== false) { reservation = reservationsList[0];}
    res.status(200).json({
      collection: collection.includes(isbn),
      wishlist: wishlist.includes(isbn),
      reservation: reservation
    });

  } catch(error) {
    console.error("Error checking if book is owned:", error);
    res.status(500).json({ message: "Internal server error" });
  }
}
const isBookAvailable = async (req, res) => {
  try {
    const isbn = req.params.isbn;
    const book = await Book.findOne({ isbn })
    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }
    const offers = await Offer.find({status: "on hold"});
    const isAvailableExchange = offers.filter((offer) => offer.proposedBooks.includes(isbn)).length > 0;
    const bibs = await Bib.find();

    const isAvailableLoan = bibs.some((bib) => {
      return Array.isArray(bib.avalaibleBooks) && bib.avalaibleBooks.some((book) => book.isbn === isbn);
    });
    res.status(200).json({
      isAvailableExchange,
      isAvailableLoan
     });
  } catch (error) {
    console.error("Error checking if book is available:", error);
    res.status(500).json({ message: "Internal server error" });
  }
}

module.exports = {
  getCollection,
  getWishlist,
  getAllBooks,
  getBooks,
  //postBook,
  getBookByCategory,
  getLibsBooks,
  getRecommendations,
  addRating,
  getRatings,
  getBookInfo,
  isBookOwned,
  isBookAvailable,
  calculateRating
};
