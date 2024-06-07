const Bib = require('../models/bib');
const Book=require('../models/book')
const ExcelJS = require('exceljs');
const OtpStuff=require('../models/otpstuff');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const client = require("twilio")(process.env.Twilio_accountSid,process.env.Twilio_authToken);
const otpgenerator=require("otp-generator");
const nodemailer = require('nodemailer');
const { networkInterfaces } = require('os');

'use strict'; 
  
const nets = networkInterfaces(); 
const results = Object.create(null); // Or just '{}', an empty object 
let wlanIPv4=""; 
for (const name of Object.keys(nets)) { 
    for (const net of nets[name]) { 
        // Skip over non-IPv4 and internal (i.e. 127.0.0.1) addresses 
        // 'IPv4' is in Node <= 17, from 18 it's a number 4 or 6 
        const familyV4Value = typeof net.family === 'string' ? 'IPv4' : 4 
        if (net.family === familyV4Value && !net.internal) { 
            if (!results[name]) { 
                results[name] = []; 
            } 
            results[name].push(net.address); 
            wlanIPv4=net.address; 
        } 
    } 
} 

// const wlanIPv4 = Object.keys(networkInterfaces()).reduce((ipv4, interfaceName) => {
//     if (interfaceName.startsWith('wlan')) {
//         const interfaceInfo = networkInterfaces()[interfaceName].find(
//             info => !info.internal && info.family === 'IPv4'
//         );
//         if (interfaceInfo) {
//             return interfaceInfo.address;
//         }
//     }
//     return ipv4; 
// }, null);

const readFile = async (filePath) => {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(filePath);
    const worksheet = workbook.getWorksheet(1);  
        if(!worksheet){console.log('flag')}
    let data = [];
    worksheet.eachRow((row, rowNumber) => {
        if (rowNumber > 1) { // Skip header row (row 1)
            const isbn = row.getCell(1).value; // Assuming ISBN is in column A
            const quantity = row.getCell(2).value; // Assuming quantity is in column B
            if (isbn && quantity) { // Check if both values exist
                data.push({ isbn: isbn, quantity: quantity });
            }
        }
    });
  
    return data;
  };

const book_api = async (isbn) => {
    try {
        const url='https://www.googleapis.com/books/v1/volumes?q=isbn:'+isbn
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
        throw error; 
    }
};

const book_categories=async(isbn)=>{
    const url="https://openlibrary.org/search.json?isbn="+isbn+"&fields=subject"
    try {
        const response=await fetch(url)
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        if(data.docs[0]){
            if (data.docs[0].subject){
                return data.docs[0].subject.slice(0,5);
            }else {
                return ['no category found']
            }
        }else {
            return ['no category']
        }

    } catch (error) {
        console.error('Error fetching data:', error);
        throw error; 

    }

}

exports.send_otp = (req, res, next) => {
    Bib.findOne({ phone: req.body.phone })
      .then(bib => {
          if (!bib) {
              const otp = otpgenerator.generate(6,{
                lowerCaseAlphabets:false,
                specialChars:false,
                upperCaseAlphabets:false
            });
              console.log('otp:',otp)
              const ttl=60*2000
              const expires = Date.now()+ttl
              OtpStuff.findOne({phone:req.body.phone})
              .then(async otpStuff => {
                  if (!otpStuff){
                      const otpstuff = new OtpStuff({
                          phone:req.body.phone,
                          expires:expires,
                          done:false
                        });
                        await otpstuff.save()
                        .catch(error => res.status(400).json({ error }));
                    }
                    else {
                        otpStuff.expires=expires
                        otpStuff.done=false
                        await otpStuff.save()
                        .catch(error => res.status(400).json({ error }));
                    }
                    bcrypt.hash(req.body.phone+otp,10)
                    .then(hash => {
                        // client.messages
                        // .create({
                        //     body: 'Your verification code is: '+otp,
                        //     messagingServiceSid: 'MGe92432c91c5158d983f705db68a1166f',
                        //     to: '+213'+req.body.phone
                        // })
                        // .then(res.status(201).json({message:"success",data :hash}))
                        // .catch(error=>res.status(503).json({error}));                        
                        res.status(201).json({message:"success",data:hash})
                        })
                    .catch(error=>res.status(400).json({error}));
                    })
                .catch(error => res.status(400).json({error}));
            }
            else {
                return res.status(400).json({message:'you already have an account'})
            }
      })
      .catch(error => res.status(400).json({ error }));
};

