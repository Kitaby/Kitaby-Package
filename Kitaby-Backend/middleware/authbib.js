const jwt = require('jsonwebtoken');
const Bib=require('../models/bib')
module.exports = async (req, res, next) => {
   try {
       const token = req.headers.authorization.split(' ')[1];
       const decodedToken = jwt.verify(token, process.env.bibtokenString);
       const bibId = decodedToken.bibId;
       const bib = await Bib.findOne({_id:bibId})
       if (!bib){
        res.status(404).json({ message:"bib not found" });
       }
       else if (bib.admis){
           req.auth = {
               bibId: bibId
           };
           next();
       }
       else {
           res.status(200).json({message:"please wait for admin admission"})
       }
   } catch(error) {
       res.status(401).json({ error });
   }
};