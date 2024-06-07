const Book = require("../models/book");
const User = require("../models/user");
const Reservation = require("../models/reservation");
const Bib = require("../models/bib");
const Offer = require("../models/offers");
const  { Thread, Comment , Reply , Categorie ,Report} = require('../models/forum');


const getUsers = async (req, res) => {
    try {
        const users = await User.find({banned:false});
        res.status(200).send(users);
    } catch (error) {
        console.log(error);
    }
}

const getBooks = async (req, res) => {
    try {
        const books = await Book.find();
        //getting each book's quantity in reservations and exchange and returning them as additinal informations:
        const numReservations = []
        const numExchanges = []
        for (let i = 0; i < books.length; i++) {
            const book = books[i];
            const reservations = await Reservation.find({ isbn: book.isbn});
            const exchanges = await Offer.find({ isbn: book.isbn});
            numReservations.push(reservations.length);
            numExchanges.push(exchanges.length);
        }
        //returning every book with the additional informations corresponding to it:
        const booksWithReservations = books.map((book, index) => {
            return {
                ...book._doc,
                numReservations: numReservations[index],
                numExchanges: numExchanges[index]
            }
        })
        res.send(booksWithReservations).status(200)

    } catch (error) {
        console.log(error);
    }
}

const getUserNum = async (req, res) => {
    try {
        const userNum = await User.countDocuments()

        res.json(userNum)
    } catch (error) {
        console.log(error);
    }
}
const getBookNum = async (req, res) => {
    try {
        const bookNum = await Book.countDocuments()
        //const userNum = await User.countDocuments()
        res.json(bookNum)
    } catch (error) {
        console.log(error);
    }
}
const getReservations = async (req, res) => {
    try {
        const reservations = await Reservation.find();
        res.send(reservations).status(200)
    } catch (error) {
        console.log(error);
    }
}
const getBibs = async (req, res) => {
    //hadi pour affichage des bibs admis seulement fel dashboard
    try {
        const bibs = await Bib.find();
        const admittedBibs = bibs.filter(x => x.admis);
        res.status(200).send(admittedBibs.length > 0 ? admittedBibs : bibs);
    } catch (error) {
        console.log(error);
    }
}
const getBibsNotRegistered = async (req, res) => {
    //hadi pour affichage des bibs non admis seulement fel dashboard
    try {
        const bibs = await Bib.find();
        const notAdmittedBibs = bibs.filter(x => !x.admis);
        res.status(200).send(notAdmittedBibs.length > 0 ? notAdmittedBibs : bibs);
    } catch (error) {
        console.log(error);
    }
}

const getPendingBibs = async (req, res) => { 
    //hadi pour affichage des bibs non admis seulement bach y'acceptihom
    try {
        const bibs = await Bib.find();
        const notAdmittedBibs = bibs.filter(x => !x.admis);
        res.status(200).send(notAdmittedBibs);
    } catch (error) {
        console.log(error);
    }
}

const acceptBib = async (req, res) => { 
    try {
        const name= req.params.name;
        const bib = await Bib.findOne({ name: name });
        bib.admis = true;
        await bib.save();
        res.status(200).send('Bib accepted');

    } catch (error) {
        console.log(error);
    }
}
const rejectBib = async (req, res) => { 
    try {
        const name= req.params.name;
        await Bib.deleteOne({ name: name });
        res.status(200).send('Bib rejected');
    } catch (error) {
        console.log(error);
    }
}

const getReports = async (req, res) => { 
    try {
        const reports = await Report.find();
        const updatedReports = await Promise.all(reports.map(async report => { 
            const [comment, thread, reply] = await Promise.all([
                Comment.findById(report.reported),
                Thread.findById(report.reported),
                Reply.findById(report.reported),
                
            ]);

            let reportedContent;
            if (comment) {
                reportedContent = comment.content;
            } else if (thread) {
                reportedContent = thread.content;
            } else if (reply) {
                reportedContent = reply.content;
            }
            const user = await User.findOne({ _di: report.reporter });
            let reportObject = report.toObject();
            return { ...reportObject, reported: reportedContent, reporters:user.name}
        }));
        res.status(200).send(updatedReports);
    } catch (error) {
        console.log(error);
        res.status(500).send('Internal Server Error');
    }
}
const deleteReported = async (req, res) => { 
    try {
        const reportId = req.params.id;
        const report = await Report.findById(reportId);

        if (!report) {
            return res.status(404).send('Report not found');
        }

        const [comment, thread, reply] = await Promise.all([
            Comment.findById(report.reported),
            Thread.findById(report.reported),
            Reply.findById(report.reported)
        ]);

        if (comment) {
            await Comment.deleteOne({ _id: report.reported });
        } else if (thread) {
            await Thread.deleteOne({ _id: report.reported });
        } else if (reply) {
            await Reply.deleteOne({ _id: report.reported });
        }

        await Report.deleteOne({ _id: reportId });

        res.status(200).send('Reported content and report deleted');
    } catch (error) {
        console.log(error);
        res.status(500).send('Internal Server Error');
    }
}

const banUser = async (req, res) => {
    try {
        const userId = req.params.id;
        const user = await User.findOneAndUpdate(
            { _id: userId },
            { $set: { banned: true } },
            { new: true, useFindAndModify: false } // This option returns the updated document
        );

        if (!user) {
            return res.status(404).send({ error: 'User not found' });
        }

        
    } catch (error) {
        console.error(error);
        res.status(500).send({ error: 'An error occurred while banning the user' });
    }
}

const getOffers = async (req, res) => {
    try {
        const offers = await Offer();
        res.send().status(200)
    } catch (error) {
        console.log(error);
    }
}