exports.verify_otp = (req, res, next) => {
    OtpStuff.findOne({phone:req.body.phone})
    .then(otpStuff => {
        if (!otpStuff){
            return res.status(404).json({message:'otp not sent'})
        }
        const now=Date.now()
        if (now > otpStuff.expires) {return res.status(400).json({message:'expired'})}
        else {
            bcrypt.compare(req.body.phone+req.body.otp,req.body.data)
                .then(valid => {
                    if (!valid) {
                        return res.status(401).json({ message: 'fail' });
                    }
                    else {
                        otpStuff.done=true
                        otpStuff.save()
                        .then(() => res.status(200).json({ message: 'success' }))
                        .catch(error => res.status(400).json({ error }));
                    }
                })
                .catch(error => res.status(501).json({ error }));
        }
        })
    .catch(error => res.status(500).json({error}));
}; 

exports.signup = (req, res, next) => {
    bcrypt.hash(req.body.password, 10)
    .then(hash => {
        OtpStuff.findOne({phone:req.body.phone})
              .then(otpStuff => {
                if (!otpStuff){
                    return res.status(401).json({ message: 'phone not verified' })
                  }
                  else {
                    if (!otpStuff.done) {
                        return res.status(404).json({ message: 'verify otp' })
                    }
                    bcrypt.hash(process.env.verifyLink, 10)
                    .then(link => {
                        const bib = new Bib({
                            admis:false,
                            email: req.body.email,
                            password: hash,
                            name: req.body.name,
                            phone:req.body.phone,
                            address:req.body.address,
                            com_reg_num:req.body.com_reg_num,
                            avalaibleBooks:[],
                            reservations:[],
                            resetPasswordToken : undefined,
                            resetPasswordExpires : undefined,
                            verified:false,
                            verifyLink:link
                        });
                        bib.save()
                        .then(() => {
                            const transporter = nodemailer.createTransport({
                                host: "smtp.gmail.com",
                                port: 465,
                                secure: true,
                                auth: {
                                    user: process.env.EMAIL_USER,
                                    pass: process.env.EMAIL_PASS,
                                },
                            });
                            transporter.sendMail({
                                from: '"Kitaby" <a.kaouadji@esi-sba.dz>',
                                to: req.body.email,
                                subject: "Please verify your email",
                                html: `
                                <h1>You just signed up, to continue using our app please click the link below </h1><br> <p> ${wlanIPv4}:3000/api/bib/auth/verify_email?verifyLink=${link}</p>`,
                            })
                            .then(() => res.status(200).json({ message: 'success' }))
                            .catch(error => res.status(400).json({ error }));
                        })
                        .catch(error => res.status(500).json({ error }));
                    })
                    .catch(error => res.status(500).json({ error }));
                  }
              })
              .catch(error => res.status(500).json({error}));
    })
    .catch(error => res.status(500).json({ error }));
};

exports.verify_email = (req, res, next) => {
    Bib.findOne({ verifyLink: req.query.verifyLink })
    .then(bib => {
        if (!bib) {
            return res.status(401).json({ message: 'bib not found' });
        }
        bib.verified=true;
        bib.save()
            .then(() => res.status(200).json({ message: 'success' }))
            .catch(error => res.status(400).json({ error }));
    })
    .catch(error => res.status(500).json({ error }));
};

exports.login = (req, res, next) => {
    //body {email password}
    Bib.findOne({ email: req.body.email })
    .then(bib => {
        if (!bib) {
            return res.status(400).json({ message: 'incorrect' });
        }
        else if (!bib.admis){
            return res.status(400).json({message:"please wait for the administrator to accept your account"});
        }
        bcrypt.compare(req.body.password, bib.password)
              .then(valid => {
                  if (!valid) {
                      return res.status(400).json({ message: 'incorrect' });
                  }
                  if (!bib.verified){
                    bcrypt.hash(process.env.verifyLink, 10)
                    .then(link => {
                        bib.verifyLink=link;
                        bib.save();
                        const transporter = nodemailer.createTransport({
                            host: "smtp.gmail.com",
                            port: 465,
                            secure: true,
                            auth: {
                                user: process.env.EMAIL_USER,
                                pass: process.env.EMAIL_PASS,
                            },
                        });
                        transporter.sendMail({
                            from: '"Kitaby" <a.kaouadji@esi-sba.dz>',
                            to: req.body.email,
                            subject: "Please verify your email",
                            html: `
                            <h1>You just signed up, to continue using our app please click the link below </h1><br> <p> ${wlanIPv4}:3000/api/bib/auth/verify_email?verifyLink=${link}</p>`,
                        })
                        .then(res.status(401).json({message:"not verified"}))
                        .catch(error => res.status(500).json({ error }));
                    })
                }
                else {
                    return res.status(200).json({
                        message:"success",
                        bibname:bib.name,
                        bibpp:bib.photo,
                        token: jwt.sign(
                            { bibId: bib._id },
                            process.env.bibtokenString,
                            { expiresIn: '7200h' }
                        )
                    });
                }
              })
              .catch(error => res.status(500).json({ error }));
      })
      .catch(error => res.status(500).json({ error }));
};

