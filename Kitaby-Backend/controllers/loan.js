const otpgenerator=require("otp-generator");
const nodemailer = require('nodemailer');
const bcrypt = require('bcrypt');
const Otploan = require('../models/otploan')



// do not call this without having a loan id ofc ( ensure its parameters are valable )
async function send_otp_begin(loanId,user_email){
    try{
        let otploan = await Otploan.findOne({loan_id:loanId})
        const otp = otpgenerator.generate(6,{
            lowerCaseAlphabets:false,
            specialChars:false
        })
        const hash = await bcrypt.hash(loanId+otp,10)
        if (otploan){
            otploan.expires=Date.now()+60*1000*3600*24*3
        }else {
            otploan = new Otploan({
                loan_id:loanId,
                crypted_otp:hash,
                expires:Date.now()+60*1000*3600*24*3,
                done:false
            })
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
        await transporter.sendMail({
            from: '"Kitaby" <a.kaouadji@esi-sba.dz>',
            to: user_email,
            subject: "This is your otp code",
            html: `
            <h1>To start your loan, give this code to the library staff </h1><br> <p> the code in a very beautifull html box : ${otp} </p>`,
        })
        await otploan.save()
        //console.log(otp)
    }catch(error){
        //console.log(error)
        throw error
    }
}

// otp is sent by user in req
async function verify_otp_end(loanId,otp,user_email){
    try{
        const otploan = await Otploan.findOne({loan_id:loanId})
        if (otploan){
            if (Date.now()>otploan.expires){
                send_otp_begin(loanId,user_email)
                return {
                    message:"expired",
                    bool:false
                }
            }else {
                const bool = await bcrypt.compare(loanId+otp,otploan.crypted_otp)
                let message=''
                if (bool){
                    message="success"
                }else {
                    message="wrong otp"
                }
                return {
                    message:message,
                    bool:bool
                }
            }
        }else {
            return {message:"not found",bool:false}
        }
    }catch(error){
        //console.log(error)
        throw error
    }
}

module.exports={send_otp_begin,verify_otp_end}