const getBookInfo = async (req, res) => {
    try {
        const title = req.params.title;
        const book = await Book.findOne({ title: { $regex: new RegExp(title, "i") } });

        const owners = await Promise.all(book.owners.map(async owner => { 
            const user = await User.findById(owner);
            return user.name;
        }));
        const bibOwners = await Promise.all(book.bibOwners.map(async bibOwner => { 
            const bib = await Bib.findById(bibOwner);
            return bib.name;
        }));
        res.status(200).send({ 
            ...book._doc, 
            owners: owners, 
            bibOwners: bibOwners 
        });
        
    }
    catch (error) {
        console.log(error);
    }
}
const getBibInfo = async (req, res) => {
    try {
        const title = req.params.title;
        const bib = await Bib.findOne({ name: { $regex: new RegExp(title, "i") } });
        res.status(200).send(bib);
        console.log(bib); 
    }
    catch (error) {
        console.log(error);
    }
}
const getUserInfo = async (req, res) => { 
    try {
        const user = await User.findOne({ name: req.params.name });
        console.log(user);
        const ownedBooks = await Promise.all(user.ownedbooks.map(async isbn => {
            const book = await Book.findOne({ isbn: isbn });
            return book.title ||book.name ||book.isbn;
        }));
        const wishlist = await Promise.all(user.wishlist.map(async isbn => { 
            const book = await Book.findOne({ isbn: isbn });
            return book.title ||book.name ||book.isbn;
        }))
        res.status(200).send({ 
            ...user._doc, 
            ownedBooks: ownedBooks, 
            wishlist: wishlist 
        });
    } catch (error) {
        console.log(error);
    }
}
const getBookHistory = async (req, res) => {
    try {
        const books = await Book.find();
        const bookHistory = books.map(book => {
            console.log(book.title)
            return {
                title: book.title,
                createdAt: book.createdAt,
            }
        })
        res.status(200).send(bookHistory);
    } catch (error) {
        console.log(error);
    }
} 

const getReservationHistory = async (req, res) => { 
    try {
        const reservations = await Reservation.find();
        let reservationHistory = [];
        for (let i = 9; i >= 0; i--) {
            let dayStart = new Date();
            dayStart.setDate(dayStart.getDate() - i);
            dayStart.setHours(0, 0, 0, 0);
            let dayEnd = new Date(dayStart);
            dayEnd.setHours(23, 59, 59, 999);
            let count = reservations.filter(reservation => {
                let date = new Date(reservation.date);
                return date >= dayStart && date <= dayEnd;
            }).length;
            reservationHistory.push(count);
        }
        res.status(200).send(reservationHistory);
    } catch (error) {
        console.log(error);
    }
}
const getExchangeHistory = async (req, res) => { 
    try {
        const reservations = await Offer.find();
        let reservationHistory = [];
        for (let i = 9; i >= 0; i--) {
            let dayStart = new Date();
            dayStart.setDate(dayStart.getDate() - i);
            dayStart.setHours(0, 0, 0, 0);
            let dayEnd = new Date(dayStart);
            dayEnd.setHours(23, 59, 59, 999);
            let count = reservations.filter(reservation => {
                let date = new Date(reservation.createdAt);
                return date >= dayStart && date <= dayEnd;
            }).length;
            reservationHistory.push(count);
        }
        res.status(200).send(reservationHistory);
    } catch (error) {
        console.log(error);
    }
}
const getUserHistory = async (req, res) => { 
    try {
        const reservations = await User.find();
        let reservationHistory = [];
        for (let i = 9; i >= 0; i--) {
            let dayStart = new Date();
            dayStart.setDate(dayStart.getDate() - i);
            dayStart.setHours(0, 0, 0, 0);
            let dayEnd = new Date(dayStart);
            dayEnd.setHours(23, 59, 59, 999);
            let count = reservations.filter(reservation => {
                let date = new Date(reservation.createdAt);
                return date >= dayStart && date <= dayEnd;
            }).length;
            reservationHistory.push(count);
        }
        res.status(200).send(reservationHistory);
    } catch (error) {
        console.log(error);
    }
}
const getBibHistory = async (req, res) => { 
    try {
        const reservations = await Bib.find();
        let reservationHistory = [];
        for (let i = 9; i >= 0; i--) {
            let dayStart = new Date();
            dayStart.setDate(dayStart.getDate() - i);
            dayStart.setHours(0, 0, 0, 0);
            let dayEnd = new Date(dayStart);
            dayEnd.setHours(23, 59, 59, 999);
            let count = reservations.filter(reservation => {
                let date = new Date(reservation.createdAt);
                return date >= dayStart && date <= dayEnd;
            }).length;
            reservationHistory.push(count);
        }
        res.status(200).send(reservationHistory);
    } catch (error) {
        console.log(error);
    }
}

const deleteUser = async (req, res) => {
    try {
        const userEmail = req.body.email;
        //deletedUsers.push(email);
        //await User.deleteOne({ email:userEmail });
        //res.status(200).send('User deleted');
        console.log(userEmail);
    } catch (error) {
        console.log(error);
    }
}



module.exports = {
    getUsers,
    getBooks,
    getUserNum, getBookNum,
    getReservations,
    getOffers,
    getBibs,
    getReports,
    getBookInfo,
    getBookHistory,
    getReservationHistory,
    getExchangeHistory,
    getUserHistory,
    getBibHistory,
    deleteUser,
    getBibInfo,
    getUserInfo,
    getPendingBibs,
    acceptBib,
    rejectBib,
    deleteReported,
    banUser,
    getBibsNotRegistered
}