exports.forgot_password = (req, res, next) => {
  Bib.findOne({ email: req.body.email })
      .then(bib => {
          if (!bib) {
              return res.status(401).json({ message: 'bib not found' });
          }
            const transporter = nodemailer.createTransport({
            host: "smtp.gmail.com",
            port: 465,
            secure: true,
            auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS,
            },
        });
        const otp = otpgenerator.generate(6,{
            lowerCaseAlphabets:false,
            specialChars:false,
            upperCaseAlphabets:false
        });
        bcrypt.hash(otp,10)
        .then(hash => {
            bib.resetPasswordToken = hash;
            bib.resetPasswordExpires =Date.now()+60*5000
            bib.save()
            .then(bib => {
                transporter.sendMail({
                    from: '"Kitaby" <a.kaouadji@esi-sba.dz>',
                    to: req.body.email,
                    subject: "response to reset password request",
                    html: `
                    <h1>Here is your verification code: </h1>
                    `+otp,
                  })
                  .then(() => res.status(200).json({ message: 'success' }))
                  .catch(error => res.status(400).json({ error }));
            })
            .catch(error => res.status(500).json({ error }));            
        })
        .catch(error=>res.status(500).json({error}));
      })
      .catch(error => res.status(500).json({ error }));
};

exports.reset_password = (req, res, next) => {
  Bib.findOne({ email: req.body.email,resetPasswordExpires: { $gt: Date.now() } })
      .then(bib => {
          if (!bib) {
              return res.status(401).json({ message: 'expired' });
          }
          bcrypt.compare(req.body.otp, bib.resetPasswordToken)
          .then(valid => {
              if (!valid) {
                  return res.status(402).json({ message: 'otp incorrect' });
                }
                bcrypt.hash(req.body.password, 10)
                .then(hash => {
                    bib.password = hash;
                    bib.resetPasswordToken = undefined;
                    bib.resetPasswordExpires = undefined;
                    bib.save()
                    .then(() => res.status(200).json({ message: 'success' }))
                    .catch(error => res.status(400).json({ error }));        
                })
                .catch(error => res.status(500).json({ error }));
          })
          .catch(error => res.status(500).json({ error }));
      })
      .catch(error => res.status(500).json({ error }));
};
exports.update_excel = async (req, res, next) => {
    try {
        if (!req.file) {
            return res.status(404).json({ message: 'file not sent' });
        }
        let bib = await Bib.findOne({ _id: req.auth.bibId });
        if (!bib) {
            return res.status(402).json({ message: 'who are you?' });
        }

        let savedbooks = [];
        const booksarray = await readFile('excel/' + req.auth.bibId + '.xlsx');

        // Find deleted books and update their bibOwners
        const deletedbooks = bib.avalaibleBooks.filter(oldObject => {
            return !booksarray.some(newObject => oldObject.isbn === newObject.isbn);
        });

        await Promise.all(deletedbooks.map(async X => {
            let book = await Book.findOne({ isbn: X.isbn });
            if (book) {
                book.bibOwners = book.bibOwners.filter(Y => Y.toString() !== bib._id.toString());
                await book.save();  // Ensure you save the updated book
            }
        }));
// Process books in the new list
        await Promise.all(booksarray.map(async (X) => {
            let book = await Book.findOne({ isbn: X.isbn });
            if (!book) {
                const responseData = await book_api(X.isbn);
                if (responseData.items) {
                    const { title, authors, imageLinks, description } = responseData.items[0].volumeInfo;
                    let image='https://nnp.wustl.edu/img/bookCovers/genericBookCover.jpg'
                    if (imageLinks) {image = imageLinks.thumbnail}
                    let author='katib'
                    if(authors){
                        author=authors.join(",")
                    }
                    const categories = await book_categories(X.isbn);
                    book = new Book({
                        description,
                        isbn: X.isbn,
                        title,
                        author,
                        image,
                        bibOwners: [bib._id],
                        categories,
                    });
                    await book.save();
                    savedbooks.push({ isbn: X.isbn, quantity: X.quantity });
                }
            } else {
                if (!book.bibOwners.includes(bib._id)) {
                    book.bibOwners.push(bib._id);
                    await book.save();
                }
                savedbooks.push({ isbn: X.isbn, quantity: X.quantity });
            }
        }));
        bib.avalaibleBooks = savedbooks;
        await bib.save();
        res.status(200).json({ message: 'success' });
    } catch (error) {
        console.log(error);
        res.status(500).json({ error });
    }
};
