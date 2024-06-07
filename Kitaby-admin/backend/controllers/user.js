const User = require('../models/user');
const OtpStuff=require('../models/otpstuff');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const client = require("twilio")(process.env.Twilio_accountSid,process.env.Twilio_authToken);
const otpgenerator=require("otp-generator");
const nodemailer = require('nodemailer');
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

exports.send_otp = (req, res, next) => {
    User.findOne({ phone: req.body.phone })
      .then(user => {
          if (!user) {
              const otp = otpgenerator.generate(6);
              console.log('otp:',otp)
              const ttl=60*2000
              const expires = Date.now()+ttl
              OtpStuff.findOne({phone:req.body.phone})
              .then(otpStuff => {
                  if (!otpStuff){
                      const otpstuff = new OtpStuff({
                          phone:req.body.phone,
                          expires:expires,
                          done:false
                        });
                        otpstuff.save()
                        .catch(error => res.status(400).json({ error }));
                    }
                    else {
                        otpStuff.expires=expires
                        otpStuff.done=false
                        otpStuff.save()
                        .catch(error => res.status(400).json({ error }));
                    }
                    bcrypt.hash(req.body.phone+otp,10)
                    .then(hash => {
                        client.messages
                        .create({
                            body: 'Your verification code is: '+otp,
                            messagingServiceSid: 'MGe92432c91c5158d983f705db68a1166f',
                            to: '+213'+req.body.phone
                        })
                        .then(res.status(201).json({data :hash}))
                        .catch(error=>res.status(503).json({error}));
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
            return res.status(404).json({error:'otp not sent'})
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
                    return res.status(401).json({ error: 'phone not verified' })
                  }
                  else {
                    if (!otpStuff.done) {
                        return res.status(404).json({ error: 'verify otp' })
                    }
                    bcrypt.hash(process.env.verifyLink, 10)
                    .then(link => {
                        const user = new User({
                            email: req.body.email,
                            password: hash,
                            name: req.body.name,
                            phone:req.body.phone,
                            categories:req.body.categories,
                            resetPasswordToken : undefined,
                            resetPasswordExpires : undefined,
                            verified:false,
                            verifyLink:link
                        });
                        user.save()
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
                                <h1>You just signed up, to continue using our app please click the link below </h1><br> <p> ${wlanIPv4}:3000/api/auth/verify_email?verifyLink=${link}</p>`,
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
    User.findOne({ verifyLink: req.query.verifyLink })
    .then(user => {
        if (!user) {
            return res.status(401).json({ error: 'user not found' });
        }
        user.verified=true;
        user.save()
            .then(() => res.status(200).json({ message: 'success' }))
            .catch(error => res.status(400).json({ error }));
    })
    .catch(error => res.status(500).json({ error }));
};

exports.login = (req, res, next) => {
    //body {email password}
    User.findOne({ email: req.body.email })
    .then(user => {
        if (!user) {
            return res.status(400).json({ error: 'incorrect' });
        }
        bcrypt.compare(req.body.password, user.password)
              .then(valid => {
                  if (!valid) {
                      return res.status(400).json({ error: 'incorrect' });
                  }
                  if (!user.verified){
                    bcrypt.hash(process.env.verifyLink, 10)
                    .then(link => {
                        user.verifyLink=link;
                        user.save();
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
                            <h1>You just signed up, to continue using our app please click the link below </h1><br> <p> ${wlanIPv4}:3000/api/auth/verify_email?verifyLink=${link}</p>`,
                        })
                        .then(res.status(401).json({message:"not verified"}))
                        .catch(error => res.status(500).json({ error }));
                    })
                }
                else {
                    return res.status(200).json({
                        message:"success",
                        username:user.name,
                        userpp:user.photo,
                        token: jwt.sign(
                            { userId: user._id },
                            process.env.tokenString,
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
  User.findOne({ email: req.body.email })
      .then(user => {
          if (!user) {
              return res.status(401).json({ error: 'user not found' });
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
        const otp = otpgenerator.generate(6);
        bcrypt.hash(otp,10)
        .then(hash => {
            user.resetPasswordToken = hash;
            user.resetPasswordExpires =Date.now()+60*5000
            user.save()
            .then(user => {
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
  User.findOne({ email: req.body.email,resetPasswordExpires: { $gt: Date.now() } })
      .then(user => {
          if (!user) {
              return res.status(401).json({ error: 'expired' });
          }
          bcrypt.compare(req.body.otp, user.resetPasswordToken)
          .then(valid => {
              if (!valid) {
                  return res.status(402).json({ error: 'otp incorrect' });
                }
                bcrypt.hash(req.body.password, 10)
                .then(hash => {
                    user.password = hash;
                    user.resetPasswordToken = undefined;
                    user.resetPasswordExpires = undefined;
                    user.save()
                    .then(() => res.status(200).json({ message: 'success' }))
                    .catch(error => res.status(400).json({ error }));        
                })
                .catch(error => res.status(500).json({ error }));
          })
          .catch(error => res.status(500).json({ error }));
      })
      .catch(error => res.status(500).json({ error }));
};

exports.signout = (req, res, next) => {
    req.auth = {
        userId: ''
    };
    return res.status(200).json({message:'success'})
};