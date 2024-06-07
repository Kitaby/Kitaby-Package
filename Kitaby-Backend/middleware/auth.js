const jwt = require('jsonwebtoken');
const User=require('../models/user')
 
module.exports = async (req, res, next) => {
   try {
       const token = req.headers.authorization.split(' ')[1];
       const decodedToken = jwt.verify(token, process.env.tokenString);
       const userId = decodedToken.userId;
       const bib = await User.findOne({_id:userId})
       if (!bib){
        res.status(404).json({ message:"user not found" });
       } else if (!bib.banned){
           req.auth = {
               userId: userId
           };
           next();
       }
       else {
           res.status(200).json({message:"you are banned, consider contacting us on email : a.kaouadji@esi-sba.dz for a possible deban"})
       }
   } catch(error) {
       res.status(401).json({ error });
   }